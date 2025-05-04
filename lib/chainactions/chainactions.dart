import 'dart:convert';

import 'package:fr0gsite/chainactions/actionlist.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/cbasedtoken.dart';
import 'package:fr0gsite/datatypes/favoritecomment.dart';
import 'package:fr0gsite/datatypes/favoritetag.dart';
import 'package:fr0gsite/datatypes/globalcomment.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/globaltags.dart';
import 'package:fr0gsite/datatypes/ipfsuploadnode.dart';
import 'package:fr0gsite/datatypes/producerinfo.dart';
import 'package:fr0gsite/datatypes/report.dart';
import 'package:fr0gsite/datatypes/reportstatus.dart';
import 'package:fr0gsite/datatypes/reportvotes.dart';
import 'package:fr0gsite/datatypes/rewardcalc.dart';
import 'package:fr0gsite/datatypes/tag.dart';
import 'package:fr0gsite/datatypes/truster.dart';
import 'package:fr0gsite/datatypes/usersubscription.dart';
import 'package:fr0gsite/datatypes/userupload.dart';
import 'package:fr0gsite/datatypes/withthistag.dart';
import 'package:fr0gsite/nameconverter.dart';
import 'package:fr0gsite/datatypes/favoriteupload.dart';
import 'package:fr0gsite/datatypes/blockchainnode.dart';
import 'package:eosdart/eosdart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../datatypes/comment.dart';
import '../datatypes/upload.dart';
import '../datatypes/userconfig.dart';

import 'package:http/http.dart' as http;

//Action with EOS Blockchain
class Chainactions {
  String username = "";
  String permission = "";
  int fetchlimituploads = 400;
  int fetchlimittags = 60;

  void setusernameandpermission(String username, String permission) {
    this.username = username;
    this.permission = permission;
  }

  void setUsernameAndPermissionWithContext(context) {
    username = Provider.of<GlobalStatus>(context, listen: false).username;
    permission = Provider.of<GlobalStatus>(context, listen: false).permission;
  }

  Future<bool> transactionHandler(List<Action> actions) async {
    debugPrint("Transaction Handler is called");
    const secstorage = FlutterSecureStorage();
    String pkey = await secstorage.read(key: "pkey") ?? "NoKey";
    if (pkey == "NoKey") {
      throw "No private key found";
    }

    Blockchainnode node = chooseNode();
    EOSClient client =
        EOSClient(node.getfullurl, node.apiversion, privateKeys: [pkey]);

    Transaction transaction = Transaction();
    transaction.actions = actions;

    //Send transaction
    try {
      var temp = await client.pushTransaction(transaction,
          broadcast: true, sign: true);
      debugPrint("Transaction: $temp");
      return true;
    } catch (error) {
      debugPrint("Transaction Error: $error");
      return false;
    }
  }

  Blockchainnode chooseNode() {
    //Choose Node
    //Choose node based on ping
    //Choose node based on user location
    //Check if node is online
    return AppConfig.blockchainnodeurls
        .reduce((curr, next) => curr.prio < next.prio ? curr : next);
  }

  EOSClient geteosclient() {
    Blockchainnode node = chooseNode();
    return EOSClient(node.getfullurl, node.apiversion);
  }

  Future<bool> checkusercredentials(
      String username, String privatekey, String permission) async {
    bool logincorrect = false;

    EOSClient client = geteosclient();
    client.privateKeys = [privatekey];

    //Check if privatekey is correct
    Account? useraccountinfo;
    try {
      useraccountinfo = await client.getAccount(username);
    } catch (error) {
      throw "Username does not exist in blockchain.";
    }
    if (useraccountinfo.permissions != null) {
      for (var useraccountinfoelement in useraccountinfo.permissions!) {
        //Consider only keys that have the specified permission
        if (useraccountinfoelement.permName == permission) {
          for (var elementKeys in useraccountinfoelement.requiredAuth!.keys!) {
            client.keys.forEach((key, value) {
              var tempkey = elementKeys.key;
              if (tempkey == key) {
                logincorrect = true;
              }
            });
          }
        }
      }
    }
    if (!logincorrect) {
      throw "Username or key are not correct";
    }
    return logincorrect;
  }

  List<Authorization> getauth() {
    return [
      Authorization()
        ..actor = username
        ..permission = permission
    ];
  }

  Future<Account> getaccountinfo(String username) async {
    EOSClient client = geteosclient();
    Account accountinfo;
    try {
      accountinfo = await client.getAccount(username);
    } catch (error) {
      accountinfo = Account("notfound", 0);
    }

    return accountinfo;
  }

  Future<UserConfig> getuserconfig(String username) async {
    String nameasnumber = NameConverter.nameToUint64(username).toString();
    debugPrint("Requesting userconfig of user $username, aka. $nameasnumber");
    var userconfig = await geteosclient().getTableRows(
        AppConfig.maincontract, AppConfig.maincontract, 'userconfig',
        limit: 1,
        reverse: true,
        json: true,
        upper: nameasnumber,
        lower: nameasnumber);
    return UserConfig.fromJson(userconfig[0]);
  }

  Future<RewardCalc> getrewardtokeninfo(String username) async {
    //Account
    var getaccounts = await geteosclient().getTableRows(
      AppConfig.cbasedtokencontract,
      username,
      "accounts",
      limit: 999,
    );

    bool haveACT = false;
    bool haveFAME = false;
    bool haveTRUST = false;
    // ignore: non_constant_identifier_names
    late CbasedToken ACT;
    // ignore: non_constant_identifier_names
    late CbasedToken FAME;
    // ignore: non_constant_identifier_names
    late CbasedToken TRUST;
    double userACT = 0;
    double userFAME = 0;
    double userTRUST = 0;
    List<Future> rewardtokeninfo = [];
    for (var element in getaccounts) {
      if (element['balance'].toString().contains("ACT")) {
        haveACT = true;
        userACT = double.parse(element['balance'].toString().split(" ")[0]);
        rewardtokeninfo.add(geteosclient().getTableRow(
          AppConfig.cbasedtokencontract,
          AppConfig.rewardtoken.elementAt(0).number.toString(),
          "stat",
        ));
      }
      if (element['balance'].toString().contains("FAME")) {
        haveFAME = true;
        userFAME = double.parse(element['balance'].toString().split(" ")[0]);
        rewardtokeninfo.add(geteosclient().getTableRow(
          AppConfig.cbasedtokencontract,
          AppConfig.rewardtoken.elementAt(1).number.toString(),
          "stat",
        ));
      }
      if (element['balance'].toString().contains("TRUST")) {
        haveTRUST = true;
        userTRUST = double.parse(element['balance'].toString().split(" ")[0]);
        rewardtokeninfo.add(geteosclient().getTableRow(
          AppConfig.cbasedtokencontract,
          AppConfig.rewardtoken.elementAt(2).number.toString(),
          "stat",
        ));
      }
    }

    var results = await Future.wait(rewardtokeninfo);
    for (var element in results) {
      if (element['supply'].toString().contains("ACT")) {
        ACT = CbasedToken.fromJson(element);
      }
      if (element['supply'].toString().contains("FAME")) {
        FAME = CbasedToken.fromJson(element);
      }
      if (element['supply'].toString().contains("TRUST")) {
        TRUST = CbasedToken.fromJson(element);
      }
    }

    double cbasedsupply = 0;
    var getcbasedsystemtokens = await geteosclient().getTableRows(
      AppConfig.blockchainsystemtokencontract,
      AppConfig.maincontract,
      "accounts",
    );
    for (var element in getcbasedsystemtokens) {
      if (element['balance'].toString().contains(AppConfig.systemtoken)) {
        cbasedsupply =
            double.parse(element['balance'].toString().split(" ")[0]);
      }
    }

    RewardCalc rewardcalc = RewardCalc(
      haveFAME ? FAME.supply.amount : 0,
      haveTRUST ? TRUST.supply.amount : 0,
      haveACT ? ACT.supply.amount : 0,
      haveFAME ? userFAME : 0,
      haveTRUST ? userTRUST : 0,
      haveACT ? userACT : 0,
      cbasedsupply,
    );

    return rewardcalc;
  }

  //ToDo
  Future<List<GlobalTags>> getmixedtags() async {
    List<GlobalTags> taglist = [];
    List<Future> futures = [];
    futures.add(getnewtags());
    futures.add(getpopularglobaltags());
    futures.add(gettrendingtags());
    await Future.wait(futures).then((value) {
      taglist.addAll(value[0]);
      taglist.addAll(value[1]);
      taglist.addAll(value[2]);
    });
    //remove duplicates
    List<GlobalTags> taglistwithoutduplicates = [];
    for (var i = 0; i < taglist.length; i++) {
      bool found = false;
      for (var j = 0; j < taglistwithoutduplicates.length; j++) {
        if (taglist[i].globaltagid == taglistwithoutduplicates[j].globaltagid) {
          found = true;
          break;
        }
      }
      if (!found) {
        taglistwithoutduplicates.add(taglist[i]);
      }
    }

    return taglistwithoutduplicates;
  }

  Future<List<GlobalTags>> getpopularglobaltags() async {
    debugPrint("Requesting latest popular global tags");
    var response = await geteosclient().getTableRows(
      AppConfig.maincontract,
      AppConfig.maincontract,
      'globaltags',
      limit: fetchlimittags,
      reverse: true,
      json: true,
      keyType: 'i64',
      indexPosition: 2,
    );
    List<GlobalTags> taglist = [];
    for (var index = 0; index < response.length; index++) {
      taglist.add(GlobalTags.fromJson(response[index]));
    }
    return taglist;
  }

  Future<List<GlobalTags>> gettrendingtags() async {
    debugPrint("Requesting latest trending global tags");
    var response = await geteosclient().getTableRows(
      AppConfig.maincontract,
      AppConfig.maincontract,
      'globaltags',
      limit: fetchlimittags,
      reverse: true,
      json: true,
      keyType: 'i64',
      indexPosition: 3,
    );
    List<GlobalTags> taglist = [];
    for (var index = 0; index < response.length; index++) {
      taglist.add(GlobalTags.fromJson(response[index]));
    }
    return taglist;
  }

  Future<List<GlobalTags>> getnewtags() async {
    debugPrint("Requesting latest new global tags");
    var response = await geteosclient().getTableRows(
      AppConfig.maincontract,
      AppConfig.maincontract,
      'globaltags',
      limit: fetchlimittags,
      reverse: true,
      json: true,
      keyType: 'i64',
      indexPosition: 6,
    );
    List<GlobalTags> taglist = [];
    for (var index = 0; index < response.length; index++) {
      taglist.add(GlobalTags.fromJson(response[index]));
    }
    return taglist;
  }

  Future<GlobalTags> getglobaltagbyid(String globaltagid) async {
    debugPrint("Requesting global tag by ID $globaltagid");
    var response = await geteosclient().getTableRows(
        AppConfig.maincontract, AppConfig.maincontract, 'globaltags',
        limit: 1, json: true, lower: globaltagid);
    if (response.isEmpty) {
      throw "Global Tag not found";
    }
    return GlobalTags.fromJson(response[0]);
  }

  Future<List<Upload>> getuploadsforglobaltag(
      String globaluploadid, int limit) async {
    debugPrint(
        "Requesting Uploads for global tag $globaluploadid. Limit: $limit");
    var response = await geteosclient().getTableRows(
        AppConfig.maincontract, globaluploadid, 'withthistag',
        limit: limit, lower: "0", reverse: true, json: true);
    debugPrint("Received Uploads with this tag. Length: ${response.length}");

    List<WiththisTag> withthistaglist =
        response.map((json) => WiththisTag.fromJson(json)).toList();
    List<Future> futures = [];
    List<Upload> uploadlist = [];

    for (int i = 0; i < withthistaglist.length; i++) {
      var future =
          getupload(withthistaglist[i].uploadid.toString()).then((value) {
        uploadlist.add(value);
      });
      futures.add(future);
    }
    await Future.wait(futures);
    debugPrint("Received all Upload Metadata");

    return uploadlist;
  }

  Future<List<Upload>> getuploadsforglobaltagupperthan(
      String globaluploadid, int limit, String upperthan) async {
    debugPrint(
        "Requesting Uploads for global tag $globaluploadid. Limit: $limit, Upper than: $upperthan");
    var response = await geteosclient().getTableRows(
        'cbased', globaluploadid, 'withthistag',
        limit: limit, upper: upperthan, reverse: true, json: true);
    debugPrint("Received Uploads with this tag. Length: ${response.length}");

    List<WiththisTag> withthistaglist =
        response.map((json) => WiththisTag.fromJson(json)).toList();
    List<Future> futures = [];
    List<Upload> uploadlist = [];

    for (int i = 0; i < withthistaglist.length; i++) {
      var future =
          getupload(withthistaglist[i].uploadid.toString()).then((value) {
        uploadlist.add(value);
      });
      futures.add(future);
    }
    await Future.wait(futures);
    debugPrint("Received all Upload Metadata");

    return uploadlist;
  }

  Future<bool> actionsbeforetransaction() async {
    return true;
  }

  Future<bool> stake(String from, String to, double cpu, double net) async {
    await actionsbeforetransaction();
    String stringCPU = cpu == 0 ? "0.0000" : cpu.toStringAsFixed(AppConfig.systemtokendecimalafterdot);
    String stringNET = net == 0 ? "0.0000" : net.toStringAsFixed(AppConfig.systemtokendecimalafterdot);
    debugPrint("Staking $stringCPU CPU and $stringNET NET");
    List<Action> actions =
        stakeressources(from, to, stringCPU, stringNET, getauth());
    return transactionHandler(actions);
  }

  Future<bool> unstake(String from, String to, double cpu, double net) {
    actionsbeforetransaction();
    String stringCPU = cpu == 0 ? "0.0000" : cpu.toStringAsFixed(AppConfig.systemtokendecimalafterdot);
    String stringNET = net == 0 ? "0.0000" : net.toStringAsFixed(AppConfig.systemtokendecimalafterdot);
    debugPrint("Unstaking $stringCPU CPU and $stringNET NET");
    List<Action> actions =
        unstakeressources(from, to, stringCPU, stringNET, getauth());
    return transactionHandler(actions);
  }

  Future<bool> adduploadaction(
      String autor,
      String uploadipfshash,
      String thumbipfshash,
      String uploadtext,
      String language,
      String uploadfiletyp,
      String thumbfiletyp,
      ContentFlag contentflag) async {
    actionsbeforetransaction();

    int flag;
    switch (contentflag) {
      case ContentFlag.none:
        throw "Content Flag is none";
      case ContentFlag.sfw:
        flag = 1;
        break;
      case ContentFlag.erotic:
        flag = 2;
        break;
      case ContentFlag.brutal:
        flag = 3;
        break;
    }
    //Flag conversion

    List<Action> actions = addupload(autor, uploadipfshash, thumbipfshash,
        uploadtext, language, uploadfiletyp, thumbfiletyp, flag, getauth());
    return transactionHandler(actions);
  }

  Future<bool> addcommentreply(String autor, String commenttext,
      String parentcommentid, String language) async {
    actionsbeforetransaction();
    List<Action> actions = [
      Action()
        ..account = AppConfig.maincontract
        ..name = "addccomment"
        ..authorization = getauth()
        ..data = {
          "autor": autor,
          "text": commenttext,
          "parentcommentid": parentcommentid,
          "language": language,
        }
    ];
    return transactionHandler(actions);
  }

  Future<bool> addcomment(
      String autor, String commentext, String uploadid, String language) {
    actionsbeforetransaction();
    List<Action> actions = [
      Action()
        ..account = AppConfig.maincontract
        ..name = "addcomment"
        ..authorization = getauth()
        ..data = {
          "autor": autor,
          "text": commentext,
          "uploadid": uploadid,
          "language": language,
        }
    ];
    return transactionHandler(actions);
  }

  Future<bool> addtag(String uploadid, String tagtext) {
    actionsbeforetransaction();
    List<Action> actions = [
      Action()
        ..account = AppConfig.maincontract
        ..name = "addtag"
        ..authorization = getauth()
        ..data = {
          "autor": username,
          "uploadid": uploadid,
          "text": tagtext,
        }
    ];
    return transactionHandler(actions);
  }

  Future<bool> addreport(String autor, int typ, int contentid, int violatedrule, String reporttext) {
    // type 1 = upload, 2 = comment, 3 = tag
    actionsbeforetransaction();
    List<Action> actions = [
      Action()
        ..account = AppConfig.maincontract
        ..name = "addreport"
        ..authorization = getauth()
        ..data = {
          "autor": autor,
          "typ": typ,
          "id": contentid,
          "violatedrule": violatedrule,
          "reporttext": reporttext,
        }
    ];
    return transactionHandler(actions);
  }

  Future<bool> reportuploadwithcommunity(ReportStatus report) async {
    actionsbeforetransaction();

    var url = Uri.parse(AppConfig.reportnodes.first.getfullurl);
    debugPrint("Sending report to ${url.toString()}");

    var requestBody = jsonEncode({
      "rule": report.selectedrule.toString(),
      "type": report.reporttype.toString(),
      "contentid" : report.contentid.toString(),
      "text": report.reporttext.toString(),
    });

    try {
      var response = await http.post(url, body: requestBody, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        debugPrint('Request successful');
        return true;
      } else {
        debugPrint(
            'Request failed with status: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (error) {
      debugPrint("Error while sending report to ${url.toString()}: $error");
      return false;
    }
  }

  Future<bool> sendtoken(
      String from, String to, String amount, String memo) async {
    actionsbeforetransaction();
    List<Action> actions =
        sendtokenlistaction(from, to, amount, memo, getauth());
    return transactionHandler(actions);
  }

  Future<bool> voteupload(int uploadid, int vote) async {
    actionsbeforetransaction();
    List<Action> actions =
        actionlistvoteupload(username, uploadid, vote, getauth());

    return transactionHandler(actions);
  }

  Future<bool> votetag(String tagid, int vote) async {
    actionsbeforetransaction();
    List<Action> actions = [
      Action()
        ..account = AppConfig.maincontract
        ..name = "votetag"
        ..authorization = getauth()
        ..data = {
          "autor": username,
          "globuptagid": tagid,
          "vote": vote,
        }
    ];
    return transactionHandler(actions);
  }

  Future<bool> voteproducer (List<String> producernamelist){
    actionsbeforetransaction();
    List<Action> actions = [
      Action()
        ..account = AppConfig.blockchainsystemcontract
        ..name = "voteproducer"
        ..authorization = getauth()
        ..data = {
          "voter": username,
          "proxy": "",
          "producers": producernamelist,
        }
    ];
    return transactionHandler(actions);
  }

  // Not tested
  Future<bool> votecomment(String commentid, int vote) async {
    actionsbeforetransaction();
    List<Action> actions = [
      Action()
        ..account = AppConfig.maincontract
        ..name = "votecomment"
        ..authorization = getauth()
        ..data = {
          "autor": username,
          "commentid": commentid,
          "vote": vote,
        }
    ];
    return transactionHandler(actions);
  }

  Future<bool> addfavoriteupload(String uploadid) async {
    actionsbeforetransaction();
    List<Action> actions = [
      Action()
        ..account = AppConfig.maincontract
        ..name = "addfavorite"
        ..authorization = getauth()
        ..data = {
          "autor": username,
          "uploadid": uploadid,
        }
    ];
    return transactionHandler(actions);
  }

  Future<bool> deletefavoriteupload(String uploadid) async {
    actionsbeforetransaction();
    List<Action> actions = [
      Action()
        ..account = AppConfig.maincontract
        ..name = "delfavorite"
        ..authorization = getauth()
        ..data = {
          "autor": username,
          "uploadid": uploadid,
        }
    ];
    return transactionHandler(actions);
  }

  Future<bool> addfavoritetag(String globaltagid) async {
    debugPrint("Add favorite tag");
    actionsbeforetransaction();
    List<Action> actions = [
      Action()
        ..account = AppConfig.maincontract
        ..name = "addfavotag"
        ..authorization = getauth()
        ..data = {
          "autor": username,
          "globaltagid": globaltagid,
        }
    ];
    return transactionHandler(actions);
  }

  Future<bool> deletefavoritetag(String globaltagid) async {
    debugPrint("Delete favorite tag");
    actionsbeforetransaction();
    List<Action> actions = [
      Action()
        ..account = AppConfig.maincontract
        ..name = "delfavotag"
        ..authorization = getauth()
        ..data = {
          "autor": username,
          "globaltagid": globaltagid,
        }
    ];
    return transactionHandler(actions);
  }

  //Not tested
  Future<bool> addfavoritecomment(String commentid) async {
    actionsbeforetransaction();
    List<Action> actions = [
      Action() 
        ..account = AppConfig.maincontract
        ..name = "addfavocom"
        ..authorization = getauth()
        ..data = {
          "autor": username,
          "commentid": commentid,
        }
    ];
    return transactionHandler(actions);
  }

  //Not tested
  Future<bool> deletefavoritecomment(String commentid) async {
    actionsbeforetransaction();
    List<Action> actions = [
      Action()
        ..account = AppConfig.maincontract
        ..name = "delfavocom"
        ..authorization = getauth()
        ..data = {
          "autor": username,
          "commentid": commentid,
        }
    ];
    return transactionHandler(actions);
  }

  Future<bool> setuserprofile(
      String autor, String profilebio, String profileimageipfs, String profileimagefiletyp, String language, String otherconfigsasjson) async {
    actionsbeforetransaction();
    List<Action> actions = [
      Action()
        ..account = AppConfig.maincontract
        ..name = "setprofile"
        ..authorization = getauth()
        ..data = {
          "autor": autor,
          "profilebio": profilebio,
          "profileimageipfs": profileimageipfs,
          "profileimagefiletyp": profileimagefiletyp,
          "language": language,
          "otherconfigsasjson": otherconfigsasjson,
        }
    ];
    return transactionHandler(actions);
  }

  Future<bool> applyfortrusterrole(String autor) async {
    actionsbeforetransaction();

    String applytext = "applytruster $autor";

    List<Action> actions = [
      Action()
        ..account = AppConfig.blockchainsystemtokencontract
        ..name = "transfer"
        ..authorization = getauth()
        ..data = {
          "from": autor,
          "to": AppConfig.maincontract,
          "quantity": "10.0000 PEP",
          "memo": applytext
        }
    ];
    return transactionHandler(actions);
  }

  //-----------------Uploads-----------------

  //uint64_t get_trending() const { return token; } index 2
  //uint64_t get_user() const { return autor.value; } index 3
  //uint64_t get_popular() const { return popularid; } index 4

  Future<Upload> getupload(String uploadid) async {
    debugPrint("Requesting informatoin about Upload with ID $uploadid");
    var response = await geteosclient().getTableRows(
        AppConfig.maincontract, AppConfig.maincontract, 'uploads',
        limit: 1, json: true, lower: uploadid);

    Upload temp = Upload.fromJson(response[0]);

    return temp;
  }

  Future<List<Upload>> getnewuploads() async {
    debugPrint("Requesting latest Uploads");
    var response = await geteosclient().getTableRows(
        AppConfig.maincontract, AppConfig.maincontract, 'uploads',
        limit: fetchlimituploads, reverse: true, json: true);
    List<Upload> uploadlist = [];
    for (var index = 0; index < response.length; index++) {
      uploadlist.add(Upload.fromJson(response[index]));
    }
    return uploadlist;
  }

  Future<List<Upload>> getpopularuploads() async {
    debugPrint("Requesting latest Popular Uploads");
    var response = await geteosclient().getTableRows(
        AppConfig.maincontract, AppConfig.maincontract, 'uploads',
        limit: fetchlimituploads,
        reverse: true,
        json: true,
        keyType: 'i64',
        indexPosition: 4);
    List<Upload> uploadlist = [];
    for (var index = 0; index < response.length; index++) {
      uploadlist.add(Upload.fromJson(response[index]));
    }
    //delete all where trendid is 0
    uploadlist.removeWhere((element) => element.popularid == 0);
    return uploadlist;
  }

  Future<List<Upload>> getpopularuploadslowerthan(String popularid) async {
    debugPrint("Requesting Popular Uploads lower than $popularid");
    var response = await geteosclient().getTableRows(
        AppConfig.maincontract, AppConfig.maincontract, 'uploads',
        limit: fetchlimituploads,
        reverse: false,
        json: true,
        keyType: 'i64',
        indexPosition: 4,
        lower: popularid);
    List<Upload> uploadlist = [];
    for (var index = 0; index < response.length; index++) {
      uploadlist.add(Upload.fromJson(response[index]));
    }
    //delete all where trendid is 0
    uploadlist.removeWhere((element) => element.popularid == 0);
    return uploadlist;
  }

  Future<List<Upload>> getpopularuploadsupperthan(String popularid) async {
    debugPrint("Requesting latest Trends upper than $popularid");
    var response = await geteosclient().getTableRows(
        AppConfig.maincontract, AppConfig.maincontract, 'uploads',
        limit: fetchlimituploads,
        reverse: true,
        json: true,
        keyType: 'i64',
        indexPosition: 4,
        upper: popularid);
    List<Upload> uploadlist = [];
    for (var index = 0; index < response.length; index++) {
      uploadlist.add(Upload.fromJson(response[index]));
    }
    //delete all where trendid is 0
    uploadlist.removeWhere((element) => element.popularid == 0);
    return uploadlist;
  }

  Future<List<Upload>> gettrendinguploads() async {
    debugPrint("Requesting latest Trending Uploads");
    var response = await geteosclient().getTableRows(
        AppConfig.maincontract, AppConfig.maincontract, 'uploads',
        limit: fetchlimituploads,
        reverse: true,
        json: true,
        keyType: 'i64',
        indexPosition: 2);
    response.removeWhere((element) => element['token'] <= 1);
    List<Upload> uploadlist = [];
    for (var index = 0; index < response.length; index++) {
      uploadlist.add(Upload.fromJson(response[index]));
    }
    return uploadlist;
  }

  Future<List<Upload>> gettrendinguploadsupperthan(String trendingid) async {
    debugPrint("Requesting latest Trends upper than $trendingid");
    var response = await geteosclient().getTableRows(
        AppConfig.maincontract, AppConfig.maincontract, 'uploads',
        limit: fetchlimituploads,
        reverse: true,
        json: true,
        keyType: 'i64',
        indexPosition: 2,
        upper: trendingid);
    response.removeWhere((element) => element['token'] <= 1);
    List<Upload> uploadlist = [];
    for (var index = 0; index < response.length; index++) {
      uploadlist.add(Upload.fromJson(response[index]));
    }
    return uploadlist;
  }

  Future<List<Upload>> getnewuploadslowerthan(String uploadid) async {
    debugPrint("Requesting latest Uploads lower than $uploadid");
    var response = await geteosclient().getTableRows(
        AppConfig.maincontract, AppConfig.maincontract, 'uploads',
        limit: fetchlimituploads, reverse: false, json: true, lower: uploadid);
    List<Upload> uploadlist = [];
    for (var index = 0; index < response.length; index++) {
      uploadlist.add(Upload.fromJson(response[index]));
    }
    return uploadlist;
  }

  Future<List<Upload>> getnewuploadsupperthan(String uploadid) async {
    debugPrint("Requesting latest Uploads upper than $uploadid");
    var resonse = await geteosclient().getTableRows(
        AppConfig.maincontract, AppConfig.maincontract, 'uploads',
        limit: fetchlimituploads, reverse: true, json: true, upper: uploadid);
    List<Upload> uploadlist = [];
    for (var index = 0; index < resonse.length; index++) {
      uploadlist.add(Upload.fromJson(resonse[index]));
    }
    return uploadlist;
  }

  Future<List<FavoriteUpload>> getfavoriteuploadsofuser(String username) async {
    debugPrint("Requesting favorite uploads of user $username");
    bool receivedall = false;
    BigInt lowerbond = BigInt.zero;
    List<FavoriteUpload> uploadlist = [];

    while (!receivedall) {
      var response = await geteosclient().getTableRows(
          AppConfig.maincontract, username, 'userfavorite',
          limit: 500, reverse: true, json: true, lower: lowerbond.toString());
      for (var index = 0; index < response.length; index++) {
        uploadlist.add(FavoriteUpload.fromJson(response[index]));
      }
      if (response.length < 200) {
        receivedall = true;
      } else {
        lowerbond = uploadlist.last.uploadid;
      }
    }

    var response = await geteosclient().getTableRows(
        AppConfig.maincontract, username, 'userfavorite',
        limit: 200, reverse: true, json: true);
    for (var index = 0; index < response.length; index++) {
      uploadlist.add(FavoriteUpload.fromJson(response[index]));
    }
    return uploadlist;
  }

  Future<List<Comment>> getfavoritecommentsofuser(String username) async {
    debugPrint("Requesting favorite comments of user $username");
    var response = await geteosclient().getTableRows(
        AppConfig.maincontract, username, 'userfavocom',
        limit: 200, reverse: true, json: true);

    List<FavoriteComment> favoritetlist = [];
    for (var index = 0; index < response.length; index++) {
      favoritetlist.add(FavoriteComment.fromJson(response[index]));
    }
    
    List<Future<Comment>> commentfutures = [];
    for (int i = 0; i < favoritetlist.length; i++) {
      Future<Comment> future = getcommentbyglobalid(favoritetlist[i].commentid.toString());
      commentfutures.add(future);
    }
    List<Comment> commentlist = await Future.wait(commentfutures);

    return commentlist;
  }

  Future<List<FavoriteTag>> getfavoritetagsofuser(String username) async {
    debugPrint("Requesting favorite tags of user $username");
    var response = await geteosclient().getTableRows(
        AppConfig.maincontract, username, 'userfavotags',
        limit: 200, reverse: true, json: true);
    List<FavoriteTag> taglist = [];
    for (var index = 0; index < response.length; index++) {
      taglist.add(FavoriteTag.fromJson(response[index]));
    }

    List<Future> futures = [];
    for (int i = 0; i < taglist.length; i++) {
      var future = getglobaltagbyid(taglist[i].globaltagid.toString())
          .then((value) => taglist[i].globaltagname = value.text);
      futures.add(future);
    }

    await Future.wait(futures);
    return taglist;
  }

  Future<bool> isglobaltagfavorite(String username, String globaltagid) async {
    debugPrint("Requesting if global tag $globaltagid is favorite of $username");
    var response = await geteosclient().getTableRows(
        AppConfig.maincontract, username, 'userfavotags',
        limit: 1, reverse: true, json: true, lower: globaltagid);
    if (response.isEmpty) {
      return false;
    } else {
      //Compare id, conert to big int first
      if (BigInt.parse(response[0]['globaltagid']) ==
          BigInt.parse(globaltagid)) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<List<Upload>> getuploadsfromuser(String username, int limit) async {
    debugPrint("Requesting all uploads made by user $username");
    var response = await geteosclient().getTableRows(
      AppConfig.maincontract,
      username,
      "useruploads",
      limit: limit,
    );
    List<UserUpload> useruploadlist = [];
    if (response.isNotEmpty) {
      for (var index = 0; index < response.length; index++) {
        useruploadlist.add(UserUpload.fromJson(response[index]));
      }
    }
    List<Upload> uploadlist = [];
    List<Future> futures = [];
    for (int i = 0; i < useruploadlist.length; i++) {
      var future =
          getupload(useruploadlist[i].uploadid.toString()).then((value) {
        uploadlist.add(value);
      });
      futures.add(future);
    }
    await Future.wait(futures);
    debugPrint("Received all Upload Metadata");
    return uploadlist;
  }

  Future<List<Upload>> getuploadsfromuserlowerthan(
      String username, int limit, String uploadid) async {
    debugPrint(
        "Requesting all uploads made by user $username lower than $uploadid");
    var response = await geteosclient().getTableRows(
        AppConfig.maincontract, username, 'useruploads',
        limit: limit, reverse: false, json: true, lower: uploadid);
    List<UserUpload> useruploadlist = [];
    for (var index = 0; index < response.length; index++) {
      useruploadlist.add(UserUpload.fromJson(response[index]));
    }
    List<Upload> uploadlist = [];
    List<Future> futures = [];
    for (int i = 0; i < useruploadlist.length; i++) {
      var future =
          getupload(useruploadlist[i].uploadid.toString()).then((value) {
        uploadlist.add(value);
      });
      futures.add(future);
    }
    await Future.wait(futures);
    debugPrint("Received all Upload Metadata");
    return uploadlist;
  }

  Future<List<Upload>> getuploadsfromuserupperthan(
      String username, int limit, String uploadid) async {
    debugPrint(
        "Requesting all uploads made by user $username upper than $uploadid");
    var response = await geteosclient().getTableRows(
        AppConfig.maincontract, username, 'useruploads',
        limit: limit, reverse: true, json: true, upper: uploadid);
    List<UserUpload> useruploadlist = [];
    for (var index = 0; index < response.length; index++) {
      useruploadlist.add(UserUpload.fromJson(response[index]));
    }
    List<Upload> uploadlist = [];
    List<Future> futures = [];
    for (int i = 0; i < useruploadlist.length; i++) {
      var future =
          getupload(useruploadlist[i].uploadid.toString()).then((value) {
        uploadlist.add(value);
      });
      futures.add(future);
    }
    await Future.wait(futures);
    debugPrint("Received all Upload Metadata");
    return uploadlist;
  }


  Future<bool> isuserfollowinguser(
      String username, String usernametofollow) async {
    String usernameasnumber =
        NameConverter.nameToUint64(usernametofollow).toString();
    debugPrint("Requesting if user $username is following $usernametofollow");
    var response = await geteosclient().getTableRows(
        AppConfig.maincontract, username, 'usersubscrip',
        limit: 100, reverse: false, json: true, lower: usernameasnumber);
    if (response.isEmpty) {
      return false;
    } else {
      if (response[0]['username'] == usernametofollow) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<List<Usersubscription>> getusersubscriptions(String username) async {
    debugPrint("Requesting subscriptions of user $username");
    var response = await geteosclient().getTableRows(
        AppConfig.maincontract, username, 'usersubscrip',
        limit: 200, reverse: true, json: true);
    List<Usersubscription> subscriptionlist =
        response.map((json) => Usersubscription.fromJson(json)).toList();
    return subscriptionlist;
  }

  // -- Truster / Report -- #

  Future<List<Truster>> gettrusters() async {
    debugPrint("Requesting all trusters");
    var response = await geteosclient().getTableRows(
        AppConfig.maincontract, AppConfig.maincontract, 'trusters',
        limit: AppConfig.maxtrusterlist, reverse: true, json: true);
    List<Truster> trusterlist = [];
    for (var index = 0; index < response.length; index++) {
      trusterlist.add(Truster.fromJson(response[index]));
    }
    return trusterlist;
  }

  Future<Truster> gettruster(String trustername) async {
    debugPrint("Requesting truster info of $trustername");
    var response = await geteosclient().getTableRows(
        AppConfig.maincontract, AppConfig.maincontract, 'trusters',
        limit: 1, json: true, lower: NameConverter.nameToUint64(trustername).toString(), upper: NameConverter.nameToUint64(trustername).toString());
    if (response.isEmpty) {
      debugPrint("Truster not found");
      return Truster.dummy();
    }
    return Truster.fromJson(response[0]);
  }

  Future<List<Report>> getreports() async {
    debugPrint("Requesting all reports");
    var response = await geteosclient().getTableRows(
      AppConfig.maincontract, AppConfig.maincontract, 'reports',limit: 10000, reverse: true, json: true);
    List<Report> reportlist = [];
    if (response.isNotEmpty) {
      for (var index = 0; index < response.length; index++) {
        reportlist.add(Report.fromJson(response[index]));
      }
    }
    return reportlist;
  }

  Future<Report> getreport(String reportid) async {
    debugPrint("Requesting report info of $reportid");
    var response = await geteosclient().getTableRows(
        AppConfig.maincontract, AppConfig.maincontract, 'reports',
        limit: 1, json: true, lower: reportid, upper: reportid);
    if (response.isEmpty) {
      debugPrint("Report not found");
      throw "Report not found";
    }
    return Report.fromJson(response[0]);
  }

  Future<List<ReportVotes>> getreportvotes(String reportid) async {
    debugPrint("Requesting report votes of report $reportid");
    var response = await geteosclient().getTableRows(
        AppConfig.maincontract, reportid, 'reportvotes',
        limit: 100, reverse: true, json: true);
    List<ReportVotes> reportvoteslist = [];
    for (var index = 0; index < response.length; index++) {
      reportvoteslist.add(ReportVotes.fromJson(response[index]));
    }
    return reportvoteslist;
  }

  Future<bool> claimreward(String accountName, String symbol) {
    debugPrint("Claiming reward");
    List<Action> actions = [
      Action()
        ..account = AppConfig.maincontract
        ..name = "claimrewards"
        ..authorization = getauth()
        ..data = {
          "autor": accountName,
          "symbol": symbol,
        }
    ];
    return transactionHandler(actions);
  }

  Future<bool> followuser(String usernametofollow) async {
    debugPrint("Following user $usernametofollow");
    List<Action> actions = [
      Action()
        ..account = AppConfig.maincontract
        ..name = "addsubscrip"
        ..authorization = getauth()
        ..data = {
          "autor": username,
          "follow": usernametofollow,
        }
    ];
    return transactionHandler(actions);
  }

  Future<bool> unfollowuser(String usernametounfollow) async {
    debugPrint("Unfollowing user $usernametounfollow");
    List<Action> actions = [
      Action()
        ..account = AppConfig.maincontract
        ..name = "delsubscrip"
        ..authorization = getauth()
        ..data = {
          "autor": username,
          "unfollow": usernametounfollow,
        }
    ];
    return transactionHandler(actions);
  }

  Future<List<Tag>> fetchTags(String uploadid) async {
    List<Tag> taglist = [];
    var response = await geteosclient().getTableRows(
        AppConfig.maincontract, uploadid, 'tags',
        limit: 200, reverse: false, json: true);
    for (var index = 0; index < response.length; index++) {
      taglist.add(Tag.fromJson(response[index]));
    }
    return taglist;
  }

  //-----------------Blockproducer-----------------#

  Future<List<ProducerInfo>> getproducerlist() async {
    debugPrint("Requesting producer info");
    List<ProducerInfo> producerinfo = [];
    var response = await geteosclient()
        .getTableRows(AppConfig.blockchainsystemcontract,AppConfig.blockchainsystemcontract, 'producers', limit: 300, json: true);
    try {
      for (var index = 0; index < response.length; index++) {
        producerinfo.add(ProducerInfo.fromJson(response[index]));
      }
    } catch (e) {
      debugPrint("Error while fetching producer info: $e");
      producerinfo = [];
    }
    return producerinfo;
  }

  //-----------------IPFS Community Node -----------------#

  Future<bool> getslot(context, String contractname, String pubkey) async {
    setUsernameAndPermissionWithContext(context);
    actionsbeforetransaction();
    List<Action> actions = [
      Action()
        ..account = contractname
        ..name = "getslot"
        ..authorization = getauth()
        ..data = {
          "accountname": username,
          "pubkey": pubkey,
        }
    ];
    return transactionHandler(actions);
  }

  Future<bool> setsec(String contractname, String pubkey) async {
    actionsbeforetransaction();
    List<Action> actions = [
      Action()
        ..account = contractname
        ..name = "setsec"
        ..authorization = getauth()
        ..data = {
          "accountname": username,
          "pubkey": pubkey,
        }
    ];
    return transactionHandler(actions);
  }

  Future<int> getslotprice(IPFSUploadNode node) async {
    //Request Table
    var response = await geteosclient().getTableRows(
        node.accountname, node.accountname, 'configs',
        json: true);
    // find value with id 10
    int priceforslot = 0;
    for (var element in response) {
      if (element['id'].toString() == "10") {
        priceforslot = int.parse(element['intvalue'].toString());
      }
    }
    return priceforslot;
  }
}

//-----------------Comments-----------------

Future<List<Comment>> fetchComments(String uploadid) async {
  //Find out how many comments the upload have
  Upload requestedupload = await Chainactions().getupload(uploadid);
  int numofcomments = requestedupload.numofcomments;
  debugPrint("Upload $uploadid has $numofcomments comments");
  if (numofcomments == 0) {
    return [];
  } //No comments available

  bool requestcomplete = false;
  int lastcommentid = 0;
  List<Comment> completecommentlist = [];
  while (!requestcomplete) {
    try {
      var response = await Chainactions().geteosclient().getTableRows(
          AppConfig.maincontract, uploadid, 'comments',
          limit: 200,
          reverse: false,
          json: true,
          lower: lastcommentid.toString());
      List<Comment> commentlist =
          response.map((json) => Comment.fromJson(json, int.parse(uploadid))).toList();
      completecommentlist.addAll(commentlist);
      if (completecommentlist.length >= numofcomments) {
        requestcomplete = true;
      } else {
        lastcommentid = completecommentlist.last.commentId;
        completecommentlist.removeLast();
      }
    } catch (error) {
      requestcomplete = true;
      debugPrint("Error while fetching comments: $error");
    }
  }

  return completecommentlist;
}

Future<Comment> getcommentbyglobalid(String commentid) async {
  var globcommentsresponse = await Chainactions().geteosclient().getTableRows(
      AppConfig.maincontract, AppConfig.maincontract, 'globcomments',
      limit: 1, json: true, lower: commentid);
    GlobalComments globalcomment = GlobalComments.fromJson(globcommentsresponse[0]);
    //get comment from upload
    var commentsresponse = await Chainactions().geteosclient().getTableRows(
        AppConfig.maincontract, globalcomment.uploadid.toString(), 'comments',
        limit: 1, json: true, lower: commentid);
    Comment comment = Comment.fromJson(commentsresponse[0], globalcomment.uploadid);
    return comment;
}

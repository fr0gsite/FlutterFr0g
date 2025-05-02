import 'dart:convert';

import 'package:fr0gsite/chainactions/actionlist.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/cbasedtoken.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/userconfig.dart';
import 'package:fr0gsite/datatypes/rewardcalc.dart';
import 'package:fr0gsite/datatypes/usersubscription.dart';
import 'package:fr0gsite/datatypes/userupload.dart';
import 'package:fr0gsite/nameconverter.dart';
import 'package:fr0gsite/datatypes/favoriteupload.dart';
import 'package:fr0gsite/datatypes/favoritecomment.dart';
import 'package:fr0gsite/datatypes/favoritetag.dart';
import 'package:provider/provider.dart';
import 'package:eosdart/eosdart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

class UserActions {
  String username = "";
  String permission = "";

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

  Future<List<Usersubscription>> getusersubscriptions(String username) async {
    debugPrint("Requesting subscriptions of user $username");
    var response = await geteosclient().getTableRows(
        AppConfig.maincontract, username, 'usersubscrip',
        limit: 200, reverse: true, json: true);
    List<Usersubscription> subscriptionlist =
        response.map((json) => Usersubscription.fromJson(json)).toList();
    return subscriptionlist;
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
}

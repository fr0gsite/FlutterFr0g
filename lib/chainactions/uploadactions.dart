import 'dart:convert';

import 'package:fr0gsite/chainactions/actionlist.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globaltags.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:fr0gsite/datatypes/withthistag.dart';
import 'package:eosdart/eosdart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UploadActions {
  String username = "";
  String permission = "";
  int fetchlimituploads = 400;
  int fetchlimittags = 60;

  void setusernameandpermission(String username, String permission) {
    this.username = username;
    this.permission = permission;
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

  List<Authorization> getauth() {
    return [
      Authorization()
        ..actor = username
        ..permission = permission
    ];
  }

  Future<bool> actionsbeforetransaction() async {
    return true;
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

  Future<bool> voteupload(int uploadid, int vote) async {
    actionsbeforetransaction();
    List<Action> actions =
        actionlistvoteupload(username, uploadid, vote, getauth());

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
}

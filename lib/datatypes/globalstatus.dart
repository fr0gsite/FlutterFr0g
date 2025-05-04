import 'dart:async';

import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/comment.dart';
import 'package:fr0gsite/datatypes/favoritetag.dart';
import 'package:fr0gsite/datatypes/favoriteupload.dart';
import 'package:fr0gsite/datatypes/localuserconfig.dart';
import 'package:fr0gsite/datatypes/blockchainnode.dart';
import 'package:fr0gsite/datatypes/userconfig.dart';
import 'package:eosdart/eosdart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fr0gsite/datatypes/usersubscription.dart';
import 'package:fr0gsite/nameconverter.dart';

class GlobalStatus extends ChangeNotifier {
  //Global Status
  bool fiststart = true;
  bool showedHomeFirstAnimation = false;
  bool showedPostViewerFirstAnimation = false;
  int currentpage = 0;
  int currentuploadflag = 0;
  Platformdetectionstatus platform = Platformdetectionstatus.unknown;

  //User Session
  bool isLoggedin = false;
  Account useraccount = Account("Dummy", 0);
  String username = "";
  String permission = "";
  UserConfig userconfig = UserConfig.dummy();
  LocalUserConfig localuserconfig = LocalUserConfig.dummy();

  //User Favorites
  List<FavoriteUpload> favorituploads = [];
  DateTime lastfavoriteupload = DateTime.parse("2000-01-01 00:00:00.000000");

  List<Comment> favoritecomments = [];
  DateTime lastfavoritecomment = DateTime.parse("2000-01-01 00:00:00.000000");
  
  List<FavoriteTag> favoritetags = [];
  DateTime lastfavoritetag = DateTime.parse("2000-01-01 00:00:00.000000");

  //Subscriptions
  List<Usersubscription> subscriptions = [];
  DateTime lastsubscription = DateTime.parse("2000-01-01 00:00:00.000000");

  //List
  List<Blockchainnode> nodelist = [];
  List<UserConfig> userconfiglist = [];

  //Request
  DateTime lastrequest = DateTime.now();

  bool expandedpostviewer = false;
  bool expandedtagview = true;
  bool expandhomenavigationbar = true;

  bool audionotifications = true;

  GlobalStatus() {
    debugPrint("GlobalStatus: init");
    getUserTimezone();
  }

  void setPlatform(Platformdetectionstatus platform) {
    this.platform = platform;
  }

  void toggleexpandedpostviewer() {
    expandedpostviewer = !expandedpostviewer;
    notifyListeners();
  }

  void checkScreenSize(double width) {
    if (expandedpostviewer) {
      expandedpostviewer = width >= minimumscreenwidthforcommentsidebar;
      notifyListeners();
    }
  }

  void toggleexpandedtagview() {
    expandedtagview = !expandedtagview;
    notifyListeners();
  }

  void setexpandhomenavigationbar(bool value) {
    expandhomenavigationbar = value;
    notifyListeners();
  }

  void login(String username, String permission) {
    this.username = username;
    this.permission = permission;
    isLoggedin = true;
    Chainactions().getaccountinfo(username).then((value) {
      debugPrint("received accountinfo for $username");
      useraccount = value;
    });
    updateuserconfig();

    notifyListeners();
  }

  void logout() {
    const secstorage = FlutterSecureStorage();
    secstorage.delete(key: 'username');
    secstorage.delete(key: 'pkey');
    userconfig = UserConfig.dummy();
    useraccount = Account("Dummy", 0);

    username = "";
    isLoggedin = false;
    notifyListeners();
  }

  GlobalStatus getglobalstatus() {
    return this;
  }

  double cpu = 0.0;
  double net = 0.0;
  double ram = 0.0;

  int actmax = 100;
  int acttoken = 0;
  double act = 0.0;

  void updateaccountinfo() {
    if (isLoggedin) {
      Chainactions().getaccountinfo(username).then((value) {
        debugPrint("getaccountinfo for $username");
        useraccount = value;
        cpu = useraccount.cpuLimit!.used! / useraccount.cpuLimit!.max!;
        net = useraccount.netLimit!.used! / useraccount.netLimit!.max!;
        ram = useraccount.ramUsage! / useraccount.ramQuota!;
        notifyListeners();
      });
    }
  }

  void updateuseraccount(Account account) {
    if (isLoggedin) {
      useraccount = account;
    }
  }

  void updateuserconfig() {
    if (isLoggedin) {
      Chainactions().getuserconfig(username).then((value) {
        debugPrint("GlobalStatus: updateuserconfig for $username");
        userconfig = value;
        acttoken = value.acttoken;
        act = value.acttoken / AppConfig.acttokenresetvalue;
        notifyListeners();
      });
    }
  }

  void setlocaluserconfig(LocalUserConfig userconfig) {
    localuserconfig = userconfig;
  }

  void setaudionotifications(bool value) {
    audionotifications = value;
    notifyListeners();
  }

  //--------------Management of Favorite Uploads, Comments, Tags--------------

  Future<bool> isuploadinfavorites(BigInt uploadid) async {
    if (isLoggedin) {
      if (DateTime.now().difference(lastfavoriteupload).inMinutes >
          AppConfig.refreshuserfavoriteupload) {
        await Chainactions().getfavoriteuploadsofuser(username).then((value) {
          favorituploads = value;
          lastfavoriteupload = DateTime.now();
        });
      }
      for (var item in favorituploads) {
        if (item.uploadid == uploadid) {
          return true;
        }
      }
    }
    return false;
  }

  Future<List<FavoriteUpload>> getfavoriteuploads() async {
    if (isLoggedin) {
      if (DateTime.now().difference(lastfavoriteupload).inMinutes >
          AppConfig.refreshuserfavoriteupload) {
        await Chainactions().getfavoriteuploadsofuser(username).then((value) {
          favorituploads = value;
          lastfavoriteupload = DateTime.now();
        });
      }
      return favorituploads;
    }
    return [];
  }

  bool addfavoriteupload(FavoriteUpload upload) {
    if (isLoggedin) {
      if (!favorituploads.contains(upload)) {
        favorituploads.add(upload);
        return true;
      }
    }
    return false;
  }

  bool delfavoriteupload(FavoriteUpload upload) {
    if (isLoggedin) {
      if (favorituploads.contains(upload)) {
        favorituploads.remove(upload);
        return true;
      }
    }
    return false;
  }

  Future<bool> iscommentinfavorites(int commentid) async {
    if (isLoggedin) {
      if (DateTime.now().difference(lastfavoritecomment).inMinutes >
          AppConfig.refreshuserfavoritecomment) {
        await Chainactions().getfavoritecommentsofuser(username).then((value) {
          favoritecomments = value;
          lastfavoritecomment = DateTime.now();
        });
      }
      for (var item in favoritecomments) {
        if (item.commentId == commentid) {
          return true;
        }
      }
    }
    return false;
  }

  Future<List<Comment>> getfavoritecomments() async {
    if (isLoggedin) {
      if (DateTime.now().difference(lastfavoritecomment).inMinutes >
          AppConfig.refreshuserfavoritecomment) {
        await Chainactions().getfavoritecommentsofuser(username).then((value) {
          favoritecomments = value;
          lastfavoritecomment = DateTime.now();
        });
      }
      return favoritecomments;
    }
    return [];
  }

  bool addfavoritecomment(Comment comment) {
    if (isLoggedin) {
      if (!favoritecomments.contains(comment)) {
        favoritecomments.add(comment);
        return true;
      }
    }
    return false;
  }

  Future<bool> istaginfavorites(BigInt globaltagid) async {
    if (isLoggedin) {
      if (DateTime.now().difference(lastfavoritetag).inMinutes >
          AppConfig.refreshuserfavoritetags) {
        await Chainactions().getfavoritetagsofuser(username).then((value) {
          favoritetags = value;
          lastfavoritetag = DateTime.now();
        });
      }
      for (var item in favoritetags) {
        if (item.globaltagid == globaltagid) {
          return true;
        }
      }
    }
    return false;
  }

  Future<List<FavoriteTag>> getfavoritetags() async {
    if (isLoggedin) {
      if (DateTime.now().difference(lastfavoritetag).inMinutes >
          AppConfig.refreshuserfavoritetags) {
        await Chainactions().getfavoritetagsofuser(username).then((value) {
          favoritetags = value;
          lastfavoritetag = DateTime.now();
        });
      }
      return favoritetags;
    }
    return [];
  }

  // ------------------Subscriptions------------------
  Future<bool> isusersubscribed(String username) async {
    debugPrint("check if $username is subscribed");
    if (isLoggedin) {
      if (DateTime.now().difference(lastsubscription).inMinutes >
          AppConfig.refreshusersubscriptions) {
        await Chainactions().getusersubscriptions(this.username).then((value) {
          subscriptions = value;
          lastsubscription = DateTime.now();
        });
      }
      for (var item in subscriptions) {
        if (item.username == username) {
          return true;
        }
      }
    }
    return false;
  }

  Future<List<Usersubscription>> getusersubscriptions() async {
    if (isLoggedin) {
      if (DateTime.now().difference(lastsubscription).inMinutes >
          AppConfig.refreshusersubscriptions) {
        await Chainactions().getusersubscriptions(username).then((value) {
          subscriptions = value;
          lastsubscription = DateTime.now();
        });
      }
      return subscriptions;
    }
    return [];
  }

  bool addusersubscription(String username) {
    if (isLoggedin) {
      if (!subscriptions.firstWhere(
              (element) => element.username == username,
              orElse: () => Usersubscription.dummy())
          .username
          .isNotEmpty) {
        subscriptions.add(Usersubscription(subscriptionid: NameConverter.nameToUint64(username), username: username,creationtime: DateTime.now()));
        debugPrint("Added local subscription $username");
        return true;
      }
    }
    return false;
  }

  bool delusersubscription(String subscription) {
    if (isLoggedin) {
      if (subscriptions.firstWhere(
              (element) => element.username == subscription,
              orElse: () => Usersubscription.dummy())
          .username
          .isNotEmpty) {
        subscriptions.removeWhere((element) => element.username == subscription);
        debugPrint("Removed local subscription $subscription");
        return true;
      }
    }
    return false;
  }


  Duration getUserTimezone() {
    final now = DateTime.now();
    final timezone = now.timeZoneName;
    final timezoneOffset = now.timeZoneOffset;

    debugPrint('Usertime $timezone');
    debugPrint('Usertime Offset $timezoneOffset');
    return timezoneOffset;
  }

  bool addfavoritetag(FavoriteTag tag) {
    if (isLoggedin) {
      if (!favoritetags.contains(tag)) {
        favoritetags.add(tag);
        return true;
      }
    }
    return false;
  }
}

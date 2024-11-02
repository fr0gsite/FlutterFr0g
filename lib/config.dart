import 'package:fr0gsite/datatypes/game.dart';
import 'package:fr0gsite/datatypes/ipfsnode.dart';
import 'package:fr0gsite/datatypes/ipfsuploadnode.dart';
import 'package:fr0gsite/datatypes/reportnode.dart';
import 'package:fr0gsite/datatypes/rewardtoken.dart';
import 'package:fr0gsite/datatypes/blockchainnode.dart';
import 'package:flutter/material.dart';

class AppColor {
  static const Color nicewhite = Color.fromARGB(255, 230, 230, 230);
  //static const Color niceblack = Color(0xFF060716);
  static const Color niceblack = Color(0xFF060716);
  //static const Color nicegrey = Color(0xFF161722);
  static const Color nicegrey = Color(0xFF161722);
  static const Color textcolor = Color(0xFFFFFFFF);
  static Color tagcolor = Colors.blue.withOpacity(0.2);
}

class Statuscolor {
  static const Color normal = Colors.blue;
  static const Color truster = Colors.green;
  static const Color blocked = Colors.grey;
  static const Color blockproducer = Colors.yellow;
  static const Color influencer = Colors.red;
  static const Color company = Colors.teal;
}

BoxDecoration gloabltabindicator = BoxDecoration(
  borderRadius: BorderRadius.circular(20),
  color: Colors.white.withOpacity(0.2),
);

List<Color> commentLevelColor = [
  AppColor.niceblack,
  AppColor.niceblack,
  Colors.green,
  Colors.blue,
  Colors.yellow,
  Colors.red,
  Colors.teal,
  Colors.blue,
  Colors.yellow,
  Colors.red,
  Colors.teal,
  Colors.blue,
  Colors.yellow,
  Colors.red,
  Colors.teal,
  Colors.blue,
  Colors.yellow,
  Colors.red,
];

class Ressourcecolor {
  static const Color background = Colors.grey;
  static const Color ram = Colors.deepPurple;
  static const Color net = Colors.blue;
  static const Color cpu = Colors.red;
  static const Color act = Colors.green;
}

const defauldtextstyle = TextStyle(color: AppColor.textcolor, fontSize: 20);
const textstyleTitle = TextStyle(color: AppColor.textcolor, fontSize: 30);
const textstyleNormal = TextStyle(color: AppColor.textcolor, fontSize: 20);
const textstyleSmall = TextStyle(color: AppColor.textcolor, fontSize: 10);

const cubetextstyle = TextStyle(color: AppColor.textcolor, fontSize: 15);

//Postviwer
const iconsize = 55.0;
const textsize = 30.0;
const minimumscreenwidthforcommentsidebar = 1200.0;

const selfurl = "https://fr0g.site";
const postviewerurl = "$selfurl/postviewer";
const githuburl = "https://github.com/fr0gsite";
const signupurl = "https://create.fr0g.site";
const whitepaperurl = "https://doc.fr0g.site/whitepaper";
const serverstatus = "https://updown.io/p/03mru";
const telegramurl = "https://t.me/fr0gsite";
const urltoandroidapp = "https://github.com/fr0gsite/android";
const urltoiosapp = "https://github.com/fr0gsite";
const urltowindowsapp = "https://github.com/fr0gsite";

class Documentation {
  static const String url = "https://doc.fr0g.site/";
  static const String rules = "https://doc.fr0g.site/rules";
  static const String whereisthekeystored =
      "https://doc.fr0g.site/faq/#where-is-the-private-key-stored";
  static const String activeownerpermission =
      "https://doc.fr0g.site/faq/#what-is-the-difference-between-active-and-owner-permission";
}

class AppConfig {
  static const String appname = "Fr0g.site";
  static const String maincontract = "cbased";
  static const String systemtokencontract = "eosio.token";
  static const String cbasedtokencontract = "cbased.token";
  static const String systemtoken = "PEP";
  static const int systemtokendecimalafterdot = 4;
  static const chainid =
      "530d11d73d401999b533e0ef5ab1f4f3d2fcd436df7050850671733915fbd721";

  static const String exampleaccount = "user1";
  static const String exampleipfsfile =
      "bafkreibfwqkn5wez42uuah2nenn6ejlqed7h2jenhblh37mfou6necb3ki";

  static List<IPFSNode> ipfsnodes = [
    //IPFSNode("https://ipfs.io/ipfs/", "GET")
    IPFSNode("ipfs.fr0g.site", "https", "ipfs.fr0g.site", 443, "/ipfs/", "GET"),
  ];

  static List<Blockchainnode> blockchainnodeurls = [
    Blockchainnode(
        1, "Genesis Node", "testnet.fr0g.site", "8443", "https", "v1"),
  ];

  static List<IPFSUploadNode> ipfsuploadnodes = [
    IPFSUploadNode(
        "upload.fr0g.site", "upload.fr0g.site", "https", 2053, "tacotoken"),
  ];

  static List<Reportnode> reportnodes = [
    Reportnode(
        "Genesis Report Node", "report.fr0gsite.com", "8443", "https", "/api"),
  ];

  static List<String> logoList = [
    "frog/2.gif",
    "frog/3.gif",
    "frog/4.gif",
    "frog/5.gif",
    "frog/6.gif",
    "frog/7.gif",
    "frog/8.gif",
    "frog/11.gif",
    "frog/20.gif",
    "frog/22.gif",
    "frog/25.gif",
    "frog/27.gif",
    "frog/28.gif",
    "frog/42.gif",
  ];

  static const String secureStoragePKey = "pkey";
  static const String secureStorageusername = "username";
  static const String secureStorageUserConfig = "userconfig";

  static const connectioncheckinterval = 60; //in seconds
  static int refreshuserfavoriteupload = 15; //in minutes
  static int refreshuserfavoritecomment = 15; //in minutes
  static int refreshuserfavoritetags = 15; //in minutes

  // Vales from smart contract
  static int maxUploadText = 1024;
  static int maxReportLength = 1024;
  static int maxCommentLength = 1024;
  static int maxTagLength = 32;
  static int acttokenresetvalue = 10000;

  static const List<RewardToken> rewardtoken = [
    RewardToken("ACT", 5522241, Colors.green),
    RewardToken("FAME", 1162690886, Colors.blue),
    RewardToken("TRUST", 362175353428, Colors.red),
  ];

  static const List<String> imagefiletypes = ["jpg", "jpeg", "png", "gif"];
  static const List<String> videofiletypes = ["mp4"];
  static const List<String> alloweduploadfiletypes = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'mp4'
  ];
  static const List<String> allowedthumbfiletypes = imagefiletypes;

  static List<Platformdetectionstatus> plattformwithvideosupport = [
    Platformdetectionstatus.android,
    Platformdetectionstatus.ios,
    Platformdetectionstatus.web,
  ];

  static List<AppLanguage> applanguage = [
    AppLanguage("international/none", "none"),
    AppLanguage("German", "de"),
    AppLanguage("English", "en"),
    AppLanguage("Français", "fr"),
    AppLanguage("Español", "es"),
    AppLanguage("Português", "pt"),
    AppLanguage("Русский", "ru"),
    AppLanguage("Українська", "uk"),
    AppLanguage("中文", "zh"),
    AppLanguage("日本語", "ja"),
    AppLanguage("اللغة العربية", "ar"),
    AppLanguage("हिन्दी", "hi"),
    AppLanguage("Italiano", "it"),
    AppLanguage("Čeština", "cs"),
  ];
}

class AppLanguage {
  final String languagename;
  final String countrycode;

  AppLanguage(this.languagename, this.countrycode);
}

enum ContentFlag { sfw, erotic, brutal, none }

//Connection Status
enum ConnectionStatus {
  connected,
  connecting,
  disconnected,
  error,
}

extension ConnectionStatusExtension on ConnectionStatus {
  IconData get icon {
    switch (this) {
      case ConnectionStatus.connected:
        return Icons.cloud_done_sharp;
      case ConnectionStatus.connecting:
        return Icons.cloud_download_outlined;
      case ConnectionStatus.disconnected:
        return Icons.cloud_off_sharp;
      case ConnectionStatus.error:
        return Icons.error_outline_sharp;
    }
  }

  Color get color {
    switch (this) {
      case ConnectionStatus.connected:
        return Colors.green;
      case ConnectionStatus.connecting:
        return Colors.yellow;
      case ConnectionStatus.disconnected:
      case ConnectionStatus.error:
        return Colors.red;
    }
  }
}

enum Platformdetectionstatus {
  web,
  android,
  ios,
  windows,
  macos,
  linux,
  unknown
}

class GameConfig {
  List<Game> gamelist = [
    Game(
        name: "Meme Arena",
        description: "",
        imagepath: "assets/images/game_memearena.png",
        link: "",
        active: false),
    Game(
        name: "How Lucky",
        description: "",
        imagepath: "assets/images/game_howlucky.png",
        link: "",
        active: false),
    Game(
        name: "Place",
        description: "",
        imagepath: "assets/images/game_cbplace.png",
        link: "",
        active: false),
    Game(
        name: "sideeffect",
        description: "",
        imagepath: "assets/images/game_sideeffect.png",
        link: "",
        active: false),
    Game(
        name: "World Destroyer",
        description: "",
        imagepath: "assets/images/game_worlddestroyer.png",
        link: "",
        active: false),
    Game(
        name: "Monster Smash",
        description: "",
        imagepath: "assets/images/game_monstersmash.png",
        link: "",
        active: false)
  ];
}

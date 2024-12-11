import 'dart:typed_data';

import 'package:fr0gsite/datatypes/tag.dart';

class Upload {
  final int uploadid;
  final int popularid;
  final String autor;
  final DateTime creationtime;
  final String uploadipfshash;
  final String uploadipfshashfiletyp;
  final String thumbipfshash;
  final String thumbipfshashfiletyp;
  final String uploadtext;
  final String language;
  final int flag;
  int numofcomments;
  int numoftags;
  int numoffavorites;
  int token;
  int up;
  int down;
  //empty data
  Uint8List data = Uint8List(10);
  bool buttonupliked = false;
  bool buttondownliked = false;
  bool buttonfavoriteliked = false;
  // VideoPlayerController videoPlayerController = VideoPlayerController.networkUrl(Uri.parse('uri'));

  //Tag
  List<Tag> taglist = [];
  DateTime lasttagrequest = DateTime.parse("2000-01-01 00:00:00");

  Upload(
      {required this.uploadid,
      required this.autor,
      required this.creationtime,
      required this.uploadipfshash,
      required this.uploadipfshashfiletyp,
      required this.thumbipfshash,
      required this.thumbipfshashfiletyp,
      required this.uploadtext,
      required this.language,
      required this.flag,
      required this.numofcomments,
      required this.numoftags,
      required this.numoffavorites,
      required this.token,
      required this.up,
      required this.down,
      required this.popularid});

  static Upload fromJson(Map<String, dynamic> json) {
    return Upload(
      uploadid: json['uploadid'],
      autor: json['autor'],
      creationtime: DateTime.parse(json['creationtime']),
      uploadipfshash: json['uploadipfshash'],
      uploadipfshashfiletyp: json['uploadipfshash_filetyp'],
      thumbipfshash: json['thumbipfshash'],
      thumbipfshashfiletyp: json['thumbipfshash_filetyp'],
      uploadtext: json['uploadtext'],
      language: json['language'],
      flag: json['flag'],
      numofcomments: json['numofcomments'],
      numoftags: json['numoftags'],
      numoffavorites: json['numoffavorites'],
      token: json['token'],
      up: json['up'],
      down: json['down'],
      popularid: json['popularid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uploadid': uploadid,
      'autor': autor,
      'creationtime': creationtime.toIso8601String(), // Datetime to string
      'uploadipfshash': uploadipfshash,
      'uploadipfshash_filetyp': uploadipfshashfiletyp,
      'thumbipfshash': thumbipfshash,
      'thumbipfshash_filetyp': thumbipfshashfiletyp,
      'uploadtext': uploadtext,
      'language': language,
      'flag': flag,
      'numofcomments': numofcomments,
      'numoftags': numoftags,
      'numoffavorites': numoffavorites,
      'token': token,
      'up': up,
      'down': down,
      'popularid': popularid
    };
  }

  Uint8List getdata() {
    return data;
  }

  void upvote() {
    up = up + 1;
  }

  void downvote() {
    down = down + 1;
  }

  // Future<bool> setVideoControllerData(Uint8List data) async {
  //   try {
  //     videoPlayerController = VideoPlayerController.networkUrl(
  //         Uri.parse('data:video/mp4;base64,${base64Encode(data)}'));
  //
  //     await videoPlayerController.setLooping(true);
  //     await videoPlayerController.initialize();
  //
  //     debugPrint(" 111  Videoplayer initialized");
  //     return true;
  //   } catch (e) {
  //     debugPrint("initializePlayer Error: $e");
  //     return false;
  //   }
  // }

  Uint8List setdata(Uint8List data) {
    //requsteddata = true;
    //lastrequest = DateTime.now();
    this.data = data;
    return data;
  }

  bool havedata() {
    if (data.length == 10) {
      return false;
    }
    return true;
  }

  static Upload demo() {
    return Upload(
      uploadid: 1,
      autor: "autor",
      creationtime: DateTime.now(),
      uploadipfshash: "uploadipfshash",
      uploadipfshashfiletyp: "uploadipfshashfiletyp",
      thumbipfshash: "thumbipfshash",
      thumbipfshashfiletyp: "thumbipfshashfiletyp",
      uploadtext: "uploadtext",
      language: "language",
      flag: 0,
      numofcomments: 0,
      numoftags: 0,
      numoffavorites: 0,
      token: 0,
      up: 0,
      down: 0,
      popularid: 0,
    );
  }
}

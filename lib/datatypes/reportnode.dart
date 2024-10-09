import 'package:flutter/foundation.dart';

class Reportnode {
  Reportnode(this.name, this.url, this.port, this.protocol, this.api) {
    debugPrint("add Reportnode: url: $protocol://$url:$port$api , name: $name");
  }

  String name;
  String url;
  String port;
  String protocol;
  String api;

  String get getfullurl {
    return "$protocol://$url:$port$api";
  }
}

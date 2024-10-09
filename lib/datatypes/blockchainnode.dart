import 'package:fr0gsite/config.dart';
import 'package:flutter/foundation.dart';

class Blockchainnode {
  Blockchainnode(this.prio, this.name, this.url, this.port, this.protocol,
      this.apiversion) {
    debugPrint("add Servernode: url: $protocol://$url:$port , name: $name");
  }

  int prio;
  String name;
  String url;
  String port;
  String protocol;
  String apiversion;

  int sumrequesttime = 0;
  int requestFailedCount = 0;
  int requestSuccessCount = 0;

  ConnectionStatus connectionstatus = ConnectionStatus.disconnected;

  String get getfullurl {
    return "$protocol://$url:$port";
  }

  void newrequest(bool success, int time) {
    if (success) {
      requestSuccessCount++;
      connectionstatus = ConnectionStatus.connected;
    } else {
      requestFailedCount++;
      connectionstatus = ConnectionStatus.error;
    }
    sumrequesttime += time;
  }

  int averagerequesttime() {
    if (requestFailedCount + requestSuccessCount == 0) {
      return 0;
    }
    int result =
        (sumrequesttime / (requestFailedCount + requestSuccessCount)).round();
    return result;
  }
}

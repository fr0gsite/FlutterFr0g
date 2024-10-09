import 'package:fr0gsite/config.dart';

class IPFSNode {
  final String name;
  final String protokoll;
  final String address;
  final String path;
  final int port;
  final String methode;

  int sumrequesttime = 0;
  int requestFailedCount = 0;
  int requestSuccessCount = 0;

  ConnectionStatus connectionstatus = ConnectionStatus.disconnected;

  IPFSNode(this.name, this.protokoll, this.address, this.port, this.path,
      this.methode);

  factory IPFSNode.fromJson(dynamic json) {
    return IPFSNode(json['name'], json['protokoll'], json['address'],
        json['port'], json['path'], json['methode']);
  }

  String get url {
    return "$protokoll://$address:$port";
  }

  String get fullurl {
    return "$protokoll://$address:$port$path";
  }

  newrequest(bool success, int time) {
    sumrequesttime += time;
    if (success) {
      requestSuccessCount++;
      connectionstatus = ConnectionStatus.connected;
    } else {
      requestFailedCount++;
      connectionstatus = ConnectionStatus.error;
    }
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

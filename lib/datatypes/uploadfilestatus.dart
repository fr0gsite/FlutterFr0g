import 'package:flutter/foundation.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/ipfsuploadnode.dart';

// Status for uploading files to community ipfs nodes

class UploadFileStatus extends ChangeNotifier {
  IPFSUploadNode choosenode = AppConfig.ipfsuploadnodes[0]; //Default node
  List<IPFSUploadNode> nodes = AppConfig.ipfsuploadnodes;

  //For authentification with the ipfs node
  String pubkey = ""; //Saved on Blockchain, readable by node
  String privkey = ""; //Send to the node, checked by the node

  void setnode(IPFSUploadNode node) {
    choosenode = node;
    notifyListeners();
  }

  void setkeys(String pubkey, String privkey) {
    this.pubkey = pubkey;
    this.privkey = privkey;
    notifyListeners();
  }
}

enum UploadFileStates {
  searchingnodes,
  checkquota,
  selectproviders,
  choosefiles,
}

class CommunityNodeCheckuserResponse {
  int slots;
  bool freeslots;

  int get userslots => slots;

  CommunityNodeCheckuserResponse(this.slots, this.freeslots);

  factory CommunityNodeCheckuserResponse.fromJson(Map<String, dynamic> json) {
    int slots = json['slots'] is int
        ? json['slots']
        : int.tryParse(json['slots'].toString()) ?? 0;
    bool freeslots = json['freeslots'];

    return CommunityNodeCheckuserResponse(slots, freeslots);
  }

  Map<String, dynamic> toJson() {
    return {
      'slots': slots,
      'freeslots': freeslots,
    };
  }

  static CommunityNodeCheckuserResponse dummy() {
    return CommunityNodeCheckuserResponse(0, false);
  }
}

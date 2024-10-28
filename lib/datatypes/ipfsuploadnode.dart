import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/uploadfilestatus.dart';
import 'package:http/http.dart' as http;

class IPFSUploadNode {
  String name; //Name of the IPFS Node
  String url; //URL of the IPFS Node e.g ipfs.fr0g.site
  String protokoll; //Protokoll of the IPFS Node e.g https
  int port; //Port of the IPFS Node e.g 443
  String accountname; //Accountname / Contractname of the IPFS Provider

  bool online = false; //Connection Status of the IPFS Node
  int userslots = 0;
  bool freeslots = false;
  int slotprice = 0;

  String uploadurl() {
    return "$protokoll://$url:$port/upload";
  }

  String requesturl() {
    return "$protokoll://$url:$port/checkuser";
  }

  IPFSUploadNode(
      this.name, this.url, this.protokoll, this.port, this.accountname);

  Future<IPFSUploadNode> testconnection() async {
    try {
      debugPrint("Testing IPFS Node ${requesturl()}");
      http.Response response = await http.get(Uri.parse(requesturl()));
      if (response.statusCode == 400) {
        online = true;
        debugPrint("IPFS Node $name is online");
        return this;
      }
      online = false;
    } catch (e) {
      online = false;
      debugPrint("IPFS Node $name is offline");
    }
    return this;
  }

  Future<CommunityNodeCheckuserResponse> checkuserslots(String username) async {
    debugPrint("Checking User $username slots on $name");
    http.Response response =
        await http.get(Uri.parse("${requesturl()}?username=$username"));
    if (response.statusCode == 200) {
      try {
        CommunityNodeCheckuserResponse reponse =
            CommunityNodeCheckuserResponse.fromJson(json.decode(response.body));
        userslots = reponse.userslots;
        freeslots = reponse.freeslots;
        debugPrint("User $username has $userslots slots on $name");
        return reponse;
      } catch (e) {
        debugPrint("Error parsing response from $name");
        return CommunityNodeCheckuserResponse.dummy();
      }
    }
    return CommunityNodeCheckuserResponse.dummy();
  }

  Future<int> getslotprice() async {
    if (slotprice != 0) {
      return slotprice;
    } else {
      int price = 0;
      await Chainactions().getslotprice(this).then((value) {
        price = value;
      });
      return price;
    }
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fr0gsite/datatypes/ipfsnode.dart';
import 'package:fr0gsite/datatypes/networkstatus.dart';
import 'package:fr0gsite/datatypes/blackliststatus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IPFSActions {
  static Future<Uint8List> fetchipfsdata(BuildContext context, ipfshashToMediafile) async {
    debugPrint("Request IPFS Media with Hash: $ipfshashToMediafile");
    final networkStatus = context.read<NetworkStatus>();

    // Check blacklist
    final blacklist = context.read<BlacklistStatus>();
    await blacklist.ensure();
    if (!context.mounted) return Uint8List.fromList([]);
    if (blacklist.isBlacklisted(ipfshashToMediafile)) {
      debugPrint("IPFS hash $ipfshashToMediafile is blacklisted");
      return Uint8List.fromList([]);
    }

    //Cache config for Platform
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      if (!context.mounted) return Uint8List.fromList([]);
      final String? imagestorage = prefs.getString(ipfshashToMediafile);
      if (imagestorage != null) {
        debugPrint(
            "(Cached) Received IPFS Media with Hash: $ipfshashToMediafile");
        return base64Decode(imagestorage);
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      if (!context.mounted) return Uint8List.fromList([]);
      final String? imagestorage = prefs.getString(ipfshashToMediafile);
      if (imagestorage != null) {
        debugPrint(
            "(Cached) Received IPFS Media with Hash: $ipfshashToMediafile");
        return base64Decode(imagestorage);
      }
    }

    //Choose IPFS Node
    const int timeoutinseconds = 10;
    IPFSNode choosenIPFSnode = networkStatus.chooseIPFSNode();
    int numoftries = 0;
    while (numoftries < 5) {
      choosenIPFSnode = networkStatus.chooseIPFSNode();
      late http.Response response;
      DateTime start = DateTime.now();
      if (choosenIPFSnode.methode == "GET") {
        try {
          response = await http.get(
              Uri.parse(
                  "${choosenIPFSnode.protokoll}://${choosenIPFSnode.address}:${choosenIPFSnode.port}${choosenIPFSnode.path}$ipfshashToMediafile"),
              headers: <String, String>{})
              .timeout(const Duration(seconds: timeoutinseconds),
                  onTimeout: () {
            debugPrint(
                "Timeout Failed to receive IPFS Media with Hash: $ipfshashToMediafile");
            //Choose next IPFS Node
            networkStatus.requestfromIPFS(
                choosenIPFSnode, false, timeoutinseconds * 1000);
            //return http.Response("Timeout", 408);
            throw Exception("Timeout");
          });
          if (!context.mounted) return Uint8List.fromList([]);
        } catch (e) {
          networkStatus.requestfromIPFS(
              choosenIPFSnode, false, timeoutinseconds * 1000);
          //Choose next IPFS Node and try again
          numoftries++;
          choosenIPFSnode = networkStatus.chooseIPFSNode();
          continue;
        }
      }
      DateTime end = DateTime.now();
      if (response.statusCode == 200) {
        networkStatus.requestfromIPFS(
            choosenIPFSnode, true, end.difference(start).inMilliseconds);
        debugPrint("Received IPFS Media with Hash: $ipfshashToMediafile");
        var byteresponse = response.bodyBytes;
        final prefs = await SharedPreferences.getInstance();
        if (!context.mounted) return Uint8List.fromList([]);
        await prefs
            .setString(ipfshashToMediafile, base64Encode(byteresponse))
            .onError((error, stackTrace) {
          debugPrint(
              "Failed to save IPFS Media with Hash: $ipfshashToMediafile");
          return true;
        });
        return byteresponse;
      } else {
        debugPrint(
            "Failed to receive IPFS Media with Hash: $ipfshashToMediafile");
        networkStatus.requestfromIPFS(
            choosenIPFSnode, false, end.difference(start).inMilliseconds);
        return Uint8List.fromList([]);
      }
    }
    return Uint8List.fromList([]);
  }
}

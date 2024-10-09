import 'dart:async';
import 'package:fr0gsite/config.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:fr0gsite/datatypes/ipfsnode.dart';
import 'package:fr0gsite/datatypes/blockchainnode.dart';
import 'package:eosdart/eosdart.dart';
import 'package:flutter/material.dart';

class NetworkStatus extends ChangeNotifier {
  //Connection Status IPFS
  var automaticipfsnode = true;
  ConnectionStatus connectionstatusIPFS = ConnectionStatus.connecting;
  DateTime lastconnectioncheckIPFS =
      DateTime.parse("2000-01-01 00:00:00.000000");
  List<IPFSNode> ipfsnodes = AppConfig.ipfsnodes;
  late IPFSNode currentipfsnode;

  //Connection Status Chain
  var automaticblockchainnode = true;
  ConnectionStatus connectionStatusChain = ConnectionStatus.connecting;
  DateTime lastconnectioncheckChain =
      DateTime.parse("2000-01-01 00:00:00.000000");
  List<Blockchainnode> blockchainnodes = AppConfig.blockchainnodeurls;
  late Blockchainnode currentblockchainnode;

  NetworkStatus() {
    debugPrint("NetworkStatus: init");
    chooseIPFSNode();
    choooseBlockchainNode();

    testcurrentipfsconnection();
    testcurrentchainconnection();
    Timer.periodic(const Duration(seconds: 5), (timer) {
      //Check Connection
      if (DateTime.now().difference(lastconnectioncheckChain).inSeconds >
          AppConfig.connectioncheckinterval) {}
    });
  }

  IPFSNode getcurrentIPFSNode() {
    return chooseIPFSNode();
  }

  void setConnectionStatusChain(ConnectionStatus status) {
    connectionStatusChain = status;
    notifyListeners();
  }

  void setConnectionStatusIPFS(ConnectionStatus status) {
    connectionstatusIPFS = status;
    notifyListeners();
  }

  void setIPFSNode(IPFSNode nodes) {
    //delete old node
    ipfsnodes.removeWhere((element) => element.name == nodes.name);
    currentipfsnode = nodes;
    ipfsnodes.add(nodes);
    notifyListeners();
  }

  void setBlockchainNode(Blockchainnode nodes) {
    //delete old node
    blockchainnodes.removeWhere((element) => element.name == nodes.name);
    currentblockchainnode = nodes;
    blockchainnodes.add(nodes);
    notifyListeners();
  }

  void setAutomaticIPFSNode(bool value) {
    automaticipfsnode = value;
    notifyListeners();
  }

  void setAutomaticBlockchainNode(bool value) {
    automaticblockchainnode = value;
    notifyListeners();
  }

  Future<int> checkConnectionChain(Blockchainnode chainnode) async {
    debugPrint("Check connection (Chain): ${chainnode.url}");
    try {
      EOSClient client = EOSClient(chainnode.getfullurl, chainnode.apiversion);
      DateTime start = DateTime.now();
      final response = await client.getInfo();
      DateTime stop = DateTime.now();
      int difference = stop.difference(start).inMilliseconds;
      if (response.chainId != AppConfig.chainid) {
        throw "Wrong ChainId";
      }
      if (chainnode.name == currentblockchainnode.name) {
        setConnectionStatusChain(ConnectionStatus.connected);
      }
      blockchainnodes
          .firstWhere((element) => element.name == chainnode.name)
          .newrequest(true, difference);
      return difference;
    } catch (e) {
      debugPrint("Check connection (Chain) Error, ${chainnode.url} Error: $e");
      blockchainnodes
          .firstWhere((element) => element.name == chainnode.name)
          .newrequest(false, 0);
      return -1;
    }
  }

  Future<int> checkConnectionIPFS(IPFSNode node) async {
    debugPrint("Check connection (IPFS): ${node.address}");
    try {
      late http.Response response;
      DateTime start = DateTime.now();
      response = await http.get(
          Uri.parse(
              "${node.protokoll}://${node.address}:${node.port}${node.path}${AppConfig.exampleipfsfile}"),
          headers: <String, String>{});
      DateTime end = DateTime.now();
      int difference = end.difference(start).inMilliseconds;
      if (response.statusCode == 200) {
        ipfsnodes
            .firstWhere((element) => element.name == node.name)
            .newrequest(true, difference);
        return difference;
      } else {
        ipfsnodes
            .firstWhere((element) => element.name == node.name)
            .newrequest(false, difference);
        throw "Error: ${response.statusCode}";
      }
    } catch (e) {
      debugPrint("Check connection (IPFS) Error, ${node.address} Error: $e");
      return -1;
    }
  }

  Future<bool> testallIPFSNodes() async {
    for (IPFSNode node in ipfsnodes) {
      checkConnectionIPFS(node);
    }
    return true;
  }

  Future<bool> testallChainNodes() async {
    for (Blockchainnode node in blockchainnodes) {
      checkConnectionChain(node);
    }
    return true;
  }

  void testcurrentipfsconnection() {
    checkConnectionIPFS(currentipfsnode).then((value) {
      if (value > 0) {
        setConnectionStatusIPFS(ConnectionStatus.connected);
      } else {
        setConnectionStatusIPFS(ConnectionStatus.disconnected);
      }
    });
  }

  void testcurrentchainconnection() {
    checkConnectionChain(currentblockchainnode).then((value) {
      if (value > 0) {
        setConnectionStatusChain(ConnectionStatus.connected);
      } else {
        setConnectionStatusChain(ConnectionStatus.disconnected);
      }
    });
  }

  IPFSNode chooseIPFSNode() {
    if (automaticipfsnode) {
      currentipfsnode = getbestIPFSNode();
      return currentipfsnode;
    }
    return currentipfsnode;
  }

  choooseBlockchainNode() {
    if (automaticblockchainnode) {
      currentblockchainnode = getbestblockchainnode();
    }
    currentblockchainnode = blockchainnodes[0];
  }

  IPFSNode getbestIPFSNode() {
    return ipfsnodes.reduce((curr, element) =>
        curr.averagerequesttime() < element.averagerequesttime()
            ? curr
            : element);
  }

  Blockchainnode getbestblockchainnode() {
    return blockchainnodes.reduce((curr, element) =>
        curr.averagerequesttime() < element.averagerequesttime()
            ? curr
            : element);
  }

  void requestfromIPFS(IPFSNode node, bool success, int time) {
    ipfsnodes
        .where((element) => element.name == node.name)
        .first
        .newrequest(success, time);
  }

  void requestfromBlockchain(Blockchainnode node, bool success, DateTime time) {
    //blockchainnodes
    //    .where((element) => element.name == node.name)
    //    .first
    //    .newrequest(success, time);
  }
}

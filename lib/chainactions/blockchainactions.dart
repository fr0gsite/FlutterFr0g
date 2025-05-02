import 'package:fr0gsite/config.dart';
import 'package:eosdart/eosdart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../datatypes/blockchainnode.dart';

class BlockchainActions {
  String username = "";
  String permission = "";

  void setusernameandpermission(String username, String permission) {
    this.username = username;
    this.permission = permission;
  }

  Future<bool> transactionHandler(List<Action> actions) async {
    debugPrint("Transaction Handler is called");
    const secstorage = FlutterSecureStorage();
    String pkey = await secstorage.read(key: "pkey") ?? "NoKey";
    if (pkey == "NoKey") {
      throw "No private key found";
    }

    Blockchainnode node = chooseNode();
    EOSClient client =
        EOSClient(node.getfullurl, node.apiversion, privateKeys: [pkey]);

    Transaction transaction = Transaction();
    transaction.actions = actions;

    //Send transaction
    try {
      var temp = await client.pushTransaction(transaction,
          broadcast: true, sign: true);
      debugPrint("Transaction: $temp");
      return true;
    } catch (error) {
      debugPrint("Transaction Error: $error");
      return false;
    }
  }

  Blockchainnode chooseNode() {
    //Choose Node
    //Choose node based on ping
    //Choose node based on user location
    //Check if node is online
    return AppConfig.blockchainnodeurls
        .reduce((curr, next) => curr.prio < next.prio ? curr : next);
  }

  EOSClient geteosclient() {
    Blockchainnode node = chooseNode();
    return EOSClient(node.getfullurl, node.apiversion);
  }

  List<Authorization> getauth() {
    return [
      Authorization()
        ..actor = username
        ..permission = permission
    ];
  }

  Future<bool> stake(String from, String to, double cpu, double net) async {
    await actionsbeforetransaction();
    String stringCPU = cpu == 0 ? "0.0000" : cpu.toStringAsFixed(AppConfig.systemtokendecimalafterdot);
    String stringNET = net == 0 ? "0.0000" : net.toStringAsFixed(AppConfig.systemtokendecimalafterdot);
    debugPrint("Staking $stringCPU CPU and $stringNET NET");
    List<Action> actions =
        stakeressources(from, to, stringCPU, stringNET, getauth());
    return transactionHandler(actions);
  }

  Future<bool> unstake(String from, String to, double cpu, double net) {
    actionsbeforetransaction();
    String stringCPU = cpu == 0 ? "0.0000" : cpu.toStringAsFixed(AppConfig.systemtokendecimalafterdot);
    String stringNET = net == 0 ? "0.0000" : net.toStringAsFixed(AppConfig.systemtokendecimalafterdot);
    debugPrint("Unstaking $stringCPU CPU and $stringNET NET");
    List<Action> actions =
        unstakeressources(from, to, stringCPU, stringNET, getauth());
    return transactionHandler(actions);
  }

  Future<bool> voteproducer (List<String> producernamelist){
    actionsbeforetransaction();
    List<Action> actions = [
      Action()
        ..account = AppConfig.blockchainsystemcontract
        ..name = "voteproducer"
        ..authorization = getauth()
        ..data = {
          "voter": username,
          "proxy": "",
          "producers": producernamelist,
        }
    ];
    return transactionHandler(actions);
  }

  Future<List<ProducerInfo>> getproducerlist() async {
    debugPrint("Requesting producer info");
    List<ProducerInfo> producerinfo = [];
    var response = await geteosclient()
        .getTableRows(AppConfig.blockchainsystemcontract,AppConfig.blockchainsystemcontract, 'producers', limit: 300, json: true);
    try {
      for (var index = 0; index < response.length; index++) {
        producerinfo.add(ProducerInfo.fromJson(response[index]));
      }
    } catch (e) {
      debugPrint("Error while fetching producer info: $e");
      producerinfo = [];
    }
    return producerinfo;
  }

  Future<bool> getslot(context, String contractname, String pubkey) async {
    setUsernameAndPermissionWithContext(context);
    actionsbeforetransaction();
    List<Action> actions = [
      Action()
        ..account = contractname
        ..name = "getslot"
        ..authorization = getauth()
        ..data = {
          "accountname": username,
          "pubkey": pubkey,
        }
    ];
    return transactionHandler(actions);
  }

  Future<bool> setsec(String contractname, String pubkey) async {
    actionsbeforetransaction();
    List<Action> actions = [
      Action()
        ..account = contractname
        ..name = "setsec"
        ..authorization = getauth()
        ..data = {
          "accountname": username,
          "pubkey": pubkey,
        }
    ];
    return transactionHandler(actions);
  }

  Future<int> getslotprice(IPFSUploadNode node) async {
    //Request Table
    var response = await geteosclient().getTableRows(
        node.accountname, node.accountname, 'configs',
        json: true);
    // find value with id 10
    int priceforslot = 0;
    for (var element in response) {
      if (element['id'].toString() == "10") {
        priceforslot = int.parse(element['intvalue'].toString());
      }
    }
    return priceforslot;
  }
}

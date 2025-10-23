import 'dart:convert';

import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/blockchainnode.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:eosdart/eosdart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

/// Base class for all blockchain services providing common functionality
abstract class ChainActionsBase {
  String username = "";
  String permission = "";
  int fetchlimituploads = 400;
  int fetchlimittags = 60;

  /// Validates table rows response and provides defensive error handling
  List<dynamic> validateTableRowsResponse(dynamic response, String context) {
    if (response == null) {
      debugPrint("$context: Response is null");
      return <dynamic>[];
    }
    
    if (response is! List) {
      debugPrint("$context: Response is not a list: ${response.runtimeType}");
      debugPrint("$context: Response content: $response");
      return <dynamic>[];
    }
    
    return response;
  }

  /// Set username and permission for blockchain transactions
  void setusernameandpermission(String username, String permission) {
    this.username = username;
    this.permission = permission;
  }

  /// Set username and permission from global context
  void setUsernameAndPermissionWithContext(context) {
    username = Provider.of<GlobalStatus>(context, listen: false).username;
    permission = Provider.of<GlobalStatus>(context, listen: false).permission;
  }

  /// Main transaction handler for EOS blockchain operations
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

  /// Choose appropriate blockchain node
  Blockchainnode chooseNode() {
    return AppConfig.blockchainnodeurls
        .reduce((curr, next) => curr.prio < next.prio ? curr : next);
  }

  /// Check if private key exists for authentication
  Future<bool> checkPrivateKeyExists() async {
    const secstorage = FlutterSecureStorage();
    String pkey = await secstorage.read(key: "pkey") ?? "NoKey";
    return pkey != "NoKey";
  }

  /// Prepare actions before transaction execution
  Future<bool> actionsbeforetransaction() async {
    return true;
  }

  /// Generic table query method for blockchain data
  Future<List<dynamic>> queryTable({
    required String contract,
    required String scope,
    required String table,
    String? lowerBound,
    String? upperBound,
    int? limit,
    bool reverse = false,
    String? indexPosition,
    String? keyType,
  }) async {
    try {
      Blockchainnode node = chooseNode();
      String url = "${node.getfullurl}/v1/chain/get_table_rows";
      
      Map<String, dynamic> requestBody = {
        "json": true,
        "code": contract,
        "scope": scope,
        "table": table,
        "reverse": reverse,
      };

      if (lowerBound != null) requestBody["lower_bound"] = lowerBound;
      if (upperBound != null) requestBody["upper_bound"] = upperBound;
      if (limit != null) requestBody["limit"] = limit;
      if (indexPosition != null) requestBody["index_position"] = indexPosition;
      if (keyType != null) requestBody["key_type"] = keyType;

      http.Response response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        return validateTableRowsResponse(responseData["rows"], 
            "queryTable: $contract.$table");
      } else {
        debugPrint("Table query failed: ${response.statusCode} ${response.body}");
        return <dynamic>[];
      }
    } catch (error) {
      debugPrint("Table query error: $error");
      return <dynamic>[];
    }
  }

  /// Stake tokens for CPU and NET resources
  Future<bool> stake(String from, String to, double cpu, double net) async {
    await actionsbeforetransaction();
    String stringCPU = cpu == 0 ? "0.0000" : cpu.toStringAsFixed(AppConfig.systemtokendecimalafterdot);
    String stringNET = net == 0 ? "0.0000" : net.toStringAsFixed(AppConfig.systemtokendecimalafterdot);
    debugPrint("Staking $stringCPU CPU and $stringNET NET");
    // Note: These action helper functions need to be imported from actionlist.dart
    // List<Action> actions = stakeressources(from, to, stringCPU, stringNET, getauth());
    // return transactionHandler(actions);
    return false; // Placeholder - implement in concrete service
  }

  /// Unstake tokens from CPU and NET resources
  Future<bool> unstake(String from, String to, double cpu, double net) async {
    await actionsbeforetransaction();
    String stringCPU = cpu == 0 ? "0.0000" : cpu.toStringAsFixed(AppConfig.systemtokendecimalafterdot);
    String stringNET = net == 0 ? "0.0000" : net.toStringAsFixed(AppConfig.systemtokendecimalafterdot);
    debugPrint("Unstaking $stringCPU CPU and $stringNET NET");
    // Note: These action helper functions need to be imported from actionlist.dart
    // List<Action> actions = unstakeressources(from, to, stringCPU, stringNET, getauth());
    // return transactionHandler(actions);
    return false; // Placeholder - implement in concrete service
  }
}
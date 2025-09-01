import 'package:eosdart/eosdart.dart';
import 'package:flutter/material.dart';
import 'package:fr0gsite/config.dart';

class WalletStatus extends ChangeNotifier {
  String sendtoaccountname = "";
  late Account sendtoaccount;
  String amount = "";
  int balance = 0;
  String memo = ""; // Max 256 characters
  String tokenselected = AppConfig.systemtoken;
  String tokencontract = AppConfig.blockchainsystemtokencontract;
  int tokendecimalafterdot = AppConfig.systemtokendecimalafterdot;
}

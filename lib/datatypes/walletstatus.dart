import 'package:eosdart/eosdart.dart';
import 'package:flutter/material.dart';

class WalletStatus extends ChangeNotifier {
  String sendtoaccountname = "";
  late Account sendtoaccount;
  String amount = "";
  int balance = 0;
}

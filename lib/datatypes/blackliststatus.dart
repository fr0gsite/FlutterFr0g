import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'blacklistentry.dart';

class BlacklistStatus extends ChangeNotifier {
  List<BlacklistEntry> blacklist = [];
  DateTime lastFetch = DateTime.fromMillisecondsSinceEpoch(0);

  Future<void> refresh() async {
    var entries = await Chainactions().getblacklist();
    blacklist = entries;
    lastFetch = DateTime.now();
    notifyListeners();
  }

  Future<void> ensure() async {
    if (DateTime.now().difference(lastFetch).inMinutes >
        AppConfig.refreshblacklist) {
      await refresh();
    }
  }

  bool isBlacklisted(String ipfsHash) {
    return blacklist.any((e) => e.ipfshash == ipfsHash);
  }
}

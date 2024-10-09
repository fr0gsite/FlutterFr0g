import 'dart:convert';

import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/localuserconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

loginwhencredentialsarestored(context) async {
  if (Provider.of<GlobalStatus>(context, listen: false).isLoggedin) {
    debugPrint("Already logged in");
  } else {
    const secstorage = FlutterSecureStorage();
    secstorage.read(key: AppConfig.secureStorageusername).then((foundusername) {
      if (foundusername != null) {
        debugPrint("Found username $foundusername in secure storage");
        // Now check for password
        secstorage.read(key: AppConfig.secureStoragePKey).then((foundpkey) {
          if (foundpkey != null) {
            debugPrint("Found pkey in secure storage. Logging in");
            Provider.of<GlobalStatus>(context, listen: false)
                .login(foundusername, "active");
            //Provider.of<GlobalStatus>(context, listen: false).istruster = true;
          } else {
            debugPrint("No pkey found in secure storage");
          }
        });
      } else {
        debugPrint("No username found in secure storage");
      }
    });
  }
}

Future<bool> savelocaluserconfig(LocalUserConfig userconfig) async {
  const secstorage = FlutterSecureStorage();
  await secstorage.write(
      key: AppConfig.secureStorageUserConfig,
      value: jsonEncode(userconfig.toJson()));
  return true;
}

Future<bool> readlocaluserconfig(context) async {
  const secstorage = FlutterSecureStorage();
  await secstorage
      .read(key: AppConfig.secureStorageUserConfig)
      .then((founduserconfig) {
    if (founduserconfig != null) {
      debugPrint("Found userconfig in secure storage");
      Provider.of<GlobalStatus>(context, listen: false).setlocaluserconfig(
          LocalUserConfig.fromJson(jsonDecode(founduserconfig)));
      return true;
    } else {
      debugPrint("No userconfig found in secure storage");
      return false;
    }
  });
  return false;
}

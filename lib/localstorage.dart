import 'dart:convert';

import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/localuserconfig.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

Future<void> loginwhencredentialsarestored(context) async {
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

/// Automatically log in when running in debug mode.
///
/// If [AppConfig.debugUsername] and [AppConfig.debugPKey] are set,
/// the app will log in with these credentials when [kDebugMode] is true
/// and no user is currently logged in.
Future<void> debugAutoLogin(context) async {
  if (kDebugMode &&
      !Provider.of<GlobalStatus>(context, listen: false).isLoggedin) {
    if (AppConfig.debugUsername.isNotEmpty &&
        AppConfig.debugPKey.isNotEmpty) {
      debugPrint('Debug auto login for ${AppConfig.debugUsername}');
      const secstorage = FlutterSecureStorage();
      await secstorage.write(
          key: AppConfig.secureStorageusername,
          value: AppConfig.debugUsername);
      await secstorage.write(
          key: AppConfig.secureStoragePKey,
          value: AppConfig.debugPKey);
      Provider.of<GlobalStatus>(context, listen: false)
          .login(AppConfig.debugUsername, AppConfig.debugPermission);
    }
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

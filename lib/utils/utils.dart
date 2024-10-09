import 'dart:io';

import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

Platformdetectionstatus getPlatform(context) {
  if (Provider.of<GlobalStatus>(context, listen: false).platform ==
      Platformdetectionstatus.unknown) {
    Platformdetectionstatus platform;
    if (kIsWeb) {
      debugPrint('Platform Detection: web');
      platform = Platformdetectionstatus.web;
    } else if (Platform.isAndroid) {
      debugPrint('Platform Detection: Android');
      platform = Platformdetectionstatus.android;
    } else if (Platform.isIOS) {
      debugPrint('Platform Detection: iOS');
      platform = Platformdetectionstatus.ios;
    } else if (Platform.isWindows) {
      debugPrint('Platform Detection: Windows');
      platform = Platformdetectionstatus.windows;
    } else if (Platform.isMacOS) {
      debugPrint('Platform Detection: macOS');
      platform = Platformdetectionstatus.macos;
    } else if (Platform.isLinux) {
      debugPrint('Platform Detection: Linux');
      platform = Platformdetectionstatus.linux;
    } else {
      debugPrint('Platform Detection: unknown');
      platform = Platformdetectionstatus.unknown;
    }
    Provider.of<GlobalStatus>(context, listen: false).setPlatform(platform);
    return platform;
  } else {
    return Provider.of<GlobalStatus>(context, listen: false).platform;
  }
}

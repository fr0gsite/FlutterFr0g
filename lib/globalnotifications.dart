import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class Globalnotifications {
  static void shownotification(
      BuildContext context, String title, String message, String type) {
    IconData icon; // https://api.flutter.dev/flutter/material/Icons-class.html
    Color iconcolor = Colors.white;
    Color backgroundcolor = Colors.black;
    switch (type) {
      case "info":
        icon = Icons.info;
        break;
      case "warning":
        icon = Icons.warning;
        backgroundcolor = Colors.yellow;
        break;
      case "error":
        icon = Icons.error;
        backgroundcolor = Colors.red;
        break;
      case "success":
        icon = Icons.check_circle;
        backgroundcolor = Colors.green;
        break;
      case "alarm":
        icon = Icons.local_fire_department;
        backgroundcolor = Colors.red;
        break;
      default:
        icon = Icons.notifications_active;
        break;
    }

    ElegantNotification(
      title: Text(title),
      description: Text(message),
      //notificationPosition: NotificationPosition.topLeft,
      animation: AnimationType.fromTop,
      onDismiss: () {},
      background: backgroundcolor,
      icon: Icon(
        icon,
        color: iconcolor,
      ),
    ).show(context);
  }

  void copytoClipboard(BuildContext context) {
    shownotification(context, AppLocalizations.of(context)!.info,
        AppLocalizations.of(context)!.copiedtoclipboard, "info");
  }
}

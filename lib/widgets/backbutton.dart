import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:fr0gsite/config.dart';
import 'package:universal_html/html.dart' as html;

Widget backButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.nicegrey,
          borderRadius: BorderRadius.circular(50),
        ),
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.backspace_rounded,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () {
            final bool canPop = Navigator.canPop(context);
            final bool hasHistory = !kIsWeb || html.window.history.length > 1;
            if (canPop && hasHistory) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
        ),
      ),
    );
  }

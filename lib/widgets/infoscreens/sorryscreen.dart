import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:fr0gsite/l10n/app_localizations.dart';

class Sorryscreen extends StatelessWidget {
  const Sorryscreen({super.key, required this.additionalinfo});
  final String additionalinfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            AutoSizeText(
                additionalinfo == ""
                    ? AppLocalizations.of(context)!.sorrysomethingwentwrong
                    : additionalinfo,
                style: const TextStyle(color: Colors.white, fontSize: 20)),
            Lottie.asset(
              'assets/lottie/sorry.json',
              repeat: true,
              animate: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(color: Colors.white)))),
              onPressed: () {
                //Navigator.of(context).pop(); // Navigieren Sie zur vorherigen Seite oder zum Startbildschirm
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: AutoSizeText(
                AppLocalizations.of(context)!.goback,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

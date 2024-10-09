import 'package:flutter/material.dart';

class TemporaryMessage extends StatelessWidget {
  const TemporaryMessage(String s, {super.key});

  @override
  Widget build(BuildContext context) {
    void showTemporaryMessage(BuildContext context, String message) {
      final snackBar = SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        margin: const EdgeInsets.all(50),
      );

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(snackBar);
    }

    return Center(
      child: ElevatedButton(
        onPressed: () {
          showTemporaryMessage(context, 'Ihre Meldung');
        },
        child: const Text('Zeige Meldung'),
      ),
    );
  }
}

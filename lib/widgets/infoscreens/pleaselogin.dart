import 'package:fr0gsite/widgets/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Pleaselogin extends StatelessWidget {
  const Pleaselogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text(
              AppLocalizations.of(context)!.forthisfeatureyouhavetologin,
              style: const TextStyle(fontSize: 30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: ((context) {
                    return const Login();
                  }),
                );
              },
              child: Text(
                AppLocalizations.of(context)!.login,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

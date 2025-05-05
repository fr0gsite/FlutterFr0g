import 'package:auto_size_text/auto_size_text.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/userconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ApplyTrusterroleView extends StatefulWidget {
  const ApplyTrusterroleView({super.key, required this.userconfig});
  final UserConfig userconfig;
  @override
  _ApplyTrusterroleViewState createState() => _ApplyTrusterroleViewState();
}

class _ApplyTrusterroleViewState extends State<ApplyTrusterroleView> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background GIF
        Positioned.fill(
          child: Image.asset(
            'assets/frog/7.gif', // Replace with your GIF file path
            fit: BoxFit.cover,
          ),
        ),
        // Foreground content
        Container(
          color: Colors.black.withOpacity(0.6), // Optional overlay for better text visibility
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AutoSizeText(
                  AppLocalizations.of(context)!.applyasatruster,
                  minFontSize: 20,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: AutoSizeText(
                  AppLocalizations.of(context)!.trusterexplain,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              OverflowBar(
                alignment: MainAxisAlignment.center,
                spacing: 8.0,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: AutoSizeText(
                        AppLocalizations.of(context)!.apply,
                        minFontSize: 20,
                        style: const TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (Provider.of<GlobalStatus>(context, listen: false).isLoggedin) {
                          String username = Provider.of<GlobalStatus>(context, listen: false).username;
                          String permission = Provider.of<GlobalStatus>(context, listen: false).permission;
                          Chainactions chainactions = Chainactions();
                          chainactions.setusernameandpermission(username, permission);
                          await chainactions.applyfortrusterrole(username).then(
                            (value) {
                              debugPrint("Apply for Truster Role: $value");
                            },
                          ).catchError((error) {
                            debugPrint("Error applying for Truster Role: $error");
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Applied for Truster Role")),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

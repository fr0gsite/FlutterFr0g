import 'package:flutter/foundation.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/globalnotifications.dart';
import 'package:fr0gsite/widgets/login/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginButton extends StatefulWidget {
  const LoginButton({super.key});

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalStatus>(builder: (context, userstatus, child) {
      if (userstatus.isLoggedin) {
        return Row(
          children: [
            TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      WidgetStateProperty.all<Color>(AppColor.nicewhite),
                ),
                onPressed: () {
                    Navigator.pushNamed(context, "/profile/${userstatus.username}");
                },
                child: Text(userstatus.username)),
            //ResourceViewerTopBar(cpu: true, ram: false, net: true, act: true),
            IconButton(
                onPressed: (() {
                  showDialog(
                    context: context,
                    builder: ((context) {
                      return AlertDialog(
                        backgroundColor: AppColor.niceblack,
                        title: Center(
                            child: Text(AppLocalizations.of(context)!.logout)),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Provider.of<GlobalStatus>(context,
                                        listen: false)
                                    .logout();
                                Globalnotifications.shownotification(
                                    context,
                                    AppLocalizations.of(context)!
                                        .logoutsuccessfull,
                                    AppLocalizations.of(context)!.bye,
                                    "Info");
                                Navigator.pop(context);
                              },
                              child: Text(AppLocalizations.of(context)!.yes,
                                  style: const TextStyle(color: Colors.white))),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(AppLocalizations.of(context)!.no,
                                  style: const TextStyle(color: Colors.white)))
                        ],
                      );
                    }),
                  );
                }),
                icon: const Icon(Icons.logout, color: Colors.white))
          ],
        );
      } else {
        return IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: ((context) {
                return const Login();
              }),
            );
          },
          icon: const Icon(Icons.person_sharp, color: Colors.white),
          tooltip: "Login",
          key: const Key("LoginButton"),
        );
      }
    });
  }
}

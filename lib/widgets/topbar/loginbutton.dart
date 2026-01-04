import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/widgets/login/login.dart';
import 'package:flutter/material.dart';
import 'package:fr0gsite/widgets/login/logoutview.dart';
import 'package:provider/provider.dart';

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
                    Navigator.pushNamed(context, "/${AppConfig.profileurlpath}/${userstatus.username}");
                },
                child: Text(userstatus.username)),
            //ResourceViewerTopBar(cpu: true, ram: false, net: true, act: true),
            IconButton(
                onPressed: (() {
                  showDialog(
                    context: context,
                    builder: ((context) {
                      return const LogoutView();
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

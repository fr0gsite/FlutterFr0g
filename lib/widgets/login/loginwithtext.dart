import 'package:flutter/material.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config.dart';
import '../../globalnotifications.dart';
import '../tools.dart';

class Loginwithtext extends StatefulWidget {
  const Loginwithtext({super.key, required this.feedback});
  final void Function(String key) feedback;

  @override
  State<Loginwithtext> createState() => _LoginwithtextState();
}

class _LoginwithtextState extends State<Loginwithtext> {
  var usernameController = TextEditingController();
  var privatekeyController = TextEditingController();

  var defaultfillcolor = Colors.blueGrey;
  var fillcolorusername = Colors.blueGrey;
  var fillcolorprivatekey = Colors.blueGrey;
  
  bool extendedview = false;

  String permission = "active";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
              controller: usernameController,
              onTap: () {
                widget.feedback("username");
              },
              style: const TextStyle(color: Colors.white),
              autofillHints: const [AutofillHints.username],
              decoration: InputDecoration(
                  icon: const Icon(Icons.person, color: Colors.white),
                  labelText: AppLocalizations.of(context)!.username,
                  labelStyle: const TextStyle(color: Colors.white),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 3)),
                  fillColor: fillcolorusername,
                  filled: true)),
        ),
        const SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
              obscureText: true,
              onTap: () {
                widget.feedback("privatekey");
              },
              controller: privatekeyController,
              style: const TextStyle(color: Colors.white),
              autofillHints: const [AutofillHints.password],
              decoration: InputDecoration(
                  icon: const Icon(Icons.vpn_key, color: Colors.white),
                  labelText: AppLocalizations.of(context)!.privatekey,
                  labelStyle: const TextStyle(color: Colors.white),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 3)),
                  fillColor: fillcolorprivatekey,
                  filled: true)),
        ),
        TextButton(
          onPressed: () {
            launchUrl(Uri.parse(Documentation.whereisthekeystored));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.info_outline, color: Colors.white),
              const SizedBox(width: 10),
              Text(AppLocalizations.of(context)!.whereisthekeystored,
                  style: const TextStyle(color: Colors.white))
            ],
          ),
        ),
        const SizedBox(height: 25),

        TextButton(
          onPressed: () {
            setState(() {
              extendedview = !extendedview;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.settings, color: Colors.white),
              const SizedBox(width: 10),
              Text(AppLocalizations.of(context)!.config,
                  style: const TextStyle(color: Colors.white))
            ],
          ),
        ),
        !extendedview ? Container() : 

        Column(
          children: [
            Text(
              AppLocalizations.of(context)!.permission,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            Tooltip(
              message: AppLocalizations.of(context)!.permissionexplain,
              child: ToggleSwitch(
                minWidth: 110.0,
                initialLabelIndex: 0,
                cornerRadius: 20.0,
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.white,
                totalSwitches: 2,
                labels: const ['Active', 'Owner'],
                activeBgColors: const [
                  [Colors.blue],
                  [Colors.red]
                ],
                onToggle: (index) {
                  if (index == 0) {
                    permission = "active";
                  } else {
                    permission = "owner";
                  }
                },
              ),
            ),
            TextButton(
              onPressed: () {
                launchUrl(Uri.parse(Documentation.activeownerpermission));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.info_outline, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(AppLocalizations.of(context)!.whatdoesthatmean,
                      style: const TextStyle(color: Colors.white))
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 50),
        MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
          color: Colors.green,
          onPressed: login,
          height: 50,
          child: Ink(
            width: 200,
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.login,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
          color: Colors.blue,
          onPressed: () {
            launchUrl(Uri.parse(signupurl));
          },
          height: 50,
          child: Ink(
            width: 200,
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.signup,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  void login() async {
    {
      var privatekeyvalid =
          SomeHelper().isPrivateKeyValide(privatekeyController.text);
      if (!privatekeyvalid && privatekeyController.text != "") {
        setState(() {
          fillcolorprivatekey = Colors.red;
        });
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: AppColor.niceblack,
            title: Center(
                child: Text(AppLocalizations.of(context)!.wrongprivatekey)),
            content:
                Text(AppLocalizations.of(context)!.privatekeyinvalidformat),
          ),
        );
        widget.feedback("wrongprivatekey");
      }
      if (privatekeyvalid) {
        setState(() {
          fillcolorprivatekey = defaultfillcolor;
        });
      }

      var usernamevalid = SomeHelper().isUsernameValid(usernameController.text);
      if (!usernamevalid && usernameController.text != "") {
        setState(() {
          fillcolorusername = Colors.red;
        });
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  backgroundColor: AppColor.niceblack,
                  title: Center(
                      child: Text(AppLocalizations.of(context)!.wrongusername)),
                  content:
                      Text(AppLocalizations.of(context)!.usernameinvalidformat),
                ));
      }
      if (usernamevalid) {
        setState(() {
          fillcolorusername = defaultfillcolor;
        });
      }

      if (usernamevalid && privatekeyvalid) {
        try {
          var isprivatekeyvalid = await Chainactions().checkusercredentials(
              usernameController.text, privatekeyController.text, permission);
          if (isprivatekeyvalid) {
            const secstorage = FlutterSecureStorage();
            await secstorage.write(
                key: "pkey", value: privatekeyController.text);
            await secstorage.write(
                key: "username", value: usernameController.text);
            if (mounted) {
              Provider.of<GlobalStatus>(context, listen: false)
                  .login(usernameController.text, permission);
              TextInput.finishAutofillContext();
              Globalnotifications.shownotification(
                  context,
                  AppLocalizations.of(context)!.loginsuccessfull,
                  "${AppLocalizations.of(context)!.welcomeback} ${usernameController.text}",
                  "Info");
              Navigator.pop(context);
            }
          }
        } catch (error) {
          if (mounted) {
            widget.feedback("wrongprivatekey");
            Globalnotifications.shownotification(
              context,
              AppLocalizations.of(context)!.error,
              "${AppLocalizations.of(context)!.wrongprivatekey} / ${AppLocalizations.of(context)!.wrongusername}",
              "error");
            debugPrint("Login Error: $error");
          }
        }
      }
    }
  }
}

import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/globalnotifications.dart';
import 'package:fr0gsite/widgets/login/login.dart';
import 'package:fr0gsite/widgets/settings/setlanguageview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalStatus>(builder: (context, userstatus, child) {
      return SettingsList(
        platform: DevicePlatform.web,
        lightTheme: SettingsThemeData(
            settingsListBackground: AppColor.nicegrey,
            titleTextColor: Colors.white,
            settingsSectionBackground: Colors.white.withAlpha((0.8 * 255).toInt())),
        darkTheme:
            const SettingsThemeData(settingsListBackground: AppColor.nicegrey),
        sections: [
          SettingsSection(
            title: Text(AppLocalizations.of(context)!.settingcommon),
            tiles: [
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.profile),
                description: Text(
                    AppLocalizations.of(context)!.settingprofiledescription),
                leading: const Icon(Icons.person),
                onPressed: (BuildContext context) {
                  if (userstatus.isLoggedin) {
                    Navigator.pushNamed(
                        context, '/profile/${userstatus.username}');
                  } else {
                    showDialog(
                      context: context,
                      builder: ((context) {
                        return const Login();
                      }),
                    );
                  }
                },
              ),
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.ressources),
                description: Text(
                    AppLocalizations.of(context)!.settingressourcesdescription),
                leading: const Icon(Icons.speed),
                onPressed: (BuildContext context) {
                  Navigator.pushNamed(context, '/resource');
                },
              ),
              SettingsTile(
                title: Text(
                    AppLocalizations.of(context)!.settingprivacyandsecurity),
                description: Text(AppLocalizations.of(context)!
                    .settingprivacyandsecuritydescription),
                leading: const Icon(Icons.security),
                onPressed: (BuildContext context) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Center(
                        child: Text(
                          AppLocalizations.of(context)!
                              .thisfeatureisnotavailableyet,
                          style: const TextStyle(fontSize: 30),
                        ),
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.friendrequests),
                leading: const Icon(Icons.supervised_user_circle),
                onPressed: (BuildContext context) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Center(
                          child: Text(
                        AppLocalizations.of(context)!
                            .thisfeatureisnotavailableyet,
                        style: const TextStyle(fontSize: 30),
                      )),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.rulesandguidelines),
                description: Text(AppLocalizations.of(context)!.openwebsite),
                leading: const Icon(Icons.rule),
                onPressed: (BuildContext context) {
                  launchUrl(Uri.parse(Documentation.rules));
                },
              ),
              SettingsTile(
                title: userstatus.isLoggedin
                    ? Text(AppLocalizations.of(context)!.logout)
                    : Text(AppLocalizations.of(context)!.login),
                leading: const Icon(Icons.logout),
                onPressed: (BuildContext context) {
                  if (userstatus.isLoggedin) {
                    showDialog(
                      context: context,
                      builder: ((context) {
                        return AlertDialog(
                          backgroundColor: AppColor.niceblack,
                          title: Center(
                              child: Text(
                                  "${AppLocalizations.of(context)!.logout} ?")),
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
                                    style:
                                        const TextStyle(color: Colors.white))),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(AppLocalizations.of(context)!.no,
                                    style:
                                        const TextStyle(color: Colors.white)))
                          ],
                        );
                      }),
                    );
                  } else {
                    showDialog(
                        context: context,
                        builder: ((context) {
                          return const Login();
                        }));
                  }
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text(AppLocalizations.of(context)!.notifications),
            tiles: [
              SettingsTile.switchTile(
                onToggle: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Center(
                          child: Text(
                        AppLocalizations.of(context)!
                            .thisfeatureisnotavailableyet,
                        style: const TextStyle(fontSize: 30),
                      )),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                initialValue: true,
                leading: const Icon(Icons.circle_notifications),
                title: Text(AppLocalizations.of(context)!.pushnotifications),
              ),
              SettingsTile.switchTile(
                onToggle: (value) {
                  Provider.of<GlobalStatus>(context, listen: false)
                      .setaudionotifications(value);
                },
                initialValue: Provider.of<GlobalStatus>(context, listen: true)
                    .audionotifications,
                leading: const Icon(Icons.circle_notifications),
                title: Text(AppLocalizations.of(context)!.audionotifications),
              ),
            ],
          ),
          SettingsSection(
            title: Text(AppLocalizations.of(context)!.userinterface),
            tiles: [
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.thelanguage),
                leading: const Icon(Icons.translate),
                onPressed: (BuildContext context) {
                  showDialog(
                      context: context,
                      builder: (_) => const SetLanguageView());
                },
              ),
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.theme),
                description: Text(AppLocalizations.of(context)!.lightordark),
                leading: const Icon(Icons.format_paint),
                onPressed: (BuildContext context) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Center(
                          child: Text(
                        AppLocalizations.of(context)!
                            .thisfeatureisnotavailableyet,
                        style: const TextStyle(fontSize: 30),
                      )),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              )
            ],
          ),
          SettingsSection(
            title: Text(AppLocalizations.of(context)!.about),
            tiles: [
              SettingsTile(
                title: const Text('App version'),
                leading: const Icon(Icons.app_shortcut),
                onPressed: (BuildContext context) {
                  launchUrl(Uri.parse(githuburl));
                },
              ),
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.chainstatus),
                leading: const Icon(Icons.area_chart),
                onPressed: (BuildContext context) {
                  Navigator.pushNamed(context, '/status');
                },
              ),
              SettingsTile(
                title: const Text('Github'),
                description: Text(AppLocalizations.of(context)!.openwebsite),
                leading: const Icon(Icons.cloud_circle),
                onPressed: (BuildContext context) {
                  launchUrl(Uri.parse(githuburl));
                },
              ),
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.documentation),
                description: Text(AppLocalizations.of(context)!.openwebsite),
                leading: const Icon(Icons.cloud_circle),
                onPressed: (BuildContext context) {
                  launchUrl(Uri.parse(Documentation.url));
                },
              )
            ],
          ),
        ],
      );
    });
  }
}

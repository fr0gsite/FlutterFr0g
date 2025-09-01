import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/painting.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';

class PrivacyAndSecurityView extends StatelessWidget {
  const PrivacyAndSecurityView({super.key});

  Future<void> _clearCookies() async {
    final cookies = html.document.cookie?.split(';') ?? [];
    for (final cookie in cookies) {
      final eqPos = cookie.indexOf('=');
      final name = eqPos > -1 ? cookie.substring(0, eqPos) : cookie;
      html.document.cookie =
          '$name=;expires=Thu, 01 Jan 1970 00:00:00 GMT;path=/';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            color: Colors.black38,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: 500,
              child: Material(
                color: AppColor.nicegrey,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  side: BorderSide(color: Colors.white, width: 6, strokeAlign: 4.0),
                ),
                child: SettingsList(
                  platform: DevicePlatform.web,
                  sections: [
                    CustomSection(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          AppLocalizations.of(context)!
                              .settingprivacyandsecuritydescription,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SettingsSection(
                      tiles: [
                        SettingsTile(
                          leading: const Icon(Icons.vpn_key),
                          title:
                              Text(AppLocalizations.of(context)!.privatekey),
                          onPressed: (context) async {
                            const secstorage = FlutterSecureStorage();
                            await secstorage
                                .delete(key: AppConfig.secureStoragePKey);
                            await secstorage
                                .delete(key: AppConfig.secureStorageusername);
                            Provider.of<GlobalStatus>(context, listen: false)
                                .logout();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocalizations.of(context)!
                                        .logoutsuccessfull,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        SettingsTile(
                          leading: const Icon(Icons.cookie),
                          title: const Text('Cookies'),
                          onPressed: (context) async {
                            await _clearCookies();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Cookies cleared'),
                                ),
                              );
                            }
                          },
                        ),
                        SettingsTile(
                          leading: const Icon(Icons.cached),
                          title: const Text('Cache'),
                          onPressed: (context) {
                            PaintingBinding.instance.imageCache.clear();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Cache cleared'),
                              ),
                            );
                          },
                        ),
                        SettingsTile(
                          leading: const Icon(Icons.storage),
                          title: const Text('Local Storage'),
                          onPressed: (context) async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.clear();
                            const secstorage = FlutterSecureStorage();
                            await secstorage.deleteAll();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Local storage cleared'),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


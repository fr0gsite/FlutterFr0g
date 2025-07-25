import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config.dart';
import '../../datatypes/globalstatus.dart';
import 'impressum.dart';

class Informations extends StatefulWidget {
  const Informations({super.key});

  @override
  State<Informations> createState() => _InformationsState();
}

class _InformationsState extends State<Informations> {
  final ScrollController _scrollController = ScrollController();

  final TextStyle ruleTitleStyle = const TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w500,
    fontSize: 17,
  );

  final TextStyle subtitleStyle = const TextStyle(
    color: Colors.red,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  final TextStyle ruleTagStyle = const TextStyle(
    color: Colors.red,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      final max = _scrollController.position.maxScrollExtent;
      final min = _scrollController.position.minScrollExtent;
      final newOffset = _scrollController.offset + event.scrollDelta.dy;
      _scrollController.jumpTo(newOffset.clamp(min, max));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalStatus>(builder: (context, userstatus, child) {
      return Listener(
        onPointerSignal: _handlePointerSignal,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: PrimaryScrollController(
            controller: _scrollController,
            child: SettingsList(
              platform: DevicePlatform.web,
              lightTheme: SettingsThemeData(
                settingsListBackground: AppColor.nicegrey,
                titleTextColor: Colors.white,
                settingsSectionBackground:
                    Colors.white.withAlpha((0.8 * 255).toInt()),
              ),
              darkTheme:
                  const SettingsThemeData(settingsListBackground: AppColor.nicegrey),
              sections: [
                SettingsSection(
                  title: Text(
                    AppLocalizations.of(context)!.links,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  tiles: [
                    SettingsTile(
                      title: const Text('Telegram'),
                      description:
                          Text(AppLocalizations.of(context)!.openwebsite),
                      leading: const Icon(Icons.telegram),
                      onPressed: (BuildContext context) {
                        launchUrl(Uri.parse(telegramurl));
                      },
                    ),
                    SettingsTile(
                      title: Text(AppLocalizations.of(context)!.linktoupdown),
                      description:
                          Text(AppLocalizations.of(context)!.openwebsite),
                      leading: const Icon(Icons.link),
                      onPressed: (BuildContext context) {
                        launchUrl(Uri.parse(serverstatus));
                      },
                    ),
                    SettingsTile(
                      title:
                          Text(AppLocalizations.of(context)!.linktodocumentation),
                      description:
                          Text(AppLocalizations.of(context)!.openwebsite),
                      leading: const Icon(Icons.link),
                      onPressed: (BuildContext context) {
                        launchUrl(Uri.parse(Documentation.url));
                      },
                    ),
                    SettingsTile(
                      title: Text(AppLocalizations.of(context)!.whitepaper),
                      description:
                          Text(AppLocalizations.of(context)!.openwebsite),
                      leading: const Icon(Icons.link),
                      onPressed: (BuildContext context) {
                        launchUrl(Uri.parse(whitepaperurl));
                      },
                    ),
                    SettingsTile(
                      title: Text(AppLocalizations.of(context)!.impressum),
                      leading: const Icon(Icons.info_outline),
                      onPressed: (BuildContext context) {
                        showDialog(
                          context: context,
                          builder: (_) => const ImpressumView(),
                        );
                      },
                    ),
                  ],
                ),
                SettingsSection(
                  title: Text(
                    AppLocalizations.of(context)!.rulesandguidelines,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  tiles: [
                    SettingsTile(
                      title:
                          Text(AppLocalizations.of(context)!.rule1, style: ruleTitleStyle),
                      description: Text(
                        '${AppLocalizations.of(context)!.punishment}: ${AppLocalizations.of(context)!.permanentexclusion}',
                        style: subtitleStyle,
                      ),
                      leading: Text(
                        '${AppLocalizations.of(context)!.rule} 1',
                        style: ruleTagStyle,
                      ),
                      onPressed: (BuildContext context) {
                        launchUrl(Uri.parse(Documentation.rules));
                      },
                    ),
                    SettingsTile(
                      title:
                          Text(AppLocalizations.of(context)!.rule2, style: ruleTitleStyle),
                      description: Text(
                        '${AppLocalizations.of(context)!.punishment}: ${AppLocalizations.of(context)!.permanentexclusion}',
                        style: subtitleStyle,
                      ),
                      leading: Text(
                        '${AppLocalizations.of(context)!.rule} 2',
                        style: ruleTagStyle,
                      ),
                      onPressed: (BuildContext context) {
                        launchUrl(Uri.parse(Documentation.rules));
                      },
                    ),
                    SettingsTile(
                      title:
                          Text(AppLocalizations.of(context)!.rule3, style: ruleTitleStyle),
                      description: Text(
                        '${AppLocalizations.of(context)!.punishment}: ${AppLocalizations.of(context)!.permanentexclusion}',
                        style: subtitleStyle,
                      ),
                      leading: Text(
                        '${AppLocalizations.of(context)!.rule} 3',
                        style: ruleTagStyle,
                      ),
                      onPressed: (BuildContext context) {
                        launchUrl(Uri.parse(Documentation.rules));
                      },
                    ),
                    SettingsTile(
                      title:
                          Text(AppLocalizations.of(context)!.rule4, style: ruleTitleStyle),
                      description: Text(
                        '${AppLocalizations.of(context)!.punishment}: ${AppLocalizations.of(context)!.permanentexclusion}',
                        style: subtitleStyle,
                      ),
                      leading: Text(
                        '${AppLocalizations.of(context)!.rule} 4',
                        style: ruleTagStyle,
                      ),
                      onPressed: (BuildContext context) {
                        launchUrl(Uri.parse(Documentation.rules));
                      },
                    ),
                    SettingsTile(
                      title:
                          Text(AppLocalizations.of(context)!.rule5, style: ruleTitleStyle),
                      description: Text(
                        '${AppLocalizations.of(context)!.punishment}: ${AppLocalizations.of(context)!.sanctionandban}',
                        style: subtitleStyle,
                      ),
                      leading: Text(
                        '${AppLocalizations.of(context)!.rule} 5',
                        style: ruleTagStyle,
                      ),
                      onPressed: (BuildContext context) {
                        launchUrl(Uri.parse(Documentation.rules));
                      },
                    ),
                    SettingsTile(
                      title:
                          Text(AppLocalizations.of(context)!.rule6, style: ruleTitleStyle),
                      description: Text(
                        '${AppLocalizations.of(context)!.punishment}: ${AppLocalizations.of(context)!.sanctionandban}',
                        style: subtitleStyle,
                      ),
                      leading: Text(
                        '${AppLocalizations.of(context)!.rule} 6',
                        style: ruleTagStyle,
                      ),
                      onPressed: (BuildContext context) {
                        launchUrl(Uri.parse(Documentation.rules));
                      },
                    ),
                    SettingsTile(
                      title:
                          Text(AppLocalizations.of(context)!.rule7, style: ruleTitleStyle),
                      description: Text(
                        '${AppLocalizations.of(context)!.punishment}: ${AppLocalizations.of(context)!.sanctionandban}',
                        style: subtitleStyle,
                      ),
                      leading: Text(
                        '${AppLocalizations.of(context)!.rule} 7',
                        style: ruleTagStyle,
                      ),
                      onPressed: (BuildContext context) {
                        launchUrl(Uri.parse(Documentation.rules));
                      },
                    ),
                    SettingsTile(
                      title:
                          Text(AppLocalizations.of(context)!.rule8, style: ruleTitleStyle),
                      description: Text(
                        '${AppLocalizations.of(context)!.punishment}: ${AppLocalizations.of(context)!.sanctionandban}',
                        style: subtitleStyle,
                      ),
                      leading: Text(
                        '${AppLocalizations.of(context)!.rule} 8',
                        style: ruleTagStyle,
                      ),
                      onPressed: (BuildContext context) {
                        launchUrl(Uri.parse(Documentation.rules));
                      },
                    ),
                    SettingsTile(
                      title:
                          Text(AppLocalizations.of(context)!.rule9, style: ruleTitleStyle),
                      description: Text(
                        '${AppLocalizations.of(context)!.punishment}: ${AppLocalizations.of(context)!.sanctionandban}',
                        style: subtitleStyle,
                      ),
                      leading: Text(
                        '${AppLocalizations.of(context)!.rule} 9',
                        style: ruleTagStyle,
                      ),
                      onPressed: (BuildContext context) {
                        launchUrl(Uri.parse(Documentation.rules));
                      },
                    ),
                    SettingsTile(
                      title:
                          Text(AppLocalizations.of(context)!.rule10, style: ruleTitleStyle),
                      description: Text(
                        '${AppLocalizations.of(context)!.punishment}: ${AppLocalizations.of(context)!.sanctionandban}',
                        style: subtitleStyle,
                      ),
                      leading: Text(
                        '${AppLocalizations.of(context)!.rule} 10',
                        style: ruleTagStyle,
                      ),
                      onPressed: (BuildContext context) {
                        launchUrl(Uri.parse(Documentation.rules));
                      },
                    ),
                    SettingsTile(
                      title:
                          Text(AppLocalizations.of(context)!.rule11, style: ruleTitleStyle),
                      description: Text(
                        '${AppLocalizations.of(context)!.punishment}: ${AppLocalizations.of(context)!.sanctionandban}',
                        style: subtitleStyle,
                      ),
                      leading: Text(
                        '${AppLocalizations.of(context)!.rule} 11',
                        style: ruleTagStyle,
                      ),
                      onPressed: (BuildContext context) {
                        launchUrl(Uri.parse(Documentation.rules));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

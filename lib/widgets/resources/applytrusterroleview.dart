import 'package:auto_size_text/auto_size_text.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/userconfig.dart';
import 'package:flutter/material.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:fr0gsite/widgets/resources/trustercriteriaview.dart';

class ApplyTrusterroleView extends StatefulWidget {
  const ApplyTrusterroleView({super.key, required this.userconfig});
  final UserConfig userconfig;
  @override
  ApplyTrusterroleViewState createState() => ApplyTrusterroleViewState();
}

class ApplyTrusterroleViewState extends State<ApplyTrusterroleView> {
  @override
  Widget build(BuildContext context) {
    final globalStatus = Provider.of<GlobalStatus>(context);
    final messenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context)!;
    final requirements = <String>[
      localization.criteriayear,
      localization.criteriauploads,
      localization.criteriacomments,
    ];
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
          color: Colors.black.withAlpha((0.6 * 255).toInt()), // Optional overlay for better text visibility
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AutoSizeText(
                      localization.applyasatruster,
                      minFontSize: 26,
                      style: (theme.textTheme.headlineSmall ?? const TextStyle()).copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AutoSizeText(
                      localization.trusterexplain,
                      style: (theme.textTheme.bodyLarge ?? const TextStyle()).copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24, width: 1.5),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AutoSizeText(
                              'Du musst diese Voraussetzungen erfüllen, um sich für die Rolle bewerben zu können.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              minFontSize: 18,
                              maxLines: 3,
                            ),
                            const SizedBox(height: 16),
                            ...requirements.map(
                              (text) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      margin: const EdgeInsets.only(top: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        text,
                                        style: (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (!globalStatus.isLoggedin) {
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text(localization.forthisfeatureyouhavetologin),
                              ),
                            );
                            return;
                          }
                          showDialog(
                            context: context,
                            builder: (context) => const TrusterCriteriaView(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 6,
                        ),
                        icon: const Icon(Icons.verified, color: Colors.white),
                        label: AutoSizeText(
                          localization.apply,
                          minFontSize: 20,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
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

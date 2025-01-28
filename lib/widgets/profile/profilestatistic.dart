import 'package:fr0gsite/datatypes/userconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Profilestatistic extends StatelessWidget {
  final UserConfig userconfig;
  const Profilestatistic({super.key, required this.userconfig});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 1000,
        minHeight: 50,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withAlpha((0.4 * 255).toInt()),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "${AppLocalizations.of(context)!.follower}: ${userconfig.numoffollowers}",
                  style: const TextStyle(color: Colors.white, fontSize: 20)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "${AppLocalizations.of(context)!.subscriptions}: ${userconfig.numofsubscribtions}",
                  style: const TextStyle(color: Colors.white, fontSize: 20)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "${AppLocalizations.of(context)!.posts}: ${userconfig.numofuploads}",
                  style: const TextStyle(color: Colors.white, fontSize: 20)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "${AppLocalizations.of(context)!.comments}: ${userconfig.numofcomments}",
                  style: const TextStyle(color: Colors.white, fontSize: 20)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "${AppLocalizations.of(context)!.favorites}: ${userconfig.numoffavorites}",
                  style: const TextStyle(color: Colors.white, fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}

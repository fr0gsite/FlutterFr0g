import 'package:fr0gsite/widgets/report/reportnextbutton.dart';
import 'package:fr0gsite/widgets/report/reportobjectview.dart';
import 'package:flutter/material.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';

class Report1 extends StatefulWidget {
  const Report1({super.key});

  @override
  State<Report1> createState() => _Report1State();
}

class _Report1State extends State<Report1> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
        spacing: 10,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/frog_police.png',
              height: 150,
              width: 150,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(AppLocalizations.of(context)!.whichrulewasviolated,
                style: const TextStyle(fontSize: 20, color: Colors.white)),
          ),
          const Divider(color: Colors.white),
          const ReportObjectView(),
          const ReportNextButton(),
        ]);
  }
}

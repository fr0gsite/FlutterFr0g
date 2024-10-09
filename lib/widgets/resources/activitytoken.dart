import 'package:auto_size_text/auto_size_text.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/userconfig.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActivityToken extends StatefulWidget {
  const ActivityToken({super.key, required this.userconfig});
  final UserConfig userconfig;
  @override
  _ActivityTokenState createState() => _ActivityTokenState();
}

class _ActivityTokenState extends State<ActivityToken> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // Your widget code here
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AutoSizeText(
              AppLocalizations.of(context)!.activitytoken,
              minFontSize: 20,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: AutoSizeText(
              AppLocalizations.of(context)!.activitytokenexplain,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: LinearPercentIndicator(
              animation: true,
              animationDuration: 1000,
              barRadius: const Radius.circular(15),
              lineHeight: 30,
              percent:
                  widget.userconfig.acttoken / widget.userconfig.acttokenmax,
              backgroundColor: Ressourcecolor.background.withOpacity(0.5),
              progressColor: Ressourcecolor.act,
              center: AutoSizeText(
                "${widget.userconfig.acttoken}/${widget.userconfig.acttokenmax}",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

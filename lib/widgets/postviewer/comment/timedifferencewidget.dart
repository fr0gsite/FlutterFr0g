import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TimeDifferenceWidget extends StatefulWidget {
  final String dateTimeString;

  const TimeDifferenceWidget({super.key, required this.dateTimeString});

  @override
  TimeDifferenceWidgetState createState() => TimeDifferenceWidgetState();
}

class TimeDifferenceWidgetState extends State<TimeDifferenceWidget> {
  late DateTime inputDateTime;
  String difference = '';

  @override
  void initState() {
    super.initState();
    inputDateTime = DateTime.parse(widget.dateTimeString);
  }

  calculateTimeDifference() {
    final currentDateTime = DateTime.now();
    final differenceInSeconds =
        currentDateTime.difference(inputDateTime).inSeconds;
    setState(() {
      if (differenceInSeconds < 60) {
        difference =
            '$differenceInSeconds ${AppLocalizations.of(context)!.secondsago}';
      } else if (differenceInSeconds < 3600) {
        final minutes = differenceInSeconds ~/ 60;
        difference = '$minutes ${AppLocalizations.of(context)!.minutesago}';
      } else if (differenceInSeconds < 86400) {
        final hours = differenceInSeconds ~/ 3600;
        difference = '$hours ${AppLocalizations.of(context)!.hoursago}';
      } else {
        final days = differenceInSeconds ~/ 86400;
        difference = '$days ${AppLocalizations.of(context)!.daysago}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    calculateTimeDifference();
    return MouseRegion(
      onEnter: (_) => calculateTimeDifference(),
      child: Tooltip(
        message: DateFormat('yyyy-MM-dd HH:mm:ss').format(inputDateTime),
        child: Text(difference,
            style: const TextStyle(fontSize: 12, color: Colors.white)),
      ),
    );
  }
}

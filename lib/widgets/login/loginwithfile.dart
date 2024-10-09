import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Loginwithfile extends StatefulWidget {
  const Loginwithfile({super.key});

  @override
  State<Loginwithfile> createState() => _LoginwithfileState();
}

class _LoginwithfileState extends State<Loginwithfile> {
  @override
  Widget build(BuildContext context) {
    return Text(AppLocalizations.of(context)!.thisfeatureisnotavailableyet);
  }
}

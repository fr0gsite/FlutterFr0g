import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavoriteCommentsView extends StatefulWidget {
  const FavoriteCommentsView({super.key});

  @override
  State<FavoriteCommentsView> createState() => _FavoriteCommentsViewState();
}

class _FavoriteCommentsViewState extends State<FavoriteCommentsView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AutoSizeText(
          AppLocalizations.of(context)!.thisfeatureisnotavailableyet),
    );
  }
}

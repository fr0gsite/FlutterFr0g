import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavoriteTagsView extends StatefulWidget {
  const FavoriteTagsView({super.key});

  @override
  State<FavoriteTagsView> createState() => _FavoriteTagsViewState();
}

class _FavoriteTagsViewState extends State<FavoriteTagsView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AutoSizeText(
          AppLocalizations.of(context)!.thisfeatureisnotavailableyet),
    );
  }
}

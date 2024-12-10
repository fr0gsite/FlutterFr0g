import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/favoritetag.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:provider/provider.dart';

class FavoriteTagsView extends StatefulWidget {
  const FavoriteTagsView({super.key});

  @override
  State<FavoriteTagsView> createState() => _FavoriteTagsViewState();
}

class _FavoriteTagsViewState extends State<FavoriteTagsView> {
  Future userfavoriteTags = Future.value([]);

  @override
  void initState() {
    super.initState();
    userfavoriteTags = getuserfavoriteTags();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AutoSizeText(
          AppLocalizations.of(context)!.thisfeatureisnotavailableyet),
    );
  }

  Future getuserfavoriteTags() async {
    debugPrint("Get User Favorite Tags");
    bool isuserloggedin = Provider.of<GlobalStatus>(context, listen: false)
        .isLoggedin;
    if (!isuserloggedin) {
      return [];
    }
    String username = Provider.of<GlobalStatus>(context, listen: false).username;
    debugPrint("Get User Favorite Tags: $username");
    List<FavoriteTag> favorites = await Chainactions().getfavoritetagsofuser(username);
  }

}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/favoritetag.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:provider/provider.dart';

import '../infoscreens/pleaselogin.dart';

class FavoriteTagsView extends StatefulWidget {
  const FavoriteTagsView({super.key});

  @override
  State<FavoriteTagsView> createState() => _FavoriteTagsViewState();
}

class _FavoriteTagsViewState extends State<FavoriteTagsView> {
  List<FavoriteTag> userfavoriteTags = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getuserfavoriteTags();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalStatus>(builder: (context, userstatus, child) {
      if (userstatus.isLoggedin) {
        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (userfavoriteTags == null || userfavoriteTags!.isEmpty) {
          return const Center(
            child: Text("No favorite Tags available."),
          );
        }

        return Container(
          margin: EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: userfavoriteTags!.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey),
                padding: EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        deleteFavoriteTag(userfavoriteTags[index].globaltagid.toString(),index);
                      },
                      child: Icon(
                        Icons.favorite,
                        color: Colors.yellow,
                        size: 25,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(userfavoriteTags[index].globaltagname)
                  ],
                ),
              );
            },
          ),
        );
      } else {
        return const Stack(
          children: [
            Pleaselogin(),
          ],
        );
      }
    });
  }

  Future<bool> deleteFavoriteTag(String commentid, int index) async {
    debugPrint("Favorite Tag $commentid");
    if (Provider.of<GlobalStatus>(context, listen: false).isLoggedin) {
      String username =
          Provider.of<GlobalStatus>(context, listen: false).username;
      String permission =
          Provider.of<GlobalStatus>(context, listen: false).permission;

      Chainactions temp = Chainactions()
        ..setusernameandpermission(username, permission);
      bool result = false;

      await temp.deletefavoritetag(commentid).then((value) {
        result = value;
        if (result) {
          // Remove the item from the local list and update the UI
          setState(() {
            userfavoriteTags.removeAt(index);
          });
        } else {
          debugPrint("Failed to delete favorite comment $commentid");
        }
      });

      return result;
    } else {
      debugPrint("User is not logged in.");
      return false;
    }
  }

  void getuserfavoriteTags() async {
    debugPrint("Get User Favorite Tags");
    String username =
        Provider.of<GlobalStatus>(context, listen: false).username;
    debugPrint("Get User Favorite Tags: $username");
    userfavoriteTags = await Chainactions().getfavoritetagsofuser(username);
    setState(() {
      isLoading = false;
    });
  }
}

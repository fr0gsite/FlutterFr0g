import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/favoritecomment.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/widgets/infoscreens/pleaselogin.dart';
import 'package:provider/provider.dart';

class FavoriteCommentsView extends StatefulWidget {
  const FavoriteCommentsView({super.key});

  @override
  State<FavoriteCommentsView> createState() => _FavoriteCommentsViewState();
}

class _FavoriteCommentsViewState extends State<FavoriteCommentsView> {
  Future? getfavorites;

  @override
  void initState() {
    super.initState();
    getfavorites = getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalStatus>(builder: (context, userstatus, child) {
      if (userstatus.isLoggedin) {
        return FutureBuilder(future: getfavorites, builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: 0,
              itemBuilder: (context, index) {
                return const ListTile(
                  title: AutoSizeText(""),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
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

  Future getFavorites() async {
    var username = Provider.of<GlobalStatus>(context, listen: false).username;
    List<FavoriteComment> comments = await Chainactions().getfavoritecommentsofuser(username);
    return comments;
  }
}

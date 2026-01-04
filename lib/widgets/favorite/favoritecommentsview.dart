import 'package:flutter/material.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/comment.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:fr0gsite/widgets/infoscreens/pleaselogin.dart';
import 'package:fr0gsite/widgets/postviewer/comment/commentrichtext.dart';
import 'package:provider/provider.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';

import '../postviewer/comment/timedifferencewidget.dart';
import '../postviewer/commentandtagbutton.dart';

class FavoriteCommentsView extends StatefulWidget {
  const FavoriteCommentsView({super.key});

  @override
  State<FavoriteCommentsView> createState() => _FavoriteCommentsViewState();
}

class _FavoriteCommentsViewState extends State<FavoriteCommentsView> {
  List<Comment>? favoriteComments;
  List<Upload>? uploadsfromfavoriteComments;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  void loadFavorites() async {
    var username = Provider.of<GlobalStatus>(context, listen: false).username;
    favoriteComments = await Chainactions().getfavoritecommentsofuser(username);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalStatus>(builder: (context, userstatus, child) {
      if (userstatus.isLoggedin) {
        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(color:Colors.white),
          );
        }

        if (favoriteComments == null || favoriteComments!.isEmpty) {
          return Center(
            child: Text(AppLocalizations.of(context)!.nofavoritesfound),
          );
        }

        return ListView.builder(
          itemCount: favoriteComments!.length,
          itemBuilder: (context, index) {
            //horizontal next to each other
            return Center(
                child: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.start,
                children: [
                  GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/${AppConfig.postviewerurlpath}/${favoriteComments![index].uploadid}', arguments: {
                    'postId': favoriteComments![index].uploadid,
                    });
                  },
                  child: const Image(
                    image: AssetImage("assets/images/logo_w.png"),
                    width: 100,
                    height: 100,
                  ),
                  ),
                  Container(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [        
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              commentandtagbutton(
                                  favoriteComments![index].commentId.toString(),
                                  Icons.favorite,
                                  AppLocalizations.of(context)!.discard,
                                  (commentId) => deleltefavoriteComment(commentId, index),
                                  true,
                                  0,
                                  Colors.yellow,
                                  Colors.orange),
                              
                              TextButton(
                                child: Text(favoriteComments![index].author,
                                  style: const TextStyle(
                                    fontSize: 16, color: Colors.white)),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context,
                                      '/profile/${favoriteComments![index].author}',
                                      arguments: {'username': favoriteComments![index].author});
                                },
                              ), 
                  
                              TimeDifferenceWidget(dateTimeString: favoriteComments![index].creationTime.toString()), 
                            ],
                          ),
                        ),
                        const Divider(
                          height: 10,
                        ),
                        SelectionArea(
                          child: commentRichText(favoriteComments![index].commentText),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
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


  Future<bool> deleltefavoriteComment(String commentid, int index) async {
    debugPrint("Favorite comment $commentid");
    if (Provider.of<GlobalStatus>(context, listen: false).isLoggedin) {
      String username =
          Provider.of<GlobalStatus>(context, listen: false).username;
      String permission =
          Provider.of<GlobalStatus>(context, listen: false).permission;

      Chainactions temp = Chainactions()
        ..setusernameandpermission(username, permission);
      bool result = false;

      await temp.deletefavoritecomment(commentid).then((value) {
        result = value;
        if (result) {
          // Remove the item from the local list and update the UI
          setState(() {
            favoriteComments!.removeAt(index);
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
}
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/favoritecomment.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/widgets/infoscreens/pleaselogin.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../postviewer/comment/timedifferencewidget.dart';
import '../postviewer/commentandtagbutton.dart';

class FavoriteCommentsView extends StatefulWidget {
  const FavoriteCommentsView({super.key});

  @override
  State<FavoriteCommentsView> createState() => _FavoriteCommentsViewState();
}

class _FavoriteCommentsViewState extends State<FavoriteCommentsView> {
  List<FavoriteComment>? favoriteComments;
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
            child: CircularProgressIndicator(),
          );
        }

        if (favoriteComments == null || favoriteComments!.isEmpty) {
          return const Center(
            child: Text("No favorite comments available."),
          );
        }

        return ListView.builder(
          itemCount: favoriteComments!.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
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
                            favoriteComments![index].commentid.toString(),
                            Icons.favorite,
                            "Favorite",
                            (commentId) => favoriteComment(commentId, index),
                            true,
                            0,
                            Colors.yellow,
                            Colors.orange),
                        TimeDifferenceWidget(
                            dateTimeString: favoriteComments![index]
                                .creationtime
                                .toString()),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 10,
                  ),
                  SelectionArea(
                    child: buildRichTextWithAutoSize(
                        favoriteComments![index].commenttext),
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

  Widget buildRichTextWithAutoSize(String text) {
    final RegExp linkRegex = RegExp(
      r'(https?:\/\/[^\s]+)', // Matches URLs starting with http:// or https://
      caseSensitive: false,
    );

    final List<InlineSpan> spans = [];
    int currentIndex = 0;

    // Parse text and identify links
    for (final match in linkRegex.allMatches(text)) {
      final String linkText = match.group(0)!;
      final int start = match.start;

      // Add text before the link
      if (start > currentIndex) {
        spans.add(TextSpan(
          text: text.substring(currentIndex, start),
          style: const TextStyle(color: Colors.white), // Default text style
        ));
      }

      // Add the link text with special styling
      spans.add(
        TextSpan(
          text: linkText,
          style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
              decorationColor: Colors.blue),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              if (await canLaunchUrl(Uri.parse(linkText))) {
                await launchUrl(Uri.parse(linkText));
              } else {
                debugPrint('Could not launch $linkText');
              }
            },
        ),
      );

      currentIndex = match.end;
    }

    // Add remaining text after the last link
    if (currentIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentIndex),
        style: const TextStyle(color: Colors.white),
      ));
    }

    return AutoSizeText.rich(
      TextSpan(
        children: spans,
      ),
      minFontSize: 12,
      maxFontSize: 14,
    );
  }

  Future<bool> upvotecomment(String commentid) async {
    debugPrint("Upvote comment $commentid");
    if (Provider.of<GlobalStatus>(context, listen: false).isLoggedin) {
      String username =
          Provider.of<GlobalStatus>(context, listen: false).username;
      String permission =
          Provider.of<GlobalStatus>(context, listen: false).permission;

      Chainactions temp = Chainactions()
        ..setusernameandpermission(username, permission);
      bool result = false;
      await temp.votecomment(commentid, 1).then((value) {
        result = value;
      });
      if (!result) {
        //Show error message
      }
      return result;
    } else {
      // Show error message. User is not logged in
      return false;
    }
  }

  Future<bool> downvotecomment(String commentid) async {
    debugPrint("Downvote comment $commentid");
    if (Provider.of<GlobalStatus>(context, listen: false).isLoggedin) {
      String username =
          Provider.of<GlobalStatus>(context, listen: false).username;
      String permission =
          Provider.of<GlobalStatus>(context, listen: false).permission;

      Chainactions temp = Chainactions()
        ..setusernameandpermission(username, permission);
      bool result = false;
      await temp.votecomment(commentid, 0).then((value) {
        result = value;
      });
      if (!result) {
        //Show error message
      }
      return result;
    } else {
      // Show error message. User is not logged in
      return false;
    }
  }

  Future<bool> favoriteComment(String commentid, int index) async {
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

  Future<List<FavoriteComment>> getFavorites() async {
    var username = Provider.of<GlobalStatus>(context, listen: false).username;
    List<FavoriteComment> comments =
        await Chainactions().getfavoritecommentsofuser(username);
    return comments;
  }
}

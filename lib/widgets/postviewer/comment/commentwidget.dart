import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/comment.dart';
import 'package:fr0gsite/datatypes/commentbarstatus.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/postviewerstatus.dart';
import 'package:fr0gsite/widgets/login/login.dart';
import 'package:fr0gsite/widgets/postviewer/comment/commentreply.dart';
import 'package:fr0gsite/widgets/postviewer/comment/timedifferencewidget.dart';
import 'package:fr0gsite/widgets/postviewer/commentandtagbutton.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config.dart';
import '../../report/report.dart';

class CommentWidget extends StatefulWidget {
  final Comment comment;
  final List<Comment> subComments;
  final List<Comment> comments;
  final int level;

  const CommentWidget(
      {super.key,
      required this.comment,
      required this.subComments,
      required this.comments,
      required this.level});

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool expansionState = true;
  bool initiallyExpanded = true;

  @override
  Widget build(BuildContext context) {
    expansionState =
        Provider.of<CommentBarStatus>(context, listen: true).commentFold;
    List<Comment> subComments = widget.comments
        .where((comment) =>
            comment.parentCommentId == widget.comment.commentId.toInt())
        .toList();
    subComments.removeWhere((element) => element.commentId == 0);

    return Padding(
      padding: EdgeInsets.only(left: 5.0 * widget.level),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              width: widget.level > 1 ? 4.0 : 0, // Die Dicke der Linie
              color: commentLevelColor[widget.level], // Die Farbe der Linie
            ),
          ),
        ),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          onExpansionChanged: (value) {
            debugPrint("ExpansionTile changed to $value");
            setState(() {
              expansionState = value;
            });
          },
          textColor: Colors.white,
          iconColor: subComments.isNotEmpty ? Colors.white : Colors.transparent,
          collapsedIconColor:
              subComments.isNotEmpty ? Colors.white : Colors.transparent,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    commentandtagbutton(
                        widget.comment.commentId.toString(),
                        Icons.add_circle_outline_sharp,
                        "Upvote",
                        upvotecomment,
                        false,
                        0,
                        Colors.green,
                        Colors.orange),
                    commentandtagbutton(
                        widget.comment.commentId.toString(),
                        Icons.do_not_disturb_on_outlined,
                        "Downvote",
                        downvotecomment,
                        false,
                        0,
                        Colors.red,
                        Colors.orange),
                    commentandtagbutton(
                        widget.comment.commentId.toString(),
                        Icons.star,
                        "Favorite",
                        favoritecomment,
                        false,
                        0,
                        Colors.yellow,
                        Colors.orange),
                    TextButton(
                      child: Text(widget.comment.author,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white)),
                      onPressed: () {
                        //Open user profile
                        Navigator.pushReplacementNamed(context,
                            '/profile/${widget.comment.author}',
                            arguments: {'accountname': widget.comment.author});
                      },
                    ),
                    TimeDifferenceWidget(
                        dateTimeString: widget.comment.creationTime.toString()),
                  ],
                ),
              ),
              const Divider(
                height: 10,
              ),
              SelectionArea(
                  child: buildRichTextWithAutoSize(widget.comment
                      .commentText) /*AutoSizeText(
                widget.comment.commentText,
                minFontSize: 12,
                maxFontSize: 14,
                style: const TextStyle(color: Colors.white),
              )*/
                  ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(
              top: 8,
            ),
            child: Row(
              children: [
                IconButton(
                  tooltip: AppLocalizations.of(context)!.reply,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        Colors.blue.withOpacity(0.5)),
                    shape: WidgetStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  onPressed: () {
                    if (Provider.of<GlobalStatus>(context, listen: false)
                        .isLoggedin) {
                      debugPrint("Create reply to ${widget.comment.author}");
                      writecomment(context, widget.comment);
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const Login();
                        },
                      );
                    }
                  },
                  icon: const Icon(Icons.reply, color: Colors.white),
                ),
                IconButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        Colors.red.withOpacity(0.5)),
                    shape: WidgetStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  tooltip: AppLocalizations.of(context)!.report,
                  onPressed: () {
                    debugPrint("Report comment from ${widget.comment.author}");
                    showDialog(
                      context: context,
                      builder: ((context) => Report(
                            mode: "comment",
                            id: widget.comment.commentId.toInt(),
                          )),
                    );
                  },
                  icon: const Icon(Icons.report, color: Colors.white),
                ),
                const Spacer(),
                subComments.isNotEmpty
                    ? expansionState
                        ? Container()
                        : AutoSizeText("${subComments.length} Replies",
                            style: const TextStyle(color: Colors.white))
                    : Container()
              ],
            ),
          ),
          children: subComments
              .map(
                (subComment) => CommentWidget(
                    comment: subComment,
                    subComments: subComments,
                    comments: widget.comments,
                    level: widget.level + 1),
              )
              .toList(),
        ),
      ),
    );
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
            decorationColor: Colors.blue
          ),
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

  Widget commentbutton(IconData icon, String tooltip, function, bool isliked,
      int likecount, Color primary, Color secondary) {
    return LikeButton(
      mainAxisAlignment: MainAxisAlignment.start,
      size: 25,
      circleColor: CircleColor(start: primary, end: primary),
      bubblesColor: BubblesColor(
        dotPrimaryColor: primary,
        dotSecondaryColor: secondary,
      ),
      isLiked: isliked,
      likeBuilder: (bool isLiked) {
        return Icon(
          icon,
          color: isLiked ? primary : Colors.white,
          size: 25,
        );
      },
      onTap: function,
    );
  }

  void replycallback(value, String comment) {
    debugPrint("Reply callback called with $value");
    if (value) {
      Provider.of<PostviewerStatus>(context, listen: false)
          .doupdatecommentlist();
    }
  }

  void writecomment(BuildContext context, Comment comment) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor:
          Colors.black.withOpacity(0.5), // Grau ausgegrauter Hintergrund
      builder: (BuildContext context) {
        return CommentReply(comment: comment, callback: replycallback);
      },
    );
  }

  Future<bool> example(bool value) async {
    return true;
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

  Future<bool> favoritecomment(String commentid) async {
    debugPrint("Favorite comment $commentid");
    if (Provider.of<GlobalStatus>(context, listen: false).isLoggedin) {
      String username =
          Provider.of<GlobalStatus>(context, listen: false).username;
      String permission =
          Provider.of<GlobalStatus>(context, listen: false).permission;

      Chainactions temp = Chainactions()
        ..setusernameandpermission(username, permission);
      bool result = false;
      await temp.addfavoritecomment(commentid).then((value) {
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
}

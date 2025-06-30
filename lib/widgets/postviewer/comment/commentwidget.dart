import 'package:auto_size_text/auto_size_text.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/comment.dart';
import 'package:fr0gsite/datatypes/commentbarstatus.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/postviewerstatus.dart';
import 'package:fr0gsite/widgets/login/login.dart';
import 'package:fr0gsite/widgets/postviewer/comment/commentreply.dart';
import 'package:fr0gsite/widgets/postviewer/comment/commentrichtext.dart';
import 'package:fr0gsite/widgets/postviewer/comment/timedifferencewidget.dart';
import 'package:fr0gsite/widgets/postviewer/commentandtagbutton.dart';
import 'package:flutter/material.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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
  
  bool isliked = false;
  bool isdisliked = false;
  bool isfavorited = false;

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
                        isliked,
                        0,
                        Colors.green,
                        Colors.orange),
                    commentandtagbutton(
                        widget.comment.commentId.toString(),
                        Icons.do_not_disturb_on_outlined,
                        "Downvote",
                        downvotecomment,
                        isdisliked,
                        0,
                        Colors.red,
                        Colors.orange),
                    commentandtagbutton(
                        widget.comment.commentId.toString(),
                        Icons.favorite,
                        isfavorited ? AppLocalizations.of(context)!.discard : AppLocalizations.of(context)!.favoritize,
                        favoritecomment,
                        isfavorited,
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
                  child: commentRichText(widget.comment.commentText)
                  ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(
              top: 8,
            ),
            child: Row(
              children: [
                SizedBox(
                  height: 30,
                  child: FloatingActionButton.extended(
                    heroTag: null,
                    onPressed: () {
                      if (Provider.of<GlobalStatus>(context, listen: false)
                          .isLoggedin) {
                        debugPrint("Create replay to ${widget.comment.author}");
                        writecomment(context, widget.comment);
                      } else {
                        {
                          showDialog(
                              context: context,
                              builder: ((context) {
                                return const Login();
                              }));
                        }
                      }
                    },
                    hoverColor: Colors.blue,
                    backgroundColor: Colors.blue.withAlpha((0.3 * 255).toInt()),
                    label: Text(AppLocalizations.of(context)!.reply,
                        style: const TextStyle(color: Colors.white)),
                    icon: const Icon(Icons.reply, color: Colors.white),
                    shape: ShapeBorder.lerp(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        0.5),
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: FloatingActionButton.extended(
                    heroTag: null,
                    onPressed: () {
                      debugPrint(
                          "Report comment from ${widget.comment.author}");
                      showDialog(
                        context: context,
                        builder: ((context) => Report(
                              id: widget.comment.commentId.toInt(),
                              type: 2,
                            )),
                      );
                    },
                    hoverColor: Colors.red,
                    backgroundColor: Colors.red.withAlpha((0.3 * 255).toInt()),
                    label: Text(AppLocalizations.of(context)!.report,
                        style: const TextStyle(color: Colors.white)),
                    icon: const Icon(Icons.report, color: Colors.white),
                    shape: ShapeBorder.lerp(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        0.5),
                  ),
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
          Colors.black.withAlpha((0.5 * 255).toInt()),
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
        setState(() {
          isliked = result;
        });
      });
      if (!result) {
        //Show error message
      }
      return result;
    } else {
      showDialog(
          context: context,
          builder: ((context) {
            return const Login();
          }));
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
        setState(() {
          isdisliked = result;
        });
      });
      if (!result) {
        //Show error message
      }
      return result;
    } else {
      showDialog(
          context: context,
          builder: ((context) {
            return const Login();
          }));
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
      showDialog(
          context: context,
          builder: ((context) {
            return const Login();
          }));
      return false;
    }
  }
}
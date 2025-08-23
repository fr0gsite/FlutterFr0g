import 'package:auto_size_text/auto_size_text.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/comment.dart';
import 'package:fr0gsite/datatypes/commentbarstatus.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/postviewerstatus.dart';
import 'package:fr0gsite/widgets/login/login.dart';
import 'package:fr0gsite/widgets/postviewer/comment/newcommentview.dart';
import 'package:flutter/material.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CommentBarTop extends StatefulWidget {
  const CommentBarTop({super.key, required this.comment});
  final List<Comment> comment;

  @override
  State<CommentBarTop> createState() => _CommentBarTopState();
}

class _CommentBarTopState extends State<CommentBarTop> {
  void callback(bool value, String newcomment) {
    if (value) {
      debugPrint("Comment added");
      Provider.of<PostviewerStatus>(context, listen: false)
          .doupdatecommentlist();
    } else {
      debugPrint("Comment not added");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.nicegrey,
      child: Column(
        children: [
          Row(
            children: [
              FloatingActionButton.extended(
                heroTag: null,
                onPressed: () {
                  if (Provider.of<GlobalStatus>(context, listen: false)
                      .isLoggedin) {
                    showDialog(
                        context: context,
                        builder: (context) =>
                            NewCommentView(callback: callback));
                  } else {
                    showDialog(
                        context: context,
                        builder: ((context) {
                          return const Login();
                        }));
                  }
                },
                hoverColor: Colors.blue,
                backgroundColor: Colors.blue.withAlpha((0.3 * 255).toInt()),
                label: AutoSizeText(
                  AppLocalizations.of(context)!.writecomment,
                  style: const TextStyle(color: Colors.white),
                ),
                icon: Column(
                  children: [
                    const Icon(Icons.comment, color: Colors.white),
                    Text("${widget.comment.length}",
                        style: const TextStyle(color: Colors.white)),
                  ],
                ),
                shape: ShapeBorder.lerp(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    0.5),
              ),
              //Sort Button
              const SizedBox(width: 8),
              FloatingActionButton.extended(
                heroTag: null,
                onPressed: () {
                  Provider.of<CommentBarStatus>(context, listen: false)
                      .toggleCommentFold();
                },
                hoverColor: Colors.blue,
                backgroundColor: Colors.blue.withAlpha((0.3 * 255).toInt()),
                label: const Text("", style: TextStyle(color: Colors.white)),
                icon: const Icon(Icons.devices_fold_outlined,
                    color: Colors.white),
                shape: ShapeBorder.lerp(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    0.5),
              ),
            ],
          )
        ],
      ),
    );
  }
}

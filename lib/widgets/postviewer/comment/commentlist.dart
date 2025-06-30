import 'package:fr0gsite/datatypes/comment.dart';
import 'package:fr0gsite/datatypes/commentbarstatus.dart';
import 'package:fr0gsite/widgets/postviewer/comment/commentbartop.dart';
import 'package:fr0gsite/widgets/postviewer/comment/commentwidget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../config.dart';

class CommentList extends StatefulWidget {
  final List<Comment> comments;

  const CommentList({super.key, required this.comments});

  @override
  CommentListState createState() => CommentListState();
}

class CommentListState extends State<CommentList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<CommentBarStatus>(
              create: (context) => CommentBarStatus()),
        ],
        builder: (context, child) {
          return Column(children: [
            CommentBarTop(comment: widget.comments),
            Expanded(
              child: widget.comments.isNotEmpty ? buildCommentTree() : empty(),
            )
          ]);
        });
  }

  Widget buildCommentTree() {
    List<Comment> mainComments = widget.comments
        .where((comment) => comment.parentCommentId == 0)
        .toList();

    return ListView.builder(
      itemCount: mainComments.length,
      itemBuilder: (context, index) {
        var mainComment = mainComments[index];
        // Filter Sub-Kommentare basierend auf dem Hauptkommentar
        var subComments = widget.comments
            .where(
                (comment) => comment.parentCommentId == mainComment.commentId)
            .toList();
        // Detele SubComment with 0 as id.
        subComments.removeWhere((element) => element.commentId == 0);
        return CommentWidget(
          comment: mainComment,
          subComments: subComments,
          comments: widget.comments,
          level: 1,
        );
      },
    );
  }

  Widget empty() {
    return Container(
      color: AppColor.nicegrey,
      height: double.infinity,
      width: double.infinity,
      child: Center(
          child: Column(
        children: [
          Lottie.asset('assets/lottie/empty.json', height: 200, width: 200),
          Text(AppLocalizations.of(context)!.nocomments),
        ],
      )),
    );
  }
}

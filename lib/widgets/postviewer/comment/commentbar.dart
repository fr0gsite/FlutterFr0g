import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/comment.dart';
import 'package:fr0gsite/widgets/postviewer/comment/commentlist.dart';
import 'package:fr0gsite/widgets/postviewer/comment/taglist.dart';
import 'package:fr0gsite/widgets/postviewer/comment/uploadinfo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';

import '../../../config.dart';
import '../../../datatypes/postviewerstatus.dart';

class CommentBar extends StatefulWidget {
  const CommentBar({super.key});

  @override
  State<CommentBar> createState() => _CommentBarState();
}

class _CommentBarState extends State<CommentBar> {
  late Future loadcomments;
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          isVisible = true;
        });
      }
    });
  }

  List<Comment> commentlist = [];

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [
      Tab(
        icon: const Icon(
          Icons.comment,
          color: Colors.white,
        ),
        text: AppLocalizations.of(context)!.comments,
      ),
      Tab(
        icon: const Icon(
          Icons.tag,
          color: Colors.white,
        ),
        text: AppLocalizations.of(context)!.tags,
      ),
      Tab(
        icon: const Icon(
          Icons.info,
          color: Colors.white,
        ),
        text: AppLocalizations.of(context)!.info,
      ),
    ];

    return Consumer<PostviewerStatus>(
      builder: (context, postviewerstatus, child) {
        loadcomments = fetchComments(
            postviewerstatus.getcurrentupload().uploadid.toString());
        return FutureBuilder(
          future: loadcomments,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              postviewerstatus.setcommentlist(snapshot.data as List<Comment>);
            }
            if (postviewerstatus.updatecommentbar) {
              loadcomments = fetchComments(
                  postviewerstatus.getcurrentupload().uploadid.toString());
            }

            List<Widget> tabBarViews = [
              CommentList(comments: postviewerstatus.commentlist),
              Taglist(uploadid: postviewerstatus.currentupload.uploadid),
              UploadInfo(upload: postviewerstatus.currentupload),
            ];

            return Visibility(
              visible: isVisible,
              maintainState: true,
              replacement: Container(color: Colors.black),
              child: DefaultTabController(
                length: tabs.length,
                child: Container(
                  color: AppColor.nicegrey,
                  child: Column(
                    children: [
                      TabBar(
                        labelColor: Colors.white,
                        dividerColor: Colors.transparent,
                        unselectedLabelColor: Colors.grey[400],
                        indicator: gloabltabindicator,
                        indicatorSize: TabBarIndicatorSize.tab,
                        unselectedLabelStyle: const TextStyle(fontSize: 15),
                        labelStyle: const TextStyle(fontSize: 20),
                        tabs: tabs,
                      ),
                      Expanded(
                        child: TabBarView(
                          children: tabBarViews,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

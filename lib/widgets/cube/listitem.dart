import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/gridstatus.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:fr0gsite/datatypes/uploadordertemplate.dart';
import 'package:fr0gsite/ipfsactions.dart';
import 'package:fr0gsite/widgets/login/login.dart';
import 'package:provider/provider.dart';

class ListItem extends StatefulWidget {
  const ListItem({super.key, required this.upload});

  final Upload upload;

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  late Future _imageFuture;
  Uint8List _imageBytes = Uint8List.fromList([]);

  @override
  void initState() {
    super.initState();
    _imageFuture = _fetchImage();
  }

  Future _fetchImage() async {
    _imageBytes = await IPFSActions.fetchipfsdata(context, widget.upload.thumbipfshash);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        try {
          UploadOrderTemplate uploadorder =
              Provider.of<GridStatus>(context, listen: false).getSerach();
          uploadorder.setcurrentuploadid(widget.upload.uploadid);
          Navigator.pushNamed(context, '/${AppConfig.postviewerurlpath}/${widget.upload.uploadid}',
              arguments: uploadorder);
        } catch (e) {
          Navigator.pushNamed(context, '/${AppConfig.postviewerurlpath}/${widget.upload.uploadid}',
              arguments: widget.upload);
        }
      },
      child: FutureBuilder(
        future: _imageFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.nicegrey,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26, offset: Offset(0, 2), blurRadius: 4),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(
                      _imageBytes,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.upload.uploadtext,
                          style: const TextStyle(color: Colors.white),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _voteButton(
                                Icons.add_circle_outline_sharp,
                                _onUpVote,
                                widget.upload.buttonupliked,
                                widget.upload.up,
                                Colors.green,
                                Colors.orange),
                            const SizedBox(width: 8),
                            _voteButton(
                                Icons.do_not_disturb_on_outlined,
                                _onDownVote,
                                widget.upload.buttondownliked,
                                widget.upload.down,
                                Colors.red,
                                Colors.orange),
                            const SizedBox(width: 8),
                            const Icon(Icons.comment,
                                color: Colors.white, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              widget.upload.numofcomments.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox(
              height: 120,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _voteButton(
      IconData icon,
      Future<bool> Function(bool) onTap,
      bool isLiked,
      int likeCount,
      Color primary,
      Color secondary) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.niceblack,
        borderRadius: BorderRadius.circular(50),
      ),
      child: LikeButton(
        size: 30,
        circleColor: CircleColor(start: primary, end: primary),
        bubblesColor:
            BubblesColor(dotPrimaryColor: primary, dotSecondaryColor: secondary),
        isLiked: isLiked,
        likeBuilder: (bool isLiked) {
          return Icon(icon,
              color: isLiked ? primary : Colors.white, size: 30);
        },
        likeCount: likeCount,
        countBuilder: (int? count, bool isLiked, String text) {
          var color = isLiked ? primary : Colors.white;
          if (count == -1) {
            return Container();
          }
          return Text(text, style: TextStyle(color: color, fontSize: 14));
        },
        onTap: onTap,
      ),
    );
  }

  Future<bool> _onUpVote(bool value) async {
    final globalStatus = Provider.of<GlobalStatus>(context, listen: false);
    if (!globalStatus.isLoggedin) {
      showDialog(
          context: context,
          builder: (context) {
            return const Login();
          });
      return false;
    }
    if (widget.upload.buttonupliked || widget.upload.buttondownliked) {
      return false;
    }
    final chain = Chainactions()
      ..setusernameandpermission(globalStatus.username, globalStatus.permission);
    final result = await chain.voteupload(widget.upload.uploadid, 1);
    if (!mounted) return false;
    if (result) {
      setState(() {
        widget.upload.upvote();
        widget.upload.buttonupliked = true;
      });
      globalStatus.updateaccountinfo();
      globalStatus.updateuserconfig();
    }
    return result;
  }

  Future<bool> _onDownVote(bool value) async {
    final globalStatus = Provider.of<GlobalStatus>(context, listen: false);
    if (!globalStatus.isLoggedin) {
      showDialog(
          context: context,
          builder: (context) {
            return const Login();
          });
      return false;
    }
    if (widget.upload.buttonupliked || widget.upload.buttondownliked) {
      return false;
    }
    final chain = Chainactions()
      ..setusernameandpermission(globalStatus.username, globalStatus.permission);
    final result = await chain.voteupload(widget.upload.uploadid, 0);
    if (!mounted) return false;
    if (result) {
      setState(() {
        widget.upload.downvote();
        widget.upload.buttondownliked = true;
      });
      globalStatus.updateaccountinfo();
      globalStatus.updateuserconfig();
    }
    return result;
  }
}


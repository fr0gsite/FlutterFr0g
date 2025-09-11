import 'dart:convert';
import 'package:blur/blur.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/postviewerstatus.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:fr0gsite/datatypes/networkstatus.dart';
import 'package:fr0gsite/datatypes/ipfsnode.dart';
import 'package:fr0gsite/ipfsactions.dart';
import 'package:fr0gsite/widgets/infoscreens/loadingpleasewaitscreen.dart';
import 'package:fr0gsite/widgets/infoscreens/sorryscreen.dart';
import 'package:fr0gsite/widgets/postviewer/overlaywidgetvideo.dart';
import 'package:flutter/foundation.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class SwipeItem extends StatefulWidget {
  final Upload upload;

  const SwipeItem({super.key, required this.upload});

  @override
  State<SwipeItem> createState() => _SwipeItemState();
}

class _SwipeItemState extends State<SwipeItem> {
  Future initvideoplayer = Future.value(false);
  late VideoPlayerController videocontroller;

  @override
  void initState() {
    super.initState();
    videocontroller = VideoPlayerController.network('');
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      color: AppColor.nicegrey,
      child: Stack(children: [
        Consumer<PostviewerStatus>(builder: (context, postviewerstatus, child) {
          return FutureBuilder(
              future: fetchcontentdata(),
              builder: (context, snapshotmetadata) {
                if (snapshotmetadata.connectionState == ConnectionState.done) {
                  if (snapshotmetadata.data.toString() == "hasdata") {

                    if (widget.upload.uploadipfshashfiletyp == "mp4") {
                      if (AppConfig.plattformwithvideosupport.contains(Provider.of<GlobalStatus>(context, listen: false).platform)) {
                        debugPrint("Plattform support video");
                      } else {
                        debugPrint("Plattform not support video");
                        return Sorryscreen(additionalinfo: AppLocalizations.of(context)!.platformnotsupportvideo);
                      }

                      if (!videocontroller.value.isInitialized) {
                        initvideoplayer = initializePlayer();
                      }

                      return FutureBuilder(
                          future: initvideoplayer,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                                    return videocontroller.value.isInitialized
                                        ? Stack(
                                            children: [
                                              Center(
                                                child: AspectRatio(
                                                  aspectRatio: videocontroller.value.aspectRatio,
                                                  child: VideoPlayer(videocontroller),
                                                ),
                                              ),
                                              OverlayWidgetVideo(controller:videocontroller,)
                                            ],
                                          )
                                        : const Center(
                                            child: CircularProgressIndicator(
                                            color: Colors.blueAccent,
                                          ),
                                        );
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator(
                                color: Colors.blueAccent,
                              ),
                            );}
                          },
                        );
                    }
                    Uint8List data = Provider.of<PostviewerStatus>(context, listen: false).getcurrentupload().data;
                    return Stack(
                      children: [
                        Blur(
                            blur: 15,
                            blurColor: Colors.black,
                            child: Image.memory(
                              data,
                              fit: BoxFit.fill,
                              width: double.infinity,
                              height: double.infinity,
                            )),
                        Center(
                            child: Image.memory(
                          data,
                        ))
                      ],
                    );
                    } else {
                    return FutureBuilder(
                      future: Future.delayed(const Duration(seconds: 1)),
                      builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Loadingpleasewaitscreen(
                          thumbhash: widget.upload.thumbipfshash);
                      } else {
                        return Container(color: AppColor.nicegrey);
                      }
                      },
                    );
                    }
                  } else {
                    return FutureBuilder(
                    future: Future.delayed(const Duration(seconds: 1)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                      return Loadingpleasewaitscreen(
                        thumbhash: widget.upload.thumbipfshash);
                      } else {
                      return Container(color: AppColor.nicegrey);
                      }
                    },
                    );
                  }
              });
        }),
      ]),
    );
  }

  @override
  void dispose() {
    debugPrint("SwipeItem dispose");
    videocontroller.dispose();
    super.dispose();
  }

  Future<Object> fetchcontentdata() async {
    Upload currentupload =
        Provider.of<PostviewerStatus>(context, listen: false).getcurrentupload();
    if (currentupload.uploadid == widget.upload.uploadid) {
      if (widget.upload.uploadipfshashfiletyp != "mp4" &&
          !currentupload.havedata()) {
        Uint8List response =
            await IPFSActions.fetchipfsdata(context, currentupload.uploadipfshash);
        if (mounted) {
          Provider.of<PostviewerStatus>(context, listen: false)
              .setdata(response, currentupload.uploadid);
        }
      }
      return "hasdata";
    } else {
      return "Not current upload";
    }
  }

  Future<bool> initializePlayer() async {
    debugPrint("initializePlayer function");
    if (videocontroller.value.isInitialized) {
      debugPrint("initializePlayer: Already initialized");
      return true; // Skip if already initialized
    }

    try {
      IPFSNode node =
          Provider.of<NetworkStatus>(context, listen: false).chooseIPFSNode();
      final url =
          "${node.protokoll}://${node.address}:${node.port}${node.path}${widget.upload.uploadipfshash}";

      videocontroller = VideoPlayerController.networkUrl(Uri.parse(url));

      await videocontroller.setLooping(true);
      await videocontroller.initialize();
      if (mounted) {
        await videocontroller.setVolume(
            Provider.of<PostviewerStatus>(context, listen: false).soundvolume);
        if (Provider.of<PostviewerStatus>(context, listen: false).isPlaying) {
          await videocontroller.play();
        }
      }
      return true;
    } catch (e) {
      debugPrint("initializePlayer Error: $e");
      return false;
    }
  }
}

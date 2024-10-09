import 'dart:convert';
import 'package:blur/blur.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/postviewerstatus.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:fr0gsite/ipfsactions.dart';
import 'package:fr0gsite/widgets/infoscreens/loadingpleasewaitscreen.dart';
import 'package:fr0gsite/widgets/infoscreens/sorryscreen.dart';
import 'package:fr0gsite/widgets/postviewer/overlaywidgetvideo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  @override
  void initState() {
    super.initState();
  }

  var videocontroller = VideoPlayerController.network('');
  Future initvideoplayer = Future.value(false);
  final videoStateNotifier = ValueNotifier<bool>(false);

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
                    Uint8List data =
                        Provider.of<PostviewerStatus>(context, listen: false)
                            .getcurrentupload()
                            .data;

                    if (widget.upload.uploadipfshashfiletyp == "mp4") {
                      if (AppConfig.plattformwithvideosupport.contains(
                          Provider.of<GlobalStatus>(context, listen: false)
                              .platform)) {
                        debugPrint("Plattform support video");
                      } else {
                        debugPrint("Plattform not support video");
                        return Sorryscreen(
                            additionalinfo: AppLocalizations.of(context)!
                                .platformnotsupportvideo);
                      }

                      if (!videocontroller.value.isInitialized) {
                        initvideoplayer = initializePlayer(data);
                      }

                      return FutureBuilder(
                          future: initvideoplayer,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return ValueListenableBuilder<bool>(
                                  valueListenable: videoStateNotifier,
                                  builder: (context, isPlaying, child) {
                                    return videocontroller.value.isInitialized
                                        ? Stack(
                                            children: [
                                              Center(
                                                child: AspectRatio(
                                                  aspectRatio: videocontroller
                                                      .value.aspectRatio,
                                                  child: VideoPlayer(
                                                      videocontroller),
                                                ),
                                              ),
                                              OverlayWidgetVideo(
                                                controller: videocontroller,
                                              )
                                            ],
                                          )
                                        : const Center(
                                            child: CircularProgressIndicator(
                                            color: Colors.blueAccent,
                                          ));
                                  });
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator(
                                color: Colors.blueAccent,
                              ));
                            }
                          });
                    }
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
                    return const Loadingpleasewaitscreen();
                  }
                } else {
                  return const Loadingpleasewaitscreen();
                }
              });
        }),
      ]),
    );
  }

  @override
  void dispose() {
    if (widget.upload.uploadipfshashfiletyp == "mp4") {
      videocontroller.dispose();
    }
    super.dispose();
  }

  //Stop video when dialog is open
  @override
  void deactivate() {
    if (widget.upload.uploadipfshashfiletyp == "mp4") {
      videocontroller.pause();
    }
    super.deactivate();
  }

  Future<Object> fetchcontentdata() async {
    Upload currentupload = Provider.of<PostviewerStatus>(context, listen: false)
        .getcurrentupload();
    if (currentupload.uploadid == widget.upload.uploadid) {
      if (!currentupload.havedata()) {
        Uint8List response = await IPFSActions.fetchipfsdata(
            context, currentupload.uploadipfshash);
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

  Future<bool> initializePlayer(data) async {
    debugPrint("initializePlayer");

    try {
      videocontroller = VideoPlayerController.networkUrl(
          Uri.parse('data:video/mp4;base64,${base64Encode(data)}'));

      await videocontroller.setLooping(true);
      await videocontroller.initialize();
      try {
        if (mounted) {
          await videocontroller.setVolume(
              Provider.of<PostviewerStatus>(context, listen: false)
                  .soundvolume);
        }
        await videocontroller.play();
      } catch (e) {
        debugPrint("Video Play Error: $e");
      }
      debugPrint("Videoplayer initialized");
      videoStateNotifier.value = true;
      return true;
    } catch (e) {
      debugPrint("initializePlayer Error: $e");
      return false;
    }
  }
}

import 'dart:async';
import 'dart:ui';

import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/favoriteupload.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:fr0gsite/datatypes/uploadordertemplate.dart';
import 'package:fr0gsite/widgets/postviewer/postvieweranimation.dart';
import 'package:fr0gsite/widgets/postviewer/tagbarview.dart';
import 'package:fr0gsite/widgets/postviewer/overlaywidgetbasic.dart';
import 'package:fr0gsite/widgets/postviewer/comment/commentbar.dart';
import 'package:fr0gsite/widgets/postviewer/postviewertopbar.dart';
import 'package:fr0gsite/widgets/postviewer/swipeitem.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as html;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../chainactions/chainactions.dart';
import '../../datatypes/postviewerstatus.dart';
import 'postviewerbottombar.dart';

class Postviewer extends StatefulWidget {
  final String? id;
  const Postviewer({super.key, this.id});

  @override
  PostviewerState createState() => PostviewerState();
}

class PostviewerState extends State<Postviewer> {
  PageController pagecontroller = PageController();
  List<SwipeItem> swipeItemList = [];
  bool fristrun = true;

  @override
  void initState() {
    super.initState();
    debugPrint("Init Postviewer");
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKeyEvent: (value) {
        if (value.logicalKey == LogicalKeyboardKey.arrowUp) {
          next('previous');
        }
        if (value.logicalKey == LogicalKeyboardKey.arrowDown) {
          next('next');
        }
        if (value.logicalKey == LogicalKeyboardKey.keyF) {
          //TODO: Favorite Upload or Unfavorite
        }
        if (value.logicalKey == LogicalKeyboardKey.keyU ||
            value.logicalKey == LogicalKeyboardKey.add ||
            value.logicalKey == LogicalKeyboardKey.numpadAdd) {
          //TODO: Upvote
        }
        if (value.logicalKey == LogicalKeyboardKey.keyD ||
            value.logicalKey == LogicalKeyboardKey.minus ||
            value.logicalKey == LogicalKeyboardKey.numpadSubtract) {
          //TODO: Downvote
        }
        if (value.logicalKey == LogicalKeyboardKey.keyC) {
          Provider.of<GlobalStatus>(context, listen: false).toggleexpandedpostviewer();
        }
        if (value.logicalKey == LogicalKeyboardKey.keyT) {
          Provider.of<GlobalStatus>(context, listen: false).toggleexpandedtagview();
        }
      },
      child: SafeArea(
        child: Material(
          child: FutureBuilder(
            future: fetchMetadata(),
            builder: (context, snapshotmetadata) {
              if (snapshotmetadata.connectionState == ConnectionState.done) {
                return Row(
                  children: [
                    Consumer<GlobalStatus>(
                        builder: (context, userstatus, child) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: userstatus.expandedpostviewer
                            ? MediaQuery.of(context).size.width * 1 / 3
                            : 0,
                        child: userstatus.expandedpostviewer
                            ? const CommentBar()
                            : Container(
                                color: AppColor.niceblack,
                              ),
                      );
                    }),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          const SizedBox(height: 60, child: PostViewerTopBar()),
                          Expanded(
                              flex: 10,
                              child: Stack(
                                children: [
                                  Center(
                                    child: ScrollConfiguration(
                                      behavior: AppScrollBehavior(),
                                      child: PageView.builder(
                                        itemBuilder: (context, index) {
                                          debugPrint("itemBuilder index: $index");
                                          return swipeItemList[index];},
                                        itemCount:Provider.of<PostviewerStatus>(context,listen: false).uploadlist.length,
                                        controller: pagecontroller,
                                        scrollDirection: Axis.vertical,
                                        onPageChanged: (value) => onPageChanged(
                                            value), 
                                      ),
                                    ),
                                  ),
                                  const Align(
                                    alignment: Alignment.centerRight,
                                    child: PostViewerAnimation(),
                                  ),
                                  Positioned(
                                      bottom: 10,
                                      right: 10,
                                      child: reportButton(context)),
                                  Positioned(
                                    right: 10,
                                    child: shareButton(context),
                                  ),
                                  Positioned(
                                    left: 10,
                                    bottom: 10,
                                    child: expandButton(() {
                                      double currentwidth =MediaQuery.of(context).size.width;                      
                                      if (currentwidth < 1200) {
                                        Provider.of<GlobalStatus>(context,
                                                listen: false)
                                            .expandedpostviewer = false;
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          useSafeArea: true,
                                          builder: (context) {
                                            return SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.80,
                                              child: const CommentBar(),
                                            );
                                          },
                                        );
                                      } else {
                                        Provider.of<GlobalStatus>(context,listen: false).toggleexpandedpostviewer();
                                      }
                                    },
                                        Provider.of<PostviewerStatus>(context,listen: true).currentupload.numofcomments,context),
                                  ),
                                  Positioned(
                                    left: 50,
                                    bottom: 10,
                                    child: showTagsButton(() {
                                      Provider.of<GlobalStatus>(context,listen: false).toggleexpandedtagview();
                                    },
                                        Provider.of<PostviewerStatus>(context,listen: true).currentupload.numoftags,context),
                                  ),
                                ],
                              )),
                          Consumer<GlobalStatus>(
                              builder: (context, userstatus, child) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: userstatus.expandedtagview ? 60 : 0,
                              child: userstatus.expandedtagview
                                  ? const TagBarView() : Container(
                                      color: AppColor.niceblack,
                                    ),
                            );
                          }),
                          const SizedBox(
                              height: 60, child: PostViewerBottomBar()),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                //return const Loadingpleasewaitscreen();
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }


  Future<Object> fetchMetadata() async {
    if (fristrun) {
      Provider.of<PostviewerStatus>(context, listen: false).clearuploadlist();
      List<Upload> tempUploads = [];
      late Upload currentupload;
      try {
        UploadOrderTemplate uploadorder = ModalRoute.of(context)!.settings.arguments as UploadOrderTemplate;
        tempUploads = uploadorder.currentviewuploadlist;
        currentupload = uploadorder.currentviewuploadlist.firstWhere((element) => element.uploadid == int.parse(widget.id!));
      } catch (e) {
        debugPrint("Postviewer: No UploadOrderTemplate");
        //No UploadOrderTemplate. Fetch Popular Uploads
        tempUploads = await Chainactions().getpopularuploads();
        currentupload = await Chainactions().getupload(widget.id!);
        tempUploads.insert(tempUploads.length ~/ 2, currentupload);
      }
      //Check if uploads are favorites of user
      if (mounted) {
        if (Provider.of<GlobalStatus>(context, listen: false).isLoggedin) {
          debugPrint("Check if upload is favorites of user");
          List<FavoriteUpload> favoriteuploads =
              await Provider.of<GlobalStatus>(context, listen: false)
                  .getfavoriteuploads();
          for (var upload in tempUploads) {
            for (var favorite in favoriteuploads) {
              if (BigInt.parse(upload.uploadid.toString()) ==
                  favorite.uploadid) {
                upload.buttonfavoriteliked = true;
              }
            }
          }
        }
      }
      if (mounted) {
        debugPrint("Postviewer: Set Uploads");
        Provider.of<PostviewerStatus>(context, listen: false).adduploads(tempUploads);

        debugPrint("Postviewer: Add siwpeitems to uploadlist");
        Provider.of<PostviewerStatus>(context, listen: false).uploadlist.forEach((element) {
          swipeItemList.add(SwipeItem(
            upload: element,
          ));
        });

        debugPrint("Postviewer: Set current upload");
        Provider.of<PostviewerStatus>(context, listen: false).setcurrentupload(currentupload);
      }

      int indexofcurrentuploadinswiper = swipeItemList.indexWhere(
          (element) => element.upload.uploadid == currentupload.uploadid);

      debugPrint("Index of current upload in swiper: $indexofcurrentuploadinswiper");
      pagecontroller = PageController(initialPage: indexofcurrentuploadinswiper);

      fristrun = false;
    }
    return 0;
  }

  void next(String value) {
    debugPrint("next $value");
    switch (value) {
      case 'next':
        pagecontroller.nextPage(
            duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
        break;
      case 'previous':
        pagecontroller.previousPage(
            duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
        break;
    }
  }

  void onPageChanged(int value) {

    debugPrint("onPageChanged: $value");

    Provider.of<PostviewerStatus>(context, listen: false).setcurrentupload(swipeItemList[value].upload);

    preloadVideos(value);

    // Update the URL for web
    if (kIsWeb) {
      html.window.history.pushState(null, "Postviewer",
          "/postviewer/${swipeItemList[value].upload.uploadid}");
    }
  }

  void preloadVideos(int index) {
    // Previous Previous Video
    if (index > 0) {
      swipeItemList[index - 1].upload.loadContent(context);
    }

    // Next Video
    if (index < swipeItemList.length - 1) {
      swipeItemList[index + 1].upload.loadContent(context);
    }

    // Next Next Video
    if (index < swipeItemList.length - 2) {
      swipeItemList[index + 2].upload.loadContent(context);
    }
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/favoriteupload.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:fr0gsite/widgets/login/login.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';
import '../../datatypes/postviewerstatus.dart';

class PostViewerBottomBar extends StatefulWidget {
  const PostViewerBottomBar({super.key});

  @override
  State<PostViewerBottomBar> createState() => _PostViewerBottomParState();
}

class _PostViewerBottomParState extends State<PostViewerBottomBar> {
  @override
  void initState() {
    super.initState();
  }

  double up = 0.0;
  double down = 0.0;
  double favorite = 0.0;

  @override
  Widget build(BuildContext context) {
    return Consumer<PostviewerStatus>(
        builder: (context, postviewerstatus, child) {
      Upload currentupload = postviewerstatus.getcurrentupload();
      up = double.parse(currentupload.up.toString());
      down = double.parse(currentupload.down.toString());
      double favorite = double.parse(currentupload.numoffavorites.toString());
      double percentageofupdown = percentageof(up, up + down);

      return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        double availableWidth = constraints.maxWidth;
        double indicatorWidth = availableWidth * 0.5;
        indicatorWidth = indicatorWidth.clamp(80, 400);

        return Container(
          color: AppColor.nicegrey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              constraints.maxWidth > 500
                  ? LinearPercentIndicator(
                      width: indicatorWidth,
                      lineHeight: 35.0,
                      barRadius: const Radius.elliptical(5, 5),
                      percent: percentageof(up, up + down).toDouble(),
                      center: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(up.round().toString()),
                          Text("${(percentageofupdown * 100).round()}%"),
                          Text(down.round().toString())
                        ],
                      ),
                      progressColor: Colors.green,
                      backgroundColor: Colors.red,
                    )
                  : Container(),
              viewerbutton(
                  Icons.add_circle_outline_sharp,
                  "",
                  buttonpressup,
                  currentupload.buttonupliked,
                  up.round(),
                  Colors.green,
                  Colors.orange),
              viewerbutton(
                  Icons.do_not_disturb_on_outlined,
                  "",
                  buttonpressdown,
                  currentupload.buttondownliked,
                  down.round(),
                  Colors.red,
                  Colors.orange),
              viewerbutton(
                  Icons.favorite,
                  currentupload.buttonfavoriteliked
                      ? AppLocalizations.of(context)!.discard
                      : AppLocalizations.of(context)!.favoritize,
                  buttonpressfavorite,
                  currentupload.buttonfavoriteliked,
                  favorite.round(),
                  Colors.yellow,
                  Colors.orange),
            ],
          ),
        );
      });
    });
  }

  Widget smallupdownoverview(int up, int down) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(up.toString()),
        Text(down.toString()),
      ],
    );
  }

  Widget viewerbutton(IconData icon, String tooltip, function, bool isliked,
      int likecount, Color primary, Color secondary) {
    return Tooltip(
      message: tooltip,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.nicegrey,
          borderRadius: BorderRadius.circular(50),
        ),
        child: LikeButton(
          size: iconsize,
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
              size: iconsize,
            );
          },
          likeCount: likecount,
          countBuilder: (int? count, bool isLiked, String text) {
            var color = isLiked ? primary : Colors.white;
            Widget result;
            if (count == -1) {
              return Container();
            }
            result = Text(
              text,
              style: TextStyle(color: color, fontSize: textsize),
            );
      
            return result;
          },
          onTap: function,
        ),
      ),
    );
  }

  double percentageof(double num, double total) {
    if (total == 0) return 0.5;
    return num / total;
  }

  Future<bool> buttonpressfavorite(bool value) async {
    final globalStatus = Provider.of<GlobalStatus>(context, listen: false);
    final postviewerStatus =
        Provider.of<PostviewerStatus>(context, listen: false);

    if (globalStatus.isLoggedin) {
      bool toggle =
          postviewerStatus.getcurrentupload().buttonfavoriteliked;

      final chain = Chainactions()
        ..setusernameandpermission(
            globalStatus.username, globalStatus.permission);

      if (!toggle) {
        final result = await chain
            .addfavoriteupload(postviewerStatus.getcurrentupload().uploadid.toString());
        if (!mounted) return toggle;
        if (result) {
          debugPrint("addfavorite : $result");

          final currentuploadid =
              postviewerStatus.getcurrentupload().uploadid;
          final now = DateTime.now();
          final newfavorite = FavoriteUpload(
              uploadid: BigInt.parse(currentuploadid.toString()),
              creationtime: now);
          globalStatus.addfavoriteupload(newfavorite);

          postviewerStatus.currentupload.buttonfavoriteliked = true;
          postviewerStatus.currentupload.numoffavorites += 1;

          setState(() {
            favorite = favorite + 1;
          });
        }
      } else {
        final result = await chain.deletefavoriteupload(
            postviewerStatus.getcurrentupload().uploadid.toString());
        if (!mounted) return toggle;
        if (result) {
          debugPrint("deletefavorite : $result");
          final currentuploadid =
              postviewerStatus.getcurrentupload().uploadid;
          final oldfavorite = FavoriteUpload(
              uploadid: BigInt.parse(currentuploadid.toString()),
              creationtime: DateTime.now());
          globalStatus.delfavoriteupload(oldfavorite);

          postviewerStatus.currentupload.buttonfavoriteliked = false;
          postviewerStatus.currentupload.numoffavorites -= 1;

          setState(() {
            favorite = favorite - 1;
          });
        }
      }
      return toggle;
    } else {
      showDialog(
          context: context,
          builder: ((context) {
            return const Login();
          }));
      return false;
    }
  }

  Future<bool> buttonpressup(bool value) async {
    debugPrint("up");
    final globalStatus = Provider.of<GlobalStatus>(context, listen: false);
    final postviewerStatus =
        Provider.of<PostviewerStatus>(context, listen: false);

    if (globalStatus.isLoggedin) {
      bool buttonupliked = postviewerStatus.getcurrentupload().buttonupliked;
      bool buttondownliked =
          postviewerStatus.getcurrentupload().buttondownliked;

      if (!buttonupliked && !buttondownliked) {
        int currentuploadid = postviewerStatus.getcurrentupload().uploadid;

        final chain = Chainactions()
          ..setusernameandpermission(
              globalStatus.username, globalStatus.permission);

        final result = await chain
            .voteupload(postviewerStatus.getcurrentupload().uploadid, 1);

        if (!mounted) return false;

        setState(() {
          up = up + 1;
        });

        if (result) {
          postviewerStatus.uploadlist
              .firstWhere((element) => element.uploadid == currentuploadid)
              .upvote();
          globalStatus.updateaccountinfo();
          globalStatus.updateuserconfig();
        }

        postviewerStatus.currentupload.buttonupliked = true;
      } else {
        return false;
      }
    } else {
      showDialog(
          context: context,
          builder: ((context) {
            return const Login();
          }));
      return false;
    }

    return true;
  }

  Future<bool> buttonpressdown(bool value) async {
    debugPrint("down");
    final globalStatus = Provider.of<GlobalStatus>(context, listen: false);
    final postviewerStatus =
        Provider.of<PostviewerStatus>(context, listen: false);

    if (globalStatus.isLoggedin) {
      bool buttonupliked = postviewerStatus.getcurrentupload().buttonupliked;
      bool buttondownliked =
          postviewerStatus.getcurrentupload().buttondownliked;

      if (!buttonupliked && !buttondownliked) {
        int currentuploadid = postviewerStatus.getcurrentupload().uploadid;

        final chain = Chainactions()
          ..setusernameandpermission(
              globalStatus.username, globalStatus.permission);

        final result = await chain
            .voteupload(postviewerStatus.getcurrentupload().uploadid, 0);

        if (!mounted) return false;

        if (result) {
          postviewerStatus.uploadlist
              .firstWhere((element) => element.uploadid == currentuploadid)
              .downvote();
          globalStatus.updateaccountinfo();
          globalStatus.updateuserconfig();
        }

        postviewerStatus.currentupload.buttondownliked = true;
      } else {
        return false;
      }
    } else {
      showDialog(
          context: context,
          builder: ((context) {
            return const Login();
          }));
      return false;
    }
    return true;
  }
}

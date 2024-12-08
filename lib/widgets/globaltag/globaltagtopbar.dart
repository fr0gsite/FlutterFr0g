import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/globaltags.dart';
import 'package:fr0gsite/widgets/login/login.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class GlobalTagTopBar extends StatefulWidget {
  const GlobalTagTopBar({super.key, required this.globaltagid});
  final String globaltagid;

  @override
  State<GlobalTagTopBar> createState() => _GlobalTagTopBarState();
}

class _GlobalTagTopBarState extends State<GlobalTagTopBar> {
  GlobalTags globaltag = GlobalTags.dummy();
  Future<bool>? futuregetglobaltag;

  @override
  void initState() {
    super.initState();
    futuregetglobaltag = getglobaltag();
  }

  @override
  Widget build(BuildContext context) {
    bool hiderating = MediaQuery.of(context).size.width > 800;
    return FutureBuilder(
        future: futuregetglobaltag,
        builder: (context, snapshot) {
          return Row(
            children: [
              backButton(context),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColor.tagcolor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                globaltag.text,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Tooltip(
                            message:
                                AppLocalizations.of(context)!.addtofavorite,
                            child: favoritebutton()),
                      ],
                    ),
                    Wrap(
                      children: [
                        textfortagmetadata(
                            AppLocalizations.of(context)!.favoritedby,
                            globaltag.numoffavorites.toString()),
                        textfortagmetadata(
                            AppLocalizations.of(context)!.uploads,
                            globaltag.numofuploads.toString()),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              hiderating
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //up and down
                            LinearPercentIndicator(
                              width: 350,
                              lineHeight: 40.0,
                              barRadius: const Radius.elliptical(5, 5),
                              percent: int.parse(globaltag.up.toString()) ==
                                          0 &&
                                      int.parse(globaltag.down.toString()) == 0
                                  ? 0.5
                                  : percentageof(globaltag.up,
                                      globaltag.up + globaltag.down),
                              center: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    globaltag.up.toString(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                  Text(
                                    globaltag.down.toString(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ],
                              ),
                              progressColor: Colors.green,
                              backgroundColor: Colors.red,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${AppLocalizations.of(context)!.trendingvalue}: ${globaltag.trend}",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                            Text(
                              "${AppLocalizations.of(context)!.createdon}: ${DateFormat.yMMMMd(Localizations.localeOf(context).toString()).add_jm().format(globaltag.creationtime.add(Duration(seconds: globaltag.creationtime.timeZoneOffset.inSeconds)))}",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              const Spacer(),
              Container(),
            ],
          );
        });
  }

  double percentageof(BigInt num, BigInt total) {
    if (double.parse(total.toString()) == 0) return 0.5;
    return num / total;
  }

  Future<bool> getglobaltag() async {
    globaltag =
        await Chainactions().getglobaltagbyid(widget.globaltagid.toString());
    setState(() {});
    return true;
  }

  Widget backButton(context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.nicegrey,
          borderRadius: BorderRadius.circular(50),
        ),
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.backspace_rounded,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.popAndPushNamed(context, '/home');
            }
          },
        ),
      ),
    );
  }

  Widget favoritebutton() {
    return LikeButton(
      size: 30,
      circleColor: const CircleColor(start: Colors.red, end: Colors.red),
      bubblesColor: const BubblesColor(
        dotPrimaryColor: Colors.red,
        dotSecondaryColor: Colors.red,
      ),
      likeBuilder: (bool isLiked) {
        return Icon(
          Icons.favorite,
          color: isLiked ? Colors.red : Colors.grey,
          size: 30,
        );
      },
      onTap: (bool isLiked) async {
        bool isLoggedin =
            Provider.of<GlobalStatus>(context, listen: false).isLoggedin;
        if (isLoggedin) {
          String username =
              Provider.of<GlobalStatus>(context, listen: false).username;
          String permission =
              Provider.of<GlobalStatus>(context, listen: false).permission;
          Chainactions tempChainactions = Chainactions();
          tempChainactions.setusernameandpermission(username, permission);
          if (isLiked) {
            await tempChainactions
                .deletefavoritetag(widget.globaltagid.toString());
          } else {
            await tempChainactions
                .addfavoritetag(widget.globaltagid.toString());
          }
        } else {
          showDialog(
              context: context,
              builder: ((context) {
                return const Login();
              }));
          return false;
        }
        return !isLiked;
      },
    );
  }

  Widget dislikebutton() {
    return LikeButton(
      size: 30,
      circleColor: const CircleColor(start: Colors.red, end: Colors.red),
      bubblesColor: const BubblesColor(
        dotPrimaryColor: Colors.red,
        dotSecondaryColor: Colors.red,
      ),
      likeBuilder: (bool isLiked) {
        return Icon(
          Icons.heart_broken_outlined,
          color: isLiked ? Colors.red : Colors.grey,
          size: 30,
        );
      },
      onTap: (bool isLiked) async {
        return !isLiked;
      },
    );
  }

  Widget textfortagmetadata(String title, String data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "$title: $data",
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
    );
  }
}

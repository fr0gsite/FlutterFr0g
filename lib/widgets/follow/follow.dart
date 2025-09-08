import 'dart:async';

import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/followstatus.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:fr0gsite/datatypes/usersubscription.dart';
import 'package:fr0gsite/widgets/follow/followcubelist.dart';
import 'package:fr0gsite/widgets/follow/followlistitem.dart';
import 'package:fr0gsite/widgets/infoscreens/pleaselogin.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';

class Follow extends StatefulWidget {
  const Follow({super.key});

  @override
  State<Follow> createState() => _FollowState();
}

class _FollowState extends State<Follow> with TickerProviderStateMixin {
  bool _isExpanded = false;
  double listwidth = 120;
  double maxwidth = 300;
  double minwidth = 120;
  List<Followlistitem> listitems = [];

  bool isPlaying = false;

  late Animation<double> animation =
      Tween<double>(begin: 0.0, end: 1.0).animate(controller);
  late AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );

  Future? getsubscriptions;

  @override
  void initState() {
    super.initState();
    Provider.of<FollowStatus>(context, listen: false).expandedfollowlist =
        false;

    if (Provider.of<FollowStatus>(context, listen: false).pressanimation) {
      Timer(const Duration(seconds: 4), () {
        if (mounted) {
          setState(
            () {
              Provider.of<FollowStatus>(context, listen: false)
                  .switchoffpressanimation();
            },
          );
        }
      });
    }

    if (Provider.of<GlobalStatus>(context, listen: false).isLoggedin) {
      getsubscriptions = getfollower(
          Provider.of<GlobalStatus>(context, listen: false).username);
    } else {
      getsubscriptions = Future.value(true);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    //Test if logged in
    return Container(
      color: AppColor.nicegrey,
      child: Consumer<GlobalStatus>(
        builder: (context, userstatus, child) {
          return Row(children: <Widget>[
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: listwidth,
              child: Consumer<FollowStatus>(
                  builder: (context, followstatus, child) {
                return Stack(
                  children: [
                    Column(
                      children: <Widget>[
                        Container(
                          color: AppColor.nicegrey,
                          child: IconButton(
                            color: AppColor.nicewhite,
                            iconSize: 50,
                            icon: AnimatedIcon(
                              progress: animation,
                              icon: AnimatedIcons.view_list,
                              size: 40,
                            ),
                            onPressed: () {
                              setState(
                                () {
                                  isPlaying = !isPlaying;
                                  isPlaying
                                      ? controller.forward()
                                      : controller.reverse();
                                  _isExpanded = !_isExpanded;
                                  listwidth = _isExpanded ? maxwidth : minwidth;
                                  if (followstatus.expandedfollowlist) {
                                    followstatus.toggleexpandedfollowlist();
                                  } else {
                                    Future.delayed(
                                        const Duration(milliseconds: 300),
                                        () => followstatus
                                            .toggleexpandedfollowlist());
                                  }
                                },
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: AppColor.niceblack,
                            child: FutureBuilder(
                              future: getsubscriptions,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (listitems.isEmpty) {
                                    return Center(
                                        child: Column(
                                      children: [
                                        Lottie.asset('assets/lottie/empty.json',
                                            height: 200, width: 200),
                                        Text(AppLocalizations.of(context)!
                                            .usernotfound),
                                      ],
                                    ));
                                  } else {
                                    return AnimatedList(

                                      key: _listKey,
                                      initialItemCount: listitems.length,
                                      itemBuilder: (context, index, animation) {

                                        return SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(1, 0),
                                            end: const Offset(0, 0),
                                          ).animate(animation),
                                          child: listitems[index],
                                        );
                                      },
                                    );
                                  }
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator(color:Colors.white));
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    followstatus.pressanimation
                        ? Lottie.asset('assets/lottie/press.json',
                            width: 100, height: 100, repeat: false)
                        : Container(),
                  ],
                );
              }),
            ),
            Stack(
              children: [
                Container(color: AppColor.nicewhite, width: 10),
              ],
            ),

            //////////////// RIGHT SIDE //////////////////
            Expanded(
              child: _isExpanded && MediaQuery.of(context).size.width < AppConfig.thresholdValueForMobileLayout
                  ? Container()
                  : !userstatus.isLoggedin
                      ? const Pleaselogin()
                      : FutureBuilder(
                          future: getsubscriptions,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<String> showuserlist = [];
                              for (var item in listitems) {
                                if (item.isselected) {
                                  showuserlist.add(item.username);
                                }
                              }

                              return FollowCubeList(
                                userlist: showuserlist,
                              );
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator(color:Colors.white));
                            }
                          },
                        ),
            )
          ]);
        },
      ),
    );
  }

  void followlistitemcallback(String username, bool isselected, bool delete) {
    debugPrint("followlistitemcallback: $username $isselected");
    debugPrint("active list: ${listitems.toString()}");
    if (delete) {

      debugPrint("active list: delete $delete");
      //Delete from list
      int index =
          listitems.indexWhere((element) => element.username == username);

      debugPrint("active list:  index $index");
      if (index != -1) {

        debugPrint("active list:  _listKey.currentState  ${_listKey.currentState}");
        _listKey.currentState!.removeItem(
          index,
          (context, animation) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0),
              end: const Offset(1, 0),
            ).animate(animation),
          ),
        );
        setState(() {

          debugPrint("active list:  listitems b4  ${listitems.length}");

          listitems.removeAt(index);

          debugPrint("active list:  listitems  ${listitems.length}");
        });
      }
    } else {
      for (var element in listitems) {
        if (element.username == username) {
          setState(() {
            listitems[listitems.indexOf(element)].isselected = isselected;
          });
        }
      }
    }
  }

  Future<bool> getfollower(String pUsername) async {
    List<Usersubscription> subscription =
        await Chainactions().getusersubscriptions(pUsername);
    for (var i = 0; i < subscription.length; i++) {
      listitems.add(Followlistitem(
        username: subscription[i].username,
        callback: followlistitemcallback,
      ));

      // Set the first follower as selected by default
      if (i == 0) {
        listitems[i].isselected = true;
      }
    }

    //List<Future> futures = [];
    //for (var item in listitems) {
    //  futures.add(getuploadforuser(item.username));
    //}
    //
    //List<List<Upload>> uploadList = [];
    //await Future.wait(futures).then((value) {
    //  for (var item in value) {
    //    uploadList.add(item);
    //  }
    //});

    return true;
  }

  Future<List<Upload>> getuploadforuser(String username) async {
    List<Upload> uploads =
        await Chainactions().getuploadsfromuser(username, 60);

    return uploads;
  }
}

import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/followstatus.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Followlistitem extends StatefulWidget {
  Followlistitem({super.key, required this.username, required this.callback});
  final String username;
  bool isselected = false;
  final Function(String username, bool isselected, bool delete) callback;

  @override
  State<Followlistitem> createState() => _FollowlistitemState();
}

class _FollowlistitemState extends State<Followlistitem> {
  Future? getnumoffollowerfuture;
  int follower = 1;
  double textwidth = 60;
  Color textcolor = AppColor.nicewhite;

  @override
  void initState() {
    super.initState();
    getnumoffollowerfuture = getnumoffollower();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FollowStatus>(builder: (context, userstatus, child) {
      return ListTileTheme(
        textColor: widget.isselected ? Colors.green[300] : Colors.white,
        child: ListTile(
          title: Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: userstatus.expandedfollowlist ? 200 : 60),
                child: Text(
                  widget.username,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              FutureBuilder(
                  future: getnumoffollowerfuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        "${AppLocalizations.of(context)!.follower}: ${follower.toString()}",
                        style: const TextStyle(fontSize: 10),
                      );
                    } else {
                      return Text(
                          "${AppLocalizations.of(context)!.follower}: ?",
                          style: const TextStyle(fontSize: 10));
                    }
                  }),
            ]),
            const Spacer(),
            userstatus.expandedfollowlist
                ? Tooltip(
                    message: AppLocalizations.of(context)!.showprofile,
                    child: IconButton(
                        onPressed: () => {
                              Navigator.pushNamed(context,
                                  "/profile/${widget.username}",
                                  arguments: widget.username)
                            },
                        icon: const Icon(
                          Icons.person,
                          color: Colors.white,
                        )),
                  )
                : Container(),
            userstatus.expandedfollowlist
                ? Tooltip(
                    message: AppLocalizations.of(context)!.unfollowuser,
                    child: IconButton(
                        onPressed: () {
                          String username =
                              Provider.of<GlobalStatus>(context, listen: false)
                                  .username;
                          String permission =
                              Provider.of<GlobalStatus>(context, listen: false)
                                  .permission;
                          Chainactions()
                            ..setusernameandpermission(username, permission)
                            ..unfollowuser(widget.username).then(
                              (value) {

                                print("setusernameandpermission ==> $value");
                                setState(() {
                                  if (value) {

                                    print("setusernameandpermission 11 ==> $value");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "${AppLocalizations.of(context)!.unfollowuser}: ${widget.username}"),
                                      ),
                                    );
                                    widget.callback(
                                        widget.username, widget.isselected, true);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            AppLocalizations.of(context)!.error),
                                      ),
                                    );
                                  }
                                });
                              },
                            );
                        },
                        icon: const Icon(
                          Icons.delete_forever,
                          color: Colors.white,
                        )),
                  )
                : Container(),
          ]),
          onTap: () {
            debugPrint("Tapped. $widget.isselected");
            setState(() {
              widget.isselected = !widget.isselected;
              widget.callback(widget.username, widget.isselected, false);
            });
          },
        ),
      );
    });
  }

  Future<bool> getnumoffollower() async {
    Chainactions().getuserconfig(widget.username).then((value) {
      setState(() {
        follower = value.numoffollowers;
      });
    });
    return true;
  }
}

class StatusBall extends StatelessWidget {
  const StatusBall({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15,
      height: 15,
      margin: const EdgeInsets.only(right: 10),
      decoration: const BoxDecoration(
          shape: BoxShape.circle, color: Statuscolor.normal),
    );
  }
}

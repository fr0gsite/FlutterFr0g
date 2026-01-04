import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/followstatus.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:flutter/material.dart';
import 'package:fr0gsite/datatypes/userconfig.dart';
import 'package:provider/provider.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';

// ignore: must_be_immutable
class Followlistitem extends StatefulWidget {
  Followlistitem({super.key, required this.username, required this.callback});
  final String username;
  bool isselected = false;
  final Function(String username, bool isselected, bool delete) callback;

  @override
  State<Followlistitem> createState() => _FollowlistitemState();
}

class _FollowlistitemState extends State<Followlistitem> {
  Future? getuserconfigfuture;
  double textwidth = 60;
  Color textcolor = AppColor.nicewhite;

  @override
  void initState() {
    super.initState();
    getuserconfigfuture = getuserconfig();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FollowStatus>(
      builder: (context, userstatus, child) {
        return ListTileTheme(
          textColor: widget.isselected ? Colors.green[300] : Colors.white,
          child: ListTile(
            title: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: userstatus.expandedfollowlist ? 200 : 60,
                      ),
                      child: Text(
                        widget.username,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    FutureBuilder(
                      future: Chainactions().getuserconfig(widget.username),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Row(
                            children: [
                              Tooltip(
                                message: AppLocalizations.of(context)!.follower,
                                child: const Icon(
                                  Icons.notifications_on_sharp,
                                  color: AppColor.nicewhite,
                                  size: 15,
                                ),
                              ),
                              Text(
                                "${snapshot.data?.numoffollowers}",
                                style: const TextStyle(fontSize: 15),
                              ),
                              const SizedBox(width: 10),
                              Tooltip(
                                message: AppLocalizations.of(context)!.uploads,
                                child: const Icon(
                                  Icons.arrow_circle_up,
                                  color: AppColor.nicewhite,
                                  size: 15,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "${snapshot.data?.numofuploads}",
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          );
                        } else {
                          return Text(
                            AppLocalizations.of(context)!.loading,
                            style: const TextStyle(fontSize: 10),
                          );
                        }
                      },
                    ),
                  ],
                ),
                const Spacer(),
                userstatus.expandedfollowlist
                    ? Tooltip(
                        message: AppLocalizations.of(context)!.showprofile,
                        child: IconButton(
                          onPressed: () => {
                            Navigator.pushNamed(
                              context,
                              "/${AppConfig.profileurlpath}/${widget.username}",
                              arguments: widget.username,
                            ),
                          },
                          icon: const Icon(Icons.person, color: Colors.white),
                        ),
                      )
                    : Container(),
                userstatus.expandedfollowlist
                    ? Tooltip(
                        message: AppLocalizations.of(context)!.unfollowuser,
                        child: IconButton(
                          onPressed: () {
                            String username = Provider.of<GlobalStatus>(
                              context,
                              listen: false,
                            ).username;
                            String permission = Provider.of<GlobalStatus>(
                              context,
                              listen: false,
                            ).permission;
                            Chainactions()
                              ..setusernameandpermission(username, permission)
                              ..unfollowuser(widget.username).then((value) {
                                setState(() {
                                  if (value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "${AppLocalizations.of(context)!.unfollowuser}: ${widget.username}",
                                        ),
                                      ),
                                    );
                                    widget.callback(
                                      widget.username,
                                      widget.isselected,
                                      true,
                                    );
                                    Provider.of<GlobalStatus>(
                                      context,
                                      listen: false,
                                    ).delusersubscription(widget.username);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          AppLocalizations.of(context)!.error,
                                        ),
                                      ),
                                    );
                                  }
                                });

                                //Update local state of subscription
                                Provider.of<GlobalStatus>(
                                  context,
                                  listen: false,
                                ).delusersubscription(widget.username);
                              });
                          },
                          icon: const Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
            onTap: () {
              debugPrint("Tapped. $widget.isselected");
              setState(() {
                widget.isselected = !widget.isselected;
                widget.callback(widget.username, widget.isselected, false);
              });
            },
          ),
        );
      },
    );
  }

  Future<UserConfig> getuserconfig() async {
    return await Chainactions().getuserconfig(widget.username);
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
        shape: BoxShape.circle,
        color: Statuscolor.normal,
      ),
    );
  }
}

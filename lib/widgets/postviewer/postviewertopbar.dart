import 'package:auto_size_text/auto_size_text.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/postviewerstatus.dart';
import 'package:flutter/material.dart';
import 'package:fr0gsite/widgets/login/login.dart';
import 'package:provider/provider.dart';

import '../resources/resourceviewertopbar.dart';

class PostViewerTopBar extends StatefulWidget {
  const PostViewerTopBar({super.key});

  @override
  State<PostViewerTopBar> createState() => _PostViewerTopBarState();
}

class _PostViewerTopBarState extends State<PostViewerTopBar> {
  @override
  void initState() {
    super.initState();
  }

  bool followbutton = false;

  void setfollowbutton(bool value) {
    setState(() {
      followbutton = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostviewerStatus>(
      builder: (context, postviewerstatus, child) {
        return Container(
          color: AppColor.niceblack,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColor.nicegrey.withOpacity(0.5),
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
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  },
                ),
              ),
              TextButton(
                onPressed: () {
                  debugPrint(
                      'Open profile of ${postviewerstatus.getcurrentupload().autor}');

                  Navigator.pushReplacementNamed(context,
                      '/profile/${postviewerstatus.getcurrentupload().autor}',
                      arguments: {
                        'accountname': postviewerstatus.getcurrentupload().autor
                      });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: iconsize,
                    ),
                    AutoSizeText(
                      postviewerstatus.getcurrentupload().autor,
                      maxFontSize: textsize,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () async {
                  if (Provider.of<GlobalStatus>(context, listen: false)
                      .isLoggedin) {
                    String username =
                        Provider.of<GlobalStatus>(context, listen: false)
                            .username;
                    String permission =
                        Provider.of<GlobalStatus>(context, listen: false)
                            .permission;
                    if (followbutton) {
                      Chainactions()
                        ..setusernameandpermission(username, permission)
                        ..unfollowuser(postviewerstatus.currentupload.autor)
                            .then((value) {
                          //If successfull, toggle the button
                          if (value) {
                            setfollowbutton(!followbutton);
                          }
                        });
                    } else {
                      Chainactions()
                        ..setusernameandpermission(username, permission)
                        ..followuser(postviewerstatus.currentupload.autor)
                            .then((value) {
                          //If successfull, toggle the button
                          if (value) {
                            setfollowbutton(!followbutton);
                          }
                        });
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: ((context) {
                        return const Login();
                      }),
                    );
                  }
                },
                icon: Icon(
                  followbutton
                      ? Icons.notifications_off
                      : Icons.notification_add_sharp,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.all(5),
                child: ResourceViewerTopBar(
                    cpu: true, ram: false, net: true, act: true),
              ),
            ],
          ),
        );
      },
    );
  }
}

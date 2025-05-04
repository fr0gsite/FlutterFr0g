import 'package:flutter/material.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/widgets/login/login.dart';
import 'package:provider/provider.dart';

class SubscriptionIcon extends StatefulWidget {
  const SubscriptionIcon({super.key, required this.username});

  final String username;

  @override
  State<SubscriptionIcon> createState() => _SubscriptionIconState();
}

class _SubscriptionIconState extends State<SubscriptionIcon> {
  bool? followbutton;
  String currentusername = "";

  @override
  void initState() {
    super.initState();
    currentusername = widget.username;
    _loadSubscriptionStatus();
  }

  void _loadSubscriptionStatus() async {
    bool isSubscribed = await Provider.of<GlobalStatus>(context, listen: false)
        .isusersubscribed(widget.username);
    setState(() {
      followbutton = !isSubscribed;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.username != currentusername) {
      currentusername = widget.username;
      _loadSubscriptionStatus();
    }

    if (followbutton == null) {
      return const SizedBox();
    }

    return Tooltip(
      message: followbutton! ? "Subscribe" : "Unsubscribe",
      child: IconButton(
        onPressed: () async {
          if (Provider.of<GlobalStatus>(context, listen: false).isLoggedin) {
            String username =
                Provider.of<GlobalStatus>(context, listen: false).username;
            String permission =
                Provider.of<GlobalStatus>(context, listen: false).permission;
      
            if (!followbutton!) {
              Chainactions()
                ..setusernameandpermission(username, permission)
                ..unfollowuser(widget.username).then((value) {
                  if (value) {
                      Provider.of<GlobalStatus>(context, listen: false).delusersubscription(widget.username);
                      _loadSubscriptionStatus();
                  }
                });
            } else {
              Chainactions()
                ..setusernameandpermission(username, permission)
                ..followuser(widget.username).then((value) {
                  if (value) {
                      Provider.of<GlobalStatus>(context, listen: false).addusersubscription(widget.username);
                      _loadSubscriptionStatus();
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
          followbutton! ? Icons.notification_add_sharp : Icons.notifications_off,
          color: followbutton!
              ? Colors.white
              : Colors.red.withAlpha((0.8 * 255).toInt()),
        ),
      ),
    );
  }
}
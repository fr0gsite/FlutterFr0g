import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/widgets/login/login.dart';
import 'package:fr0gsite/widgets/postviewer/commentandtagbutton.dart';
import 'package:fr0gsite/widgets/home/tagbutton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Tagelement extends StatefulWidget {
  const Tagelement(
      {super.key,
      required this.globaltagid,
      required this.tagtext,
      required this.globuptagid});

  final String globuptagid;
  final String globaltagid;
  final String tagtext;
  @override
  State<Tagelement> createState() => _TagelementState();
}

class _TagelementState extends State<Tagelement> {
  @override
  Widget build(BuildContext context) {
    final BigInt globalTagId = BigInt.parse(widget.globaltagid);
    return Row(children: [
      commentandtagbutton(widget.globuptagid, Icons.add_circle_outline_sharp,
          "Upvote", upvotetag, false, 0, Colors.green, Colors.orange),
      commentandtagbutton(widget.globuptagid, Icons.do_not_disturb_on_outlined,
          "Downvote", downvotetag, false, 0, Colors.red, Colors.orange),
      const SizedBox(width: 5),
      TagButton(
        text: widget.tagtext,
        globaltagid: globalTagId,
        heroTag: 'globaltag-${widget.globaltagid}',
      ),
    ]);
  }

  Future<bool> upvotetag(String tagid) async {
    if (Provider.of<GlobalStatus>(context, listen: false).isLoggedin) {
      String username =
          Provider.of<GlobalStatus>(context, listen: false).username;
      String permission =
          Provider.of<GlobalStatus>(context, listen: false).permission;

      Chainactions temp = Chainactions()
        ..setusernameandpermission(username, permission);
      bool result = false;
      await temp.votetag(tagid, 1).then((value) {
        result = value;
      });
      if (!result) {
        //Show error message
      }
      return result;
    } else {
      showDialog(
          context: context,
          builder: ((context) {
            return const Login();
          }));
      return false;
    }
  }

  Future<bool> downvotetag(String tagid) async {
    if (Provider.of<GlobalStatus>(context, listen: false).isLoggedin) {
      String username =
          Provider.of<GlobalStatus>(context, listen: false).username;
      String permission =
          Provider.of<GlobalStatus>(context, listen: false).permission;

      Chainactions temp = Chainactions()
        ..setusernameandpermission(username, permission);
      bool result = false;
      await temp.votetag(tagid, 0).then((value) {
        result = value;
      });
      if (!result) {
        //Show error message
      }
      return result;
    } else {
      showDialog(
          context: context,
          builder: ((context) {
            return const Login();
          }));
      return false;
    }
  }
}

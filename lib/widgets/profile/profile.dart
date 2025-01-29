//import 'dart:ui_web';

import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/userconfig.dart';
import 'package:fr0gsite/widgets/login/login.dart';
import 'package:fr0gsite/widgets/profile/profilepicture.dart';
import 'package:fr0gsite/widgets/profile/profilestatistic.dart';
import 'package:fr0gsite/widgets/profile/userbadget.dart';
import 'package:fr0gsite/widgets/profile/useruploadsview.dart';
import 'package:eosdart/eosdart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:universal_html/html.dart' as html;

class Profile extends StatefulWidget {
  const Profile({super.key, this.accountname});
  final String? accountname;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController searchcontroller = TextEditingController();

  Account account = Account("Dummy", 0);
  UserConfig currentuserconfig = UserConfig.dummy();
  bool followbutton = false;

  @override
  void initState() {
    super.initState();
    Uri.base.queryParameters.forEach((key, value) {
      if (key == "username") {
        account = Account(value, 0);
        searchcontroller.text = value;
      }
    });
    if (widget.accountname != null) {
      account = Account(widget.accountname!, 0);
      searchcontroller.text = widget.accountname!;
    }

    Provider.of<GlobalStatus>(context, listen: false).expandhomenavigationbar = true;

    Chainactions()
        .getaccountinfo(account.accountName)
        .then((value) => setaccountinfo(value));
    Chainactions()
        .getuserconfig(account.accountName)
        .then((value) => setuserconfig(value));

    if (Provider.of<GlobalStatus>(context, listen: false).isLoggedin) {
      Chainactions()
          .isuserfollowinguser(
              Provider.of<GlobalStatus>(context, listen: false).username,
              account.accountName)
          .then((value) {
        setState(() {
          followbutton = value;
        });
      });
    }
  }

  void setaccountinfo(Account value) {
    debugPrint("setaccountinfo");
    setState(() {
      account = value;
    });
  }

  void setuserconfig(UserConfig value) {
    debugPrint("setuserconfig");
    setState(() {
      currentuserconfig = value;
    });
  }

  void setfollowbutton(bool value) {
    setState(() {
      followbutton = value;
    });
  }

  void newsearch(String usernametosearch) {
    debugPrint("new search");
    setState(() {
      account = Account(usernametosearch, 0);
      html.window.history
          .pushState({}, '', '/profile/$usernametosearch');
      Chainactions()
          .getaccountinfo(account.accountName)
          .then((value) => setaccountinfo(value));
      Chainactions()
          .getuserconfig(account.accountName)
          .then((value) => setuserconfig(value));
    });
  }

  bool compactview = false;

  @override
  Widget build(BuildContext context) {
    compactview = MediaQuery.of(context).size.width < 800;

    //Check if user to custom search

    return Material(
      color: AppColor.nicegrey,
      child: Consumer<GlobalStatus>(
        builder: (context, userstatus, child) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                usersearchbar(),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: userstatus.expandhomenavigationbar
                      ? compactview
                          ? 900
                          : 450
                      : 0,
                  child: userstatus.expandhomenavigationbar
                      ? profiletopbar()
                      : Container(
                          color: AppColor.niceblack,
                        ),
                ),
                SizedBox(
                    height: 1000,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.nicegrey,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white.withAlpha((0.5 * 255).toInt()),
                          width: 2,
                        ),
                      ),
                      child: UserUploadView(
                        username: account.accountName,
                      ),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget usersearchbar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Backbutton
          SizedBox(
            width: 50,
            child: IconButton(
              icon: const Icon(Icons.backspace_rounded),
              color: Colors.white,
              onPressed: () {
                if(Navigator.canPop(context)){
                  Navigator.pop(context);
                }else{
                  Navigator.pushNamed(context, "/");
                }                
              },
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.person,
            color: Colors.white,
            size: iconsize,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width < 640 ? 200 : 400,
            child: TextField(
              controller: searchcontroller,
              //inputFormatters: <TextInputFormatter>[
              //  FilteringTextInputFormatter.allow(RegExp(
              //      r'(^[a-z1-5.]{1,11}[a-z1-5]\$)|(^[a-z1-5.]{12}[a-j1-5]\$)')),
              //],
              onSubmitted: (String value) {
                newsearch(value);
              },
              decoration: InputDecoration(
                hintText: "Search for a user",
                hintStyle: const TextStyle(color: Colors.white),
                fillColor: Colors.grey,
                filled: true,
                hintFadeDuration: const Duration(milliseconds: 100),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            width: iconsize,
            child: IconButton(
              icon: const Icon(Icons.search),
              color: Colors.white,
              onPressed: () {
                newsearch(searchcontroller.text);
              },
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget profiletopbar() {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.blue, // Set the background color to blue
                ),
                onPressed: () {
                  if (Provider.of<GlobalStatus>(context, listen: false)
                      .isLoggedin) {
                    //Wenn eingeloggt
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!
                            .thisfeatureisnotavailableyet),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: ((context) {
                        return const Login();
                      }),
                    );
                  }
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.message,
                      color: Colors.white,
                    ),
                    Text(
                      AppLocalizations.of(context)!.sendmessage,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: followbutton
                      ? Colors.red.shade400
                      : Colors.blue, // Set the background color to blue
                ),
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
                        ..unfollowuser(account.accountName).then((value) {
                          //If successfull, toggle the button
                          if (value) {

                            currentuserconfig.numoffollowers--;
                            setfollowbutton(!followbutton);
                          }
                        });
                    } else {
                      Chainactions()
                        ..setusernameandpermission(username, permission)
                        ..followuser(account.accountName).then((value) {
                          //If successfull, toggle the button
                          if (value) {
                            currentuserconfig.numoffollowers++;
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
                child: Row(
                  children: [
                    Icon(
                      followbutton
                          ? Icons.notifications_off
                          : Icons.notification_add_sharp,
                      color: Colors.white,
                    ),
                    Text(
                      followbutton
                          ? AppLocalizations.of(context)!.unfollow
                          : AppLocalizations.of(context)!.follow,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.niceblack,
                    border: Border.all(
                      color: Colors.white.withAlpha((0.5 * 255).toInt()),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      account.accountName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha((0.5 * 255).toInt()),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white.withAlpha((0.5 * 255).toInt()),
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Profilepicture(accountname: account.accountName),
                      )),
                ),
              ],
            ),
            compactview
                ? Container()
                : Expanded(
                    child: SizedBox(
                    height: 376,
                    child: profileinfo(),
                  )),
          ],
        ),
        compactview ? profileinfo() : Container(),
      ],
    );
  }

  Widget profileinfo() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                  color: AppColor.niceblack,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withAlpha((0.5 * 255).toInt()),
                    width: 2,
                  ),
                ),
                child: Profilestatistic(userconfig: currentuserconfig)),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha((0.3 * 255).toInt()),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withAlpha((0.5 * 255).toInt()),
                    width: 2,
                  ),
                ),
                constraints: const BoxConstraints(
                  minHeight: 100,
                  minWidth: 800,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(currentuserconfig.profilebio,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
            ),
            Userbadget(userconfig: currentuserconfig)
          ],
        ),
      ),
    );
  }
}

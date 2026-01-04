import 'package:auto_size_text/auto_size_text.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/userconfig.dart';
import 'package:fr0gsite/widgets/resources/accountbalance.dart';
import 'package:fr0gsite/widgets/resources/activitytoken.dart';
import 'package:fr0gsite/widgets/resources/applytrusterroleview.dart';
import 'package:fr0gsite/widgets/resources/claimrewardsview.dart';
import 'package:fr0gsite/widgets/resources/resourcebalance.dart';
import 'package:eosdart/eosdart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';

class ResourceViewer extends StatefulWidget {
  const ResourceViewer({super.key});

  @override
  State<ResourceViewer> createState() => _ResourceViewerState();
}

class _ResourceViewerState extends State<ResourceViewer> {
  String currentusername = "";
  Account currentaccount = Account("", 0);
  UserConfig userconfig = UserConfig.dummy();
  bool customsearch = false;
  bool hideinfo = false;
  TextEditingController searchcontroller = TextEditingController();

  double textsize = 15;
  double iconpadding = 8;
  double tableiconsize = 20;
  Color iconcolour = Colors.white;

  @override
  void initState() {
    super.initState();
    if (Provider.of<GlobalStatus>(context, listen: false).isLoggedin &&
        !customsearch) {
      currentusername =
          Provider.of<GlobalStatus>(context, listen: false).username;
      searchcontroller.text = currentusername;
      currentaccount = Account(currentusername, 0);
      Chainactions()
          .getaccountinfo(currentusername)
          .then((value) => setaccountinfo(value));
      Chainactions().getuserconfig(searchcontroller.text).then((value) {
        setState(() {
          userconfig = value;
        });
      });
    }
    if (currentaccount.accountName == "") {
      searchcontroller.text = AppConfig.exampleaccount;
      currentusername = AppConfig.exampleaccount;
      Chainactions()
          .getaccountinfo(currentusername)
          .then((value) => setaccountinfo(value));
    }
    Chainactions().getuserconfig(AppConfig.exampleaccount).then((value) {
      setState(() {
        userconfig = value;
      });
    });
    //Timer 3 seconds for hideinfo
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          hideinfo = true;
        });
      }
    });
  }

  void setaccountinfo(Account value) {
    setState(() {
      currentaccount = value;
    });
  }

  void newSearch() {
    debugPrint("newsearch");
    Chainactions().getaccountinfo(searchcontroller.text).then((value) {
      setState(() {
        customsearch = true;
        currentusername = searchcontroller.text;
        setaccountinfo(value);
      });
      Chainactions().getuserconfig(searchcontroller.text).then((value) {
        setState(() {
          userconfig = value;
        });
      });
    }).catchError((e) {
      debugPrint("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
              child: Text(
            AppLocalizations.of(context)!.usernotfound,
            style: const TextStyle(fontSize: 30),
          )),
          duration: const Duration(seconds: 5),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.nicegrey,
      child: Consumer<GlobalStatus>(builder: (context, userstatus, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            !userstatus.isLoggedin && !hideinfo
                ? Center(
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AutoSizeText(
                            AppLocalizations.of(context)!
                                .nologinviewresourcefromanotheruser,
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        )))
                : Container(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.person),
                    color: Colors.white,
                    iconSize: iconsize,
                    onPressed: () {
                      Navigator.pushNamed(
                          context, "/${AppConfig.profileurlpath}/${searchcontroller.text}",
                          arguments: searchcontroller.text);
                    },
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width < AppConfig.thresholdValueForMobileLayout ? 200 : 400,
                    child: TextField(
                      controller: searchcontroller,
                      onSubmitted: (String value) {
                        newSearch();
                      },
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.search,
                        hintStyle: const TextStyle(color: Colors.white),
                        fillColor: Colors.grey,
                        filled: true,
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
                        newSearch();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  direction: Axis.horizontal,
                  spacing: 40,
                  runSpacing: 40,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage(
                              "assets/images/ressourcebackground.png"),
                          opacity: 0.1,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: ResourceBalance(
                          account: currentaccount,
                          callback: () {
                            newSearch();
                          }),
                    ),
                    Column(children: [
                      //Wallet
                      Container(
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage(
                                "assets/images/walletbackground.png"),
                            opacity: 0.3,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            AutoSizeText(
                              AppLocalizations.of(context)!.wallet,
                              minFontSize: 20,
                              style: const TextStyle(color: Colors.white),
                            ),
                            AccountBalance(account: currentaccount),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //Claim Rewards
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: SizedBox(
                          width: 400,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AutoSizeText(
                                  AppLocalizations.of(context)!.claimrewards,
                                  minFontSize: 20,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, bottom: 8),
                                child: AutoSizeText(
                                  AppLocalizations.of(context)!
                                      .claimrewardexplain,
                                  style: const TextStyle(color: Colors.white),
                                  maxLines: 2,
                                ),
                              ),
                              ClaimRewardsView(
                                account: currentaccount,
                                callback: () {
                                  newSearch();
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: AutoSizeText(
                                  "${AppLocalizations.of(context)!.lastclaimed}: ${DateFormat.yMMMMd(Localizations.localeOf(context).toString()).add_jm().format(userconfig.lastclaimtime.add(Duration(seconds: userconfig.lastclaimtime.timeZoneOffset.inSeconds)))}",
                                  style: const TextStyle(color: Colors.white),
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Activity Token
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: SizedBox(
                            width: 400,
                            child: ActivityToken(userconfig: userconfig)),
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      
                      // Apply Truster Role
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: SizedBox(
                            width: 400,
                            child: ApplyTrusterroleView(userconfig: userconfig)),
                      ),
                    ])
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

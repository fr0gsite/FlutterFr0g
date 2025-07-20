import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/rewardcalc.dart';
import 'package:eosdart/eosdart.dart';
import 'package:flutter/material.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

class ClaimRewardsView extends StatefulWidget {
  final Account account;
  final Null Function() callback;
  const ClaimRewardsView(
      {super.key, required this.account, required this.callback});

  @override
  State<ClaimRewardsView> createState() => _ClaimRewardsViewState();
}

class _ClaimRewardsViewState extends State<ClaimRewardsView> {
  Future? getrewardinfo;
  RewardCalc? rewardinfo;
  late String currentaccountname;

  @override
  void initState() {
    super.initState();
    getrewardinfo = getrewardinfofunc();
    currentaccountname = widget.account.accountName;
  }

  @override
  Widget build(BuildContext context) {
    if (currentaccountname != widget.account.accountName) {
      currentaccountname = widget.account.accountName;
      getrewardinfo = getrewardinfofunc();
    }

    List<String> tooltiptext = [
      AppLocalizations.of(context)!.tokenACTexplain,
      AppLocalizations.of(context)!.tokenFAMEexplain,
      AppLocalizations.of(context)!.tokenTRUSTexplain,
    ];

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 300,
        maxWidth: 400,
      ),
      child: Table(
        border: const TableBorder.symmetric(
            inside: BorderSide(width: 4, color: AppColor.nicegrey)),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        textDirection: TextDirection.ltr,
        children: [
          TableRow(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(AppLocalizations.of(context)!.balance)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(AppLocalizations.of(context)!.claimable)),
            ),
            const Text(""),
          ]),
          //build table row for All tokens AppConfig.rewardtoken
          for (var i = 0; i < AppConfig.rewardtoken.length; i++)
            TableRow(
              decoration: BoxDecoration(
                color: AppConfig.rewardtoken[i].color.withOpacity(0.10),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Tooltip(
                    message: tooltiptext[i],
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        rewardinfo == null
                            ? "0"
                            : "${rewardinfo!.getusersupply(AppConfig.rewardtoken[i].symbol).round()} ${AppConfig.rewardtoken[i].symbol}",
                        style: TextStyle(color: AppConfig.rewardtoken[i].color),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(rewardinfo == null
                        ? "0"
                        : "${rewardinfo!.getreward(AppConfig.rewardtoken[i].symbol).toStringAsFixed(AppConfig.systemtokendecimalafterdot)} ${AppConfig.systemtoken}"),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor:
                        AppConfig.rewardtoken[i].color.withAlpha((0.2 * 255).toInt()),
                  ),
                  onPressed: () async {
                    final globalStatus =
                        Provider.of<GlobalStatus>(context, listen: false);
                    if (globalStatus.isLoggedin) {
                      if (widget.account.accountName == globalStatus.username) {
                        Chainactions()
                          .setusernameandpermission(
                              globalStatus.username, globalStatus.permission);
                        bool value = await Chainactions().claimreward(
                          widget.account.accountName,
                          AppConfig.rewardtoken[i].symbol,
                        );

                        if (!mounted) return;

                        widget.callback();
                        setState(() {
                          getrewardinfo = getrewardinfofunc();
                        });
                        if (value) {
                          if (globalStatus.audionotifications) {
                            AudioPlayer audioPlayer = AudioPlayer();
                            audioPlayer.play(
                                AssetSource("sounds/wow.m4a"),
                                volume: 0.5);
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Center(
                                  child: Text(
                                AppLocalizations.of(context)!.claimsuccess,
                                style: const TextStyle(fontSize: 30),
                              )),
                              duration: const Duration(seconds: 5),
                            ),
                          );
                        } else {
                          if (globalStatus.audionotifications) {
                            AudioPlayer audioPlayer = AudioPlayer();
                            audioPlayer.play(
                                AssetSource("sounds/fail.m4a"),
                                volume: 0.5);
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Center(
                                  child: Text(
                                AppLocalizations.of(context)!.claimerror,
                                style: const TextStyle(fontSize: 30),
                              )),
                              duration: const Duration(seconds: 5),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Center(
                                child: Text(
                              AppLocalizations.of(context)!.claimerror,
                              style: const TextStyle(fontSize: 30),
                            )),
                            duration: const Duration(seconds: 5),
                          ),
                        );
                        return;
                      }
                    } else {
                      //Not logged in
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Center(
                              child: Text(
                            AppLocalizations.of(context)!.youarenotloggedin,
                            style: const TextStyle(fontSize: 30),
                          )),
                          duration: const Duration(seconds: 5),
                        ),
                      );
                      return;
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.claim,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future getrewardinfofunc() async {
    RewardCalc result =
        await Chainactions().getrewardtokeninfo(widget.account.accountName);
    if (!mounted) return;
    setState(() {
      rewardinfo = result;
    });
  }
}

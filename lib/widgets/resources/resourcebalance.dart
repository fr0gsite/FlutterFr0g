import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/widgets/resources/stakeorunstake.dart';
import 'package:eosdart/eosdart.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResourceBalance extends StatefulWidget {
  final Account account;
  final Function callback;
  const ResourceBalance(
      {super.key, required this.account, required this.callback});

  @override
  State<ResourceBalance> createState() => _ResourceBalanceState();
}

class _ResourceBalanceState extends State<ResourceBalance>
    with TickerProviderStateMixin {
  double textsizetitle = 30;
  double textsizeleft = 25;
  double textsizeright = 20;
  double textsizebutton = 25;
  double textsize = 15;
  double iconpadding = 8;
  double tableiconsize = 30;

  Color stakecolor = Colors.green.withOpacity(0.5);
  Color unstakecolor = Colors.red.withOpacity(0.5);
  bool isbuttonactive = false;

  double liquid = 0.0;
  double totalram = 0.0;
  double totalcpu = 0.0;
  double selfDelegatedtotalcpu = 0.0;
  double totalnet = 0.0;
  double selfDelegatedtotalnet = 0.0;
  double refundcpu = 0.0;
  double refundnet = 0.0;

  double cpuLimitused = 0;
  double cpuLimitmax = 0;
  double netLimitused = 0;
  double netLimitmax = 0;
  double ramUsage = 0;
  double ramQuota = 0;

  AnimationController? controllercpu;
  AnimationController? controllernet;
  AnimationController? controllerram;
  bool animationisPlaying = false;
  Timer? timer5000;

  @override
  void initState() {
    super.initState();
    controllercpu = AnimationController(vsync: this);
    controllernet = AnimationController(vsync: this);
    controllerram = AnimationController(vsync: this);
    controllercpu!.duration = const Duration(milliseconds: 4000);
    controllernet!.duration = const Duration(milliseconds: 4000);
    controllerram!.duration = const Duration(milliseconds: 4000);

    playAnimation();
    timer5000 = Timer.periodic(const Duration(seconds: 15), (timer) {
      if (!animationisPlaying) {
        playAnimation();
      }
    });
  }

  void playAnimation() {
    if (!animationisPlaying) {
      animationisPlaying = true;
      controllercpu!.reset();
      controllernet!.reset();
      controllerram!.reset();
      controllercpu!.forward();
      controllernet!.forward();
      controllerram!.forward();
      animationisPlaying = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    liquid = widget.account.coreLiquidBalance?.amount ?? 0.0;
    totalram = widget.account.totalResources?.ramBytes?.toDouble() ?? 0.0;
    totalcpu = widget.account.totalResources?.cpuWeight?.amount ?? 0.0;
    totalnet = widget.account.totalResources?.netWeight?.amount ?? 0.0;
    refundcpu = widget.account.refundRequest?.cpuAmount?.amount ?? 0.0;
    refundnet = widget.account.refundRequest?.netAmount?.amount ?? 0.0;

    selfDelegatedtotalcpu =
        widget.account.selfDelegatedBandwidth?.cpuWeight?.amount ?? 0.0;
    selfDelegatedtotalnet =
        widget.account.selfDelegatedBandwidth?.netWeight?.amount ?? 0.0;

    cpuLimitused = widget.account.cpuLimit?.used?.toDouble() ?? 0;
    cpuLimitmax = widget.account.cpuLimit?.max?.toDouble() ?? 0;
    netLimitused = widget.account.netLimit?.used?.toDouble() ?? 0;
    netLimitmax = widget.account.netLimit?.max?.toDouble() ?? 0;
    ramUsage = widget.account.ramUsage?.toDouble() ?? 0;
    ramQuota = widget.account.ramQuota?.toDouble() ?? 0;

    totalram = totalram / 1000;
    cpuLimitused = cpuLimitused / 1000;
    cpuLimitmax = cpuLimitmax / 1000;
    netLimitused = netLimitused / 1000;
    netLimitmax = netLimitmax / 1000;
    ramUsage = ramUsage / 1000;
    ramQuota = ramQuota / 1000;

    if (cpuLimitmax == 0 || cpuLimitmax == -1) {
      cpuLimitmax = 1;
    }

    double percentcpu = cpuLimitused / cpuLimitmax;
    if (percentcpu > 1 || percentcpu < 0) {
      percentcpu = 1;
    }

    if (netLimitmax == 0 || netLimitmax == -1) {
      netLimitmax = 1;
    }

    double percentnet = netLimitused / netLimitmax;
    if (percentnet > 1 || percentnet < 0) {
      percentnet = 1;
    }

    if (widget.account.accountName ==
        Provider.of<GlobalStatus>(context, listen: false)
            .useraccount
            .accountName) {
      isbuttonactive = true;
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 300,
        maxWidth: 500,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.resources,
                    style: const TextStyle(color: Colors.white, fontSize: 20)),
                Text(AppLocalizations.of(context)!.resourcesexplain,
                    style: TextStyle(fontSize: textsize)),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              //color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Table(
                  border: const TableBorder.symmetric(
                      inside: BorderSide(width: 1, color: Colors.black)),
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(2),
                  },
                  children: [
                    //INFO
                    TableRow(children: [
                      TableCell(
                          child: Center(
                              child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AutoSizeText(
                            AppLocalizations.of(context)!.staked,
                            maxLines: 1,
                            textScaleFactor: 1.5,
                            style: const TextStyle(color: Colors.white)),
                      ))),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(AppLocalizations.of(context)!.stakedexplain,
                                  style: TextStyle(
                                      fontSize: textsize, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ]),

                    //CPU
                    TableRow(
                      children: [
                        TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Tooltip(
                                    message: AppLocalizations.of(context)!
                                        .cpuexplain,
                                    child: Text(
                                      "CPU",
                                      style: TextStyle(fontSize: textsizeleft),
                                    ),
                                  ),
                                ),
                                Lottie.asset(
                                  "assets/lottie/cpu.json",
                                  width: 150,
                                  height: 150,
                                  controller: controllercpu,
                                ),
                              ],
                            )),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      "$totalcpu ${AppConfig.systemtoken}",
                                      style:
                                          TextStyle(fontSize: textsizeright)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, right: 8, bottom: 8),
                                  child: Text(
                                      AppLocalizations.of(context)!
                                          .reservesthisamountofresources,
                                      style: TextStyle(fontSize: textsize)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: LinearPercentIndicator(
                                    lineHeight: 30,
                                    barRadius: const Radius.circular(15),
                                    percent: percentcpu,
                                    backgroundColor: Ressourcecolor.background
                                        .withOpacity(0.5),
                                    progressColor: Ressourcecolor.cpu,
                                    center: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8, left: 8),
                                      child: Text(
                                          "$cpuLimitused s / $cpuLimitmax s",
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    //NET

                    TableRow(
                      children: [
                        TableCell(
                            child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Tooltip(
                                message:
                                    AppLocalizations.of(context)!.netexplain,
                                child: Text(
                                  "NET",
                                  style: TextStyle(fontSize: textsizeleft),
                                ),
                              ),
                            ),
                            Lottie.asset(
                              "assets/lottie/net.json",
                              width: 150,
                              height: 150,
                              controller: controllernet,
                            ),
                          ],
                        )),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      "$totalnet ${AppConfig.systemtoken}",
                                      style:
                                          TextStyle(fontSize: textsizeright)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, right: 8, bottom: 8),
                                  child: Text(
                                      AppLocalizations.of(context)!
                                          .reservesthisamountofresources,
                                      style: TextStyle(fontSize: textsize)),
                                ),
                                LinearPercentIndicator(
                                  lineHeight: 30,
                                  barRadius: const Radius.circular(15),
                                  percent: percentnet,
                                  backgroundColor: Ressourcecolor.background
                                      .withOpacity(0.5),
                                  progressColor: Ressourcecolor.net,
                                  center: Text(
                                      "$netLimitused kb / $netLimitmax kb",
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    //StakeButton
                    TableRow(
                      children: [
                        const TableCell(child: Text("")),
                        TableCell(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 10,
                            children: [
                              isbuttonactive
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all<Color>(
                                                  stakecolor),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              barrierColor: Colors.black
                                                  .withOpacity(
                                                      0.5), // Grau ausgegrauter Hintergrund
                                              builder: (BuildContext context) {
                                                return Dialog(
                                                  child: StakeorUnstake(
                                                      action: "Stake",
                                                      account: widget.account),
                                                );
                                              }).then((value) {
                                            debugPrint("Dialog closed");
                                            widget.callback();
                                          });
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)!.stake,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: textsizebutton,
                                                color: Colors.white)),
                                      ),
                                    )
                                  : Container(),
                              isbuttonactive
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all<Color>(
                                                  unstakecolor),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              barrierColor: Colors.black
                                                  .withOpacity(
                                                      0.5), // Grau ausgegrauter Hintergrund
                                              builder: (BuildContext context) {
                                                return Dialog(
                                                  child: StakeorUnstake(
                                                      action: "Unstake",
                                                      account: widget.account),
                                                );
                                              }).then((value) {
                                            debugPrint("Dialog closed");
                                            widget.callback();
                                          });
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .unstake,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: textsizebutton,
                                                color: Colors.white)),
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Container(
              decoration: BoxDecoration(
                //color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 300,
                      maxWidth: 600,
                    ),
                    child: Table(
                      border: const TableBorder.symmetric(
                          inside: BorderSide(width: 1, color: Colors.black)),
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(2),
                      },
                      children: [
                        //INFO
                        TableRow(children: [
                          TableCell(
                              child: Center(
                                  child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(AppLocalizations.of(context)!.purchased,
                                style: TextStyle(fontSize: textsizetitle)),
                          ))),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .purchasedexplain,
                                    style: TextStyle(fontSize: textsize),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),

                        //RAM
                        TableRow(
                          children: [
                            TableCell(
                                child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Tooltip(
                                    message: AppLocalizations.of(context)!
                                        .ramexplain,
                                    child: Text(
                                      "RAM",
                                      style: TextStyle(fontSize: textsizeleft),
                                    ),
                                  ),
                                ),
                                Lottie.asset(
                                  "assets/lottie/ram.json",
                                  width: 150,
                                  height: 150,
                                  controller: controllerram,
                                ),
                              ],
                            )),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("$totalram kb",
                                          style: TextStyle(
                                              fontSize: textsizeright)),
                                    ),
                                    LinearPercentIndicator(
                                      lineHeight: 30,
                                      barRadius: const Radius.circular(15),
                                      percent: 0,
                                      backgroundColor: Ressourcecolor.background
                                          .withOpacity(0.5),
                                      progressColor: Ressourcecolor.ram,
                                      center: Text(
                                          "$ramUsage kb / $ramQuota kb",
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        //StakeButton
                        TableRow(children: [
                          const TableCell(
                            child: Text(""),
                          ),
                          TableCell(
                              child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 10,
                            children: [
                              isbuttonactive
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all<Color>(
                                                  stakecolor),
                                        ),
                                        onPressed: () {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(AppLocalizations.of(
                                                    context)!
                                                .thisfeatureisnotavailableyet),
                                          ));
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)!.buy,
                                          style: TextStyle(
                                              fontSize: textsizebutton,
                                              color: Colors.white),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              isbuttonactive
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all<Color>(
                                                  unstakecolor),
                                        ),
                                        onPressed: () {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                AppLocalizations.of(context)!
                                                    .thisfeatureisnotavailableyet,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)!.sell,
                                          style: TextStyle(
                                              fontSize: textsizebutton,
                                              color: Colors.white),
                                        ),
                                      ),
                                    )
                                  : Container()
                            ],
                          )),
                        ])
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer5000!.cancel();
    controllercpu!.dispose();
    controllernet!.dispose();
    controllerram!.dispose();
    super.dispose();
  }
}

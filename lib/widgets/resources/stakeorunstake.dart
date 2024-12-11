import 'dart:async';

import 'package:action_slider/action_slider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:eosdart/eosdart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StakeorUnstake extends StatefulWidget {
  final String action;
  final Account account;

  const StakeorUnstake(
      {super.key, required this.action, required this.account});

  @override
  State<StakeorUnstake> createState() => _StakeorUnstakeState();
}

class _StakeorUnstakeState extends State<StakeorUnstake> {
  bool transactionresult = false;

  double slidervaluecpu = 0.0;
  double slidervaluenet = 0.0;

  double slidercpumax = 0.0;
  double slidernetmax = 0.0;

  double liquid = 0.0;
  double refund = 0.0;
  double refundcpu = 0.0;
  double refundnet = 0.0;
  double cpurow1 = 0.0;
  double netrow1 = 0.0;

  //Already staked
  double totalcpu = 0.0;
  double totalnet = 0.0;
  int cpuLimitmax = 0;
  int netLimitmax = 0;

  TextEditingController textEditingControllercpu =
      TextEditingController(text: "0");
  TextEditingController textEditingControllernet =
      TextEditingController(text: "0");

  ActionSliderController actionslidercontroller = ActionSliderController();

  MaterialColor activeColor = Colors.green;
  MaterialColor inactiveColor = Colors.grey;

  //Advanced view
  bool advancedview = false;
  TextEditingController advancedviewTextEditingControllerfrom =
      TextEditingController();
  TextEditingController advancedviewTextEditingControllerto =
      TextEditingController();
  TextEditingController advancedviewTextEditingControllercpu =
      TextEditingController();
  TextEditingController advancedviewTextEditingControllernet =
      TextEditingController();
  bool advancedviewtransfer = false;

  @override
  void initState() {
    super.initState();

    liquid = widget.account.coreLiquidBalance?.amount ?? 0.0;

    //Already staked
    totalcpu = widget.account.totalResources?.cpuWeight?.amount ?? 0.0;
    totalnet = widget.account.totalResources?.netWeight?.amount ?? 0.0;
    cpuLimitmax = widget.account.cpuLimit?.max ?? 0;
    netLimitmax = widget.account.netLimit?.max ?? 0;

    //Refund
    refundcpu = widget.account.refundRequest?.cpuAmount?.amount ?? 0.0;
    refundnet = widget.account.refundRequest?.netAmount?.amount ?? 0.0;

    print("liquid ===> $liquid");
    print("totalcpu ===> $totalcpu");
    print("totalnet ===> $totalnet");
    print("cpuLimitmax ===> $cpuLimitmax");
    print("netLimitmax ===> $netLimitmax");
    print("refundcpu ===> $refundcpu");
    print("refundnet ===> $refundnet");

    switch (widget.action) {
      case "Stake":
        activeColor = Colors.green;
        cpurow1 = totalcpu;
        netrow1 = totalnet;
        break;
      case "Unstake":
        activeColor = Colors.red;
        cpurow1 = totalcpu;
        netrow1 = totalnet;
        break;
    }

    slidercpumax = cpurow1;
    slidernetmax = netrow1;
  }

  void updatevalues(double value, String typ) {
    value = (value * 10000).round() / 10000;

    setState(() {

      print("updatevalues =====> $value");
      switch (typ) {
        case "CPU":
          value = value > slidercpumax ? slidercpumax : value;
          slidervaluecpu = value;
          textEditingControllercpu.text = slidervaluecpu.toStringAsFixed(4);
          break;
        case "NET":
          value = value > slidernetmax ? slidernetmax : value;
          slidervaluenet = value;
          textEditingControllernet.text = slidervaluenet.toStringAsFixed(4);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double cpurow2 = slidervaluecpu;
    double ramrow2 = slidervaluenet;

    switch (widget.action) {
      case "Stake":
        slidercpumax = liquid + refundcpu - slidervaluenet;
        slidernetmax = liquid + refundnet - slidervaluecpu;
        break;
      case "Unstake":
        cpurow2 = slidercpumax - slidervaluecpu;
        ramrow2 = slidernetmax - slidervaluenet;
        slidercpumax = cpurow1;
        slidernetmax = netrow1;
        break;
    }

    if (transactionresult) {
      Navigator.of(context).pop();
    }

    return Material(
      child: SingleChildScrollView(
        child: Container(
          width: 500.0,
          decoration: BoxDecoration(
              color: AppColor.niceblack,
              border: Border.all(
                color: activeColor,
                width: 5.0,
              )),
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: activeColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.action,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                Table(
                  border: TableBorder.all(color: Colors.grey),
                  children: [
                    TableRow(
                        decoration: const BoxDecoration(
                          color: AppColor.nicegrey,
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              AppLocalizations.of(context)!.resources,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "CPU",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "RAM",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.action == "Stake"
                              ? AppLocalizations.of(context)!.current
                              : AppLocalizations.of(context)!.available,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${cpurow1.toStringAsFixed(4)} ${AppConfig.systemtoken}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${netrow1.toStringAsFixed(4)} ${AppConfig.systemtoken}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.action == "Stake"
                              ? AppLocalizations.of(context)!.add
                              : AppLocalizations.of(context)!.remains,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${cpurow2.toStringAsFixed(4)} ${AppConfig.systemtoken}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${ramrow2.toStringAsFixed(4)} ${AppConfig.systemtoken}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ]),
                  ],
                ),

                liquid == 0.0
                    ? const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          "No coins can be staked. \nPlease fund your account with coins",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "CPU",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          Expanded(
                            child: Slider(
                                activeColor: activeColor,
                                inactiveColor: inactiveColor,
                                value: slidervaluecpu,
                                min: 0,
                                max: slidercpumax,
                                divisions: 100,
                                onChanged: (double value) {
                                  updatevalues(value, "CPU");
                                }),
                          ),
                          SizedBox(
                            width: 100,
                            child: TextField(
                              controller: textEditingControllercpu,
                              decoration: InputDecoration(
                                hintText: "0",
                                hintStyle: const TextStyle(color: Colors.white),
                                fillColor: Colors.grey,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                              onSubmitted: (value) {
                                double parsedvalue = double.parse(value);
                                if (parsedvalue <= slidercpumax) {
                                  updatevalues(double.parse(value), "CPU");
                                } else {
                                  updatevalues(slidercpumax, "CPU");
                                }
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,4}$'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "NET",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Slider(
                            activeColor: activeColor,
                            inactiveColor: inactiveColor,
                            value: slidervaluenet,
                            min: 0,
                            max: slidernetmax,
                            divisions: 100,
                            onChanged: (double value) {
                              updatevalues(value, "NET");
                            }),
                      ),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: textEditingControllernet,
                          decoration: InputDecoration(
                            hintText: "0",
                            hintStyle: const TextStyle(color: Colors.white),
                            fillColor: Colors.grey,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          onSubmitted: (value) {
                            double parsedvalue = double.parse(value);
                            if (parsedvalue <= slidernetmax) {
                              updatevalues(double.parse(value), "NET");
                            } else {
                              updatevalues(slidernetmax, "NET");
                            }
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,4}$'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                widget.action == "Unstake"
                    ? AutoSizeText(AppLocalizations.of(context)!
                        .unstakedtokenkeepfrozenforthreedays)
                    : Container(),
                //Toogle advanced view
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.advancedview,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Switch(
                        value: advancedview,
                        inactiveTrackColor: Colors.grey,
                        onChanged: (value) {
                          setState(() {
                            advancedview = value;
                          });
                        },
                        activeTrackColor: activeColor,
                        activeColor: activeColor,
                      ),
                    ],
                  ),
                ),
                //Advanced view
                !advancedview
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Table(
                          children: [
                            TableRow(children: [
                              Text(
                                  "${AppLocalizations.of(context)!.fromusername}:"),
                            ]),
                            TableRow(children: [
                              TextField(
                                decoration: inputDecoration("e.g myusername"),
                                controller:
                                    advancedviewTextEditingControllerfrom,
                              ),
                            ]),
                            TableRow(children: [
                              Text(
                                  "${AppLocalizations.of(context)!.tousername}:"),
                            ]),
                            TableRow(children: [
                              TextField(
                                decoration: inputDecoration("e.g tousername"),
                                controller: advancedviewTextEditingControllerto,
                              ),
                            ]),
                            const TableRow(children: [
                              Text("CPU (${AppConfig.systemtoken}):"),
                            ]),
                            TableRow(children: [
                              TextField(
                                decoration: inputDecoration("e.g 0.1000"),
                                controller:
                                    advancedviewTextEditingControllercpu,
                              ),
                            ]),
                            const TableRow(children: [
                              Text("NET (${AppConfig.systemtoken}):"),
                            ]),
                            TableRow(children: [
                              TextField(
                                decoration: inputDecoration("e.g 0.1000"),
                                controller:
                                    advancedviewTextEditingControllernet,
                              ),
                            ]),
                            TableRow(children: [
                              Text(AppLocalizations.of(context)!
                                  .transferexplained),
                            ]),
                            TableRow(children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Switch(
                                  value: advancedviewtransfer,
                                  inactiveTrackColor: Colors.grey,
                                  onChanged: (value) {
                                    setState(() {
                                      advancedviewtransfer = value;
                                    });
                                  },
                                  activeTrackColor: activeColor,
                                  activeColor: activeColor,
                                ),
                              ),
                            ]),
                          ],
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ActionSlider.standard(
                    sliderBehavior: SliderBehavior.stretch,
                    controller: actionslidercontroller,
                    width: 300.0,
                    backgroundColor: activeColor,
                    toggleColor: Colors.white,
                    action: (controller) async {
                      controller.loading();
                      if (widget.action == "Stake") {
                        Chainactions()
                          ..setusernameandpermission(
                              Provider.of<GlobalStatus>(context, listen: false)
                                  .username,
                              Provider.of<GlobalStatus>(context, listen: false)
                                  .permission)
                          ..stake(
                                  Provider.of<GlobalStatus>(context,
                                          listen: false)
                                      .username,
                                  Provider.of<GlobalStatus>(context,
                                          listen: false)
                                      .username,
                                  slidervaluecpu,
                                  slidervaluenet)
                              .then((value) async {
                            if (value) {
                              controller.success();
                              await Future.delayed(const Duration(seconds: 1));
                              setState(() {
                                transactionresult = true;
                              });
                            } else {
                              controller.failure();
                              await Future.delayed(const Duration(seconds: 3));
                              setState(() {
                                transactionresult = true;
                              });
                            }
                          });
                      } else {
                        Chainactions()
                          ..setusernameandpermission(
                              Provider.of<GlobalStatus>(context, listen: false)
                                  .username,
                              Provider.of<GlobalStatus>(context, listen: false)
                                  .permission)
                          ..unstake(
                                  Provider.of<GlobalStatus>(context,
                                          listen: false)
                                      .username,
                                  Provider.of<GlobalStatus>(context,
                                          listen: false)
                                      .username,
                                  slidervaluecpu,
                                  slidervaluenet)
                              .then((value) async {
                            if (value) {
                              controller.success();
                              await Future.delayed(const Duration(seconds: 1));
                              setState(() {
                                transactionresult = true;
                              });
                            } else {
                              controller.failure();
                              await Future.delayed(const Duration(seconds: 3));
                              setState(() {
                                transactionresult = true;
                              });
                            }
                          });
                      }
                    },
                    child: Text(AppLocalizations.of(context)!.slidetoconfirm),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white),
      fillColor: Colors.grey,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

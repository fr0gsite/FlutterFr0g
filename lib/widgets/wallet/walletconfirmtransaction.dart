import 'dart:async';

import 'package:action_slider/action_slider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:flutter/material.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class WalletConfirmTransaction extends StatefulWidget {
  const WalletConfirmTransaction(
      {super.key,
      required this.callback,
      required this.sendtoaccount,
      required this.amount,
      required this.memo});
  final Function callback;
  final String sendtoaccount;
  final String amount;
  final String memo;

  @override
  State<WalletConfirmTransaction> createState() =>
      _WalletConfirmTransactionState();
}

class _WalletConfirmTransactionState extends State<WalletConfirmTransaction> {
  ActionSliderController actionslidercontroller = ActionSliderController();
  Color backgroundcolorslider = Colors.red;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Container(
            width: 400,
            decoration: BoxDecoration(
              border: Border.all(color: backgroundcolorslider, width: 2),
              color: AppColor.niceblack,
            ),
            child: Center(
                child: Column(
              children: [
                AutoSizeText(
                  AppLocalizations.of(context)!.confirm,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  minFontSize: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AutoSizeText(
                    "${widget.amount} ${AppConfig.systemtoken} -> ${widget.sendtoaccount}",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    minFontSize: 20,
                  ),
                ),
                //Memo
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AutoSizeText(
                    widget.memo,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    minFontSize: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ActionSlider.standard(
                    sliderBehavior: SliderBehavior.stretch,
                    controller: actionslidercontroller,
                    width: 300.0,
                    backgroundColor: backgroundcolorslider,
                    toggleColor: Colors.white,
                    action: (controller) async {
                      controller.loading();

                      // Extract providers early to avoid context usage across async gaps
                      final globalStatus = Provider.of<GlobalStatus>(context, listen: false);
                      
                      double parsedamount = double.parse(widget.amount);

                      String amountinformat =
                          "${parsedamount.toStringAsFixed(AppConfig.systemtokendecimalafterdot)} ${AppConfig.systemtoken}";

                      Chainactions()
                        ..setusernameandpermission(
                            globalStatus.username,
                            globalStatus.permission)
                        ..sendtoken(
                                globalStatus.username,
                                widget.sendtoaccount,
                                amountinformat,
                                widget.memo)
                            .then((value) {
                          if (value) {
                            if (globalStatus.audionotifications) {
                            AudioPlayer audioPlayer = AudioPlayer();
                            audioPlayer.play(
                                  AssetSource("sounds/cash2.m4a"),
                                  volume: 0.5,
                                  mode: PlayerMode.lowLatency);
                            }
                            
                            if (mounted) {
                              setState(() {
                                backgroundcolorslider = Colors.green;
                              });
                            }

                            controller.success();

                            Timer(const Duration(seconds: 1), () {
                              if (mounted) {
                                Navigator.pop(context);
                                Timer(const Duration(seconds: 1), () {
                                  widget.callback();
                                });
                              }
                            });
                          } else {
                            controller.failure();
                          }
                        });
                    },
                    child: Text(AppLocalizations.of(context)!.slidetoconfirm),
                  ),
                )
              ],
            ))),
      ),
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/widgets/login/login.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';

class ResourceViewerTopBar extends StatefulWidget {
  final bool cpu;
  final bool ram;
  final bool net;
  final bool act;
  const ResourceViewerTopBar(
      {super.key,
      required this.cpu,
      required this.ram,
      required this.net,
      required this.act});

  @override
  State<ResourceViewerTopBar> createState() => _ResourceViewerTopBarState();
}

class _ResourceViewerTopBarState extends State<ResourceViewerTopBar> {
  double width = 100;
  double lineHeight = 8.0;
  double textsize = 12.0;
  double minFontSize = 8.0;
  double maxFontSize = 12.0;

  @override
  void initState() {
    super.initState();
    Provider.of<GlobalStatus>(context, listen: false).updateaccountinfo();
    Provider.of<GlobalStatus>(context, listen: false).updateuserconfig();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalStatus>(
      builder: (context, userstatus, child) {
        debugPrint("ResourceViewerTopBar");
        return Stack(
          children: [
            SingleChildScrollView(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/resource");
                },
                child: Wrap(
                  direction: Axis.vertical,
                  children: [
                    widget.cpu
                        ? Row(
                            children: [
                              AutoSizeText(
                                "CPU: ",
                                minFontSize: minFontSize,
                                maxFontSize: maxFontSize,
                              ),
                              Tooltip(
                                message:
                                    "${(userstatus.useraccount.cpuLimit?.used ?? 0)}ms / ${(userstatus.useraccount.cpuLimit?.max ?? 0)}ms",
                                child: LinearPercentIndicator(
                                    width: width,
                                    lineHeight: lineHeight,
                                    percent: userstatus.cpu,
                                    backgroundColor: Ressourcecolor.background,
                                    progressColor: Ressourcecolor.cpu,
                                    center: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [Text("")],
                                    )),
                              ),
                            ],
                          )
                        : Container(),
                    widget.ram
                        ? Row(
                            children: [
                              AutoSizeText(
                                "RAM: ",
                                minFontSize: minFontSize,
                                maxFontSize: maxFontSize,
                              ),
                              Tooltip(
                                message:
                                    "${(userstatus.useraccount.ramUsage ?? 0)}kb / ${(userstatus.useraccount.ramQuota ?? 0)}kb",
                                child: LinearPercentIndicator(
                                  width: width,
                                  lineHeight: lineHeight,
                                  percent: userstatus.ram,
                                  backgroundColor: Ressourcecolor.background,
                                  progressColor: Ressourcecolor.ram,
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    widget.net
                        ? Row(
                            children: [
                              AutoSizeText(
                                "NET: ",
                                minFontSize: minFontSize,
                                maxFontSize: maxFontSize,
                              ),
                              Tooltip(
                                message:
                                    "${(userstatus.useraccount.netLimit?.used ?? 0)}kb / ${(userstatus.useraccount.netLimit?.max ?? 0)}kb",
                                child: LinearPercentIndicator(
                                  width: width,
                                  lineHeight: lineHeight,
                                  percent: userstatus.net,
                                  backgroundColor: Ressourcecolor.background,
                                  progressColor: Ressourcecolor.net,
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    widget.act
                        ? Row(
                            children: [
                              AutoSizeText(
                                "ACT: ",
                                minFontSize: minFontSize,
                                maxFontSize: maxFontSize,
                              ),
                              Tooltip(
                                message:
                                    "${userstatus.acttoken} / ${userstatus.actmax}",
                                child: LinearPercentIndicator(
                                  width: width,
                                  lineHeight: lineHeight,
                                  percent: userstatus.act,
                                  backgroundColor: Ressourcecolor.background,
                                  progressColor: Ressourcecolor.act,
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
            userstatus.isLoggedin
                ? Container()
                : Container(
                    color: Colors.black.withAlpha((0.5 * 255).toInt()),
                    width: width + 22,
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: ((context) {
                              return const Login();
                            }),
                          );
                        },
                        child: AutoSizeText(
                          AppLocalizations.of(context)!.youarenotloggedin,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
          ],
        );
      },
    );
  }
}

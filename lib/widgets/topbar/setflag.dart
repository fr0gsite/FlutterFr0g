import 'package:auto_size_text/auto_size_text.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';

class SetFlag extends StatefulWidget {
  const SetFlag({super.key});

  @override
  State<SetFlag> createState() => _SetFlagState();
}

class _SetFlagState extends State<SetFlag> {
  var overlaycontroller = OverlayPortalController();
  bool sflag = true;
  bool eflag = false;
  bool bflag = false;

  @override
  Widget build(BuildContext context) {
    if (Provider.of<GlobalStatus>(context).isLoggedin) {
      return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.all(0.0)),
        ),
        onPressed: overlaycontroller.toggle,
        child: OverlayPortal(
          controller: overlaycontroller,
          overlayChildBuilder: (context) {
            return Positioned(
              top: 50,
              right: 0,
              child: SizedBox(
                height: 150,
                width: 300,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.niceblack,
                    border: Border.all(color: Colors.white),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Card(
                    color: AppColor.niceblack,
                    borderOnForeground: true,
                    shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton(
                            onPressed: () {
                              setState(() {
                                sflag = !sflag;
                              });
                            },
                            child: AutoSizeText(
                              AppLocalizations.of(context)!.safeforwork,
                              style: TextStyle(
                                  color: sflag ? Colors.red : Colors.white),
                              minFontSize: 18,
                            )),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                eflag = !eflag;
                              });
                            },
                            child: AutoSizeText(
                              AppLocalizations.of(context)!.erotic,
                              style: TextStyle(
                                  color: eflag ? Colors.red : Colors.white),
                              minFontSize: 18,
                            )),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                bflag = !bflag;
                              });
                            },
                            child: AutoSizeText(
                              AppLocalizations.of(context)!.brutal,
                              style: TextStyle(
                                  color: bflag ? Colors.red : Colors.white),
                              minFontSize: 18,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.dynamic_feed, color: Colors.white),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .safeforwork
                        .substring(0, 1)
                        .toUpperCase(),
                    style: TextStyle(color: sflag ? Colors.red : Colors.white),
                  ),
                  Text(
                      AppLocalizations.of(context)!
                          .erotic
                          .substring(0, 1)
                          .toUpperCase(),
                      style:
                          TextStyle(color: eflag ? Colors.red : Colors.white)),
                  Text(
                      AppLocalizations.of(context)!
                          .brutal
                          .substring(0, 1)
                          .toUpperCase(),
                      style:
                          TextStyle(color: bflag ? Colors.red : Colors.white)),
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}

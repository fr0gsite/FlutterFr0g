import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/postviewerstatus.dart';
import 'package:fr0gsite/datatypes/reportstatus.dart';
import 'package:fr0gsite/widgets/report/reportnextbutton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Report3 extends StatefulWidget {
  const Report3({super.key});

  @override
  State<Report3> createState() => _Report3State();
}

class _Report3State extends State<Report3> {
  TextEditingController textcontroller = TextEditingController();
  int textlength = 0;

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          textlength = textcontroller.text.length;
        });
        textcontroller.addListener(() {
          if (textlength != textcontroller.text.length) {
            setState(() {
              textlength = textcontroller.text.length;
              if (textcontroller.text.length > AppConfig.maxReportLength) {
                textcontroller.text =
                    textcontroller.text.substring(0, AppConfig.maxReportLength);
                textlength = textcontroller.text.length;
              }
            });
            Provider.of<ReportStatus>(context, listen: false).reporttext =
                textcontroller.text;
          }
        });
        focusNode.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ReportStatus reportStatus, child) {
      if (!reportStatus.initmessagegenerated) {
        reportStatus.initmessagegenerated = true;
        Provider.of<ReportStatus>(context, listen: false).uploadid =
            Provider.of<PostviewerStatus>(context, listen: false)
                .currentupload
                .uploadid
                .toString();

        textcontroller.text = "Upload ID : ${reportStatus.uploadid}\n";
        textcontroller.text +=
            "Violating Rule Nr : ${reportStatus.rules[reportStatus.selectedrule - 1].ruleNr}\n";
        reportStatus.selectedprovider == 1
            ? textcontroller.text +=
                "Reported by :${Provider.of<GlobalStatus>(context).username}\n"
            : textcontroller.text += "Reported by :Anonymous\n";
        textcontroller.text += "More Details (optional):\n";
        reportStatus.reporttext = textcontroller.text;
      }

      return Column(children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 700, maxWidth: 700),
              child: Wrap(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AutoSizeText(
                          AppLocalizations.of(context)!
                              .moreinformationaboutreport,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    "${AppLocalizations.of(context)!.rule} ${reportStatus.rules[reportStatus.selectedrule - 1].ruleNr}: ${reportStatus.rules[reportStatus.selectedrule - 1].ruleName} \n",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                  text:
                                      "${AppLocalizations.of(context)!.punishment}: ${reportStatus.rules[reportStatus.selectedrule - 1].rulePunishment}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.redAccent)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 700, maxWidth: 700),
            child: TextField(
              maxLines: textcontroller.text.split('\n').length + 1,
              focusNode: focusNode,
              controller: textcontroller,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)!.report,
                  labelStyle: const TextStyle(color: Colors.white),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 3),
                  ),
                  filled: true,
                  fillColor: Colors.blueGrey),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text("$textlength / ${AppConfig.maxReportLength}")
              ]),
            )),
        const Column(
          children: [Text("")],
        ),
        const ReportNextButton(),
      ]);
    });
  }
}

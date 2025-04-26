import 'package:auto_size_text/auto_size_text.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/reportstatus.dart';
import 'package:fr0gsite/widgets/login/login.dart';
import 'package:fr0gsite/widgets/report/reportnextbutton.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Report2 extends StatefulWidget {
  const Report2({super.key});

  @override
  State<Report2> createState() => _Report2State();
}

class _Report2State extends State<Report2> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ReportStatus reportStatus, child) {
      return Column(children: [
        Padding(
            padding: const EdgeInsets.all(16),
            child: Lottie.asset('assets/lottie/reportchecklist.json',
                repeat: false, height: 100, width: 100, fit: BoxFit.fill)),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text(""),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
          child: AutoSizeText(
            "${AppLocalizations.of(context)!.reportwith}:",
            minFontSize: 20,
            maxFontSize: 30,
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200, maxWidth: 400),
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ListTile(
                  title: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        if (Provider.of<GlobalStatus>(context, listen: false)
                            .isLoggedin) {
                          Provider.of<ReportStatus>(context, listen: false)
                              .setProvider(1);
                          Provider.of<ReportStatus>(context, listen: false)
                                  .selectedusername =
                              Provider.of<GlobalStatus>(context, listen: false)
                                  .username;
                        }
                      },
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                "${AppLocalizations.of(context)!.byyourself}: ${Provider.of<GlobalStatus>(context).isLoggedin ? Provider.of<GlobalStatus>(context).username : ""}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              AutoSizeText(
                                AppLocalizations.of(context)!
                                    .successfulreportsarerewarded,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                          Provider.of<GlobalStatus>(context).isLoggedin
                              ? Container()
                              : TextButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return const Login();
                                        });
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.red.withAlpha((0.8 * 255).toInt()),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .youarenotloggedin,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      )),
                                )
                        ],
                      ),
                    ),
                  ),
                  leading: Radio(
                    value: 1,
                    groupValue:
                        Provider.of<ReportStatus>(context).selectedprovider,
                    fillColor: WidgetStateProperty.all(Colors.white),
                    onChanged: (value) {
                      if (Provider.of<GlobalStatus>(context, listen: false)
                          .isLoggedin) {
                        Provider.of<ReportStatus>(context, listen: false)
                            .setProvider(1);
                        Provider.of<ReportStatus>(context, listen: false)
                                .selectedusername =
                            Provider.of<GlobalStatus>(context, listen: false)
                                .username;
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ListTile(
                  title: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        Provider.of<ReportStatus>(context, listen: false)
                            .setProvider(2);
                      },
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              AppLocalizations.of(context)!.anonymous,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            AutoSizeText(
                              AppLocalizations.of(context)!.reportbycommunitynode,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.orange,
                              ),
                            ),
                          ]),
                    ),
                  ),
                  leading: Radio(
                    value: 2,
                    groupValue:
                        Provider.of<ReportStatus>(context).selectedprovider,
                    fillColor: WidgetStateProperty.all(Colors.white),
                    onChanged: (value) {
                      Provider.of<ReportStatus>(context, listen: false)
                          .setProvider(2);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const ReportNextButton(),
      ]);
    });
  }
}

import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/reportstatus.dart';
import 'package:fr0gsite/globalnotifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ReportNextButton extends StatefulWidget {
  const ReportNextButton({super.key});

  @override
  State<ReportNextButton> createState() => _ReportNextButtonState();
}

class _ReportNextButtonState extends State<ReportNextButton> {
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Provider.of<ReportStatus>(context).currentStep == 0
          ? Container()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  Provider.of<ReportStatus>(context, listen: false)
                      .previousStep();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.red.withAlpha((0.3 * 255).toInt()),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.navigate_before, color: Colors.white),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8.0, left: 32.0, right: 32.0),
                        child: Text(AppLocalizations.of(context)!.back,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white)),
                      )
                    ],
                  ),
                ),
              ),
            ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          onPressed: () {
            int currentstep =
                Provider.of<ReportStatus>(context, listen: false).currentStep;
            if (currentstep == 2) {
              int selectedprovider =
                  Provider.of<ReportStatus>(context, listen: false)
                      .selectedprovider;
              int selectedrule =
                  Provider.of<ReportStatus>(context, listen: false)
                      .selectedrule;
              String reporttext =
                  Provider.of<ReportStatus>(context, listen: false).reporttext;
              String uploadid =
                  Provider.of<ReportStatus>(context, listen: false).uploadid;
              String selectedusername =
                  Provider.of<ReportStatus>(context, listen: false)
                      .selectedusername;

              if (selectedprovider != -1 && selectedrule != -1) {
                if (selectedprovider == 1) {
                  String username =
                      Provider.of<GlobalStatus>(context, listen: false)
                          .username;
                  String permission =
                      Provider.of<GlobalStatus>(context, listen: false)
                          .permission;
                    //TODO: Report for comment and tag
                  Chainactions()
                    ..setusernameandpermission(username, permission)
                    ..addreport(selectedusername, 1,uploadid, selectedrule,
                            reporttext)
                        .then((value) {
                      if (value) {
                        //OK
                        debugPrint("OK");
                        Globalnotifications.shownotification(
                            context,
                            AppLocalizations.of(context)!.thankyou,
                            AppLocalizations.of(context)!
                                .reportuploadedsuccessfully,
                            "success");
                        Navigator.pop(context);
                      } else {
                        //ERROR
                        debugPrint("ERROR");
                        Globalnotifications.shownotification(
                            context,
                            AppLocalizations.of(context)!.error,
                            AppLocalizations.of(context)!.reportuploadedfailed,
                            "error");
                      }
                    });
                } else {
                  ReportStatus reportStatus =
                      Provider.of<ReportStatus>(context, listen: false);
                  Chainactions()
                      .reportuploadwithcommunity(reportStatus)
                      .then((value) {
                    if (value) {
                      //OK
                      debugPrint("OK");
                      Globalnotifications.shownotification(
                          context,
                          AppLocalizations.of(context)!.thankyou,
                          AppLocalizations.of(context)!
                              .reportuploadedsuccessfully,
                          "success");
                      Navigator.pop(context);
                    } else {
                      debugPrint("ERROR");
                      Globalnotifications.shownotification(
                          context,
                          AppLocalizations.of(context)!.error,
                          AppLocalizations.of(context)!.reportuploadedfailed,
                          "error");
                    }
                  });
                }
              }
            } else {}
            Provider.of<ReportStatus>(context, listen: false).nextStep();
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: currentbuttoncolor(context),
            ),
            child: Column(
              children: [
                const Icon(Icons.navigate_next, color: Colors.white),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 8.0, left: 32.0, right: 32.0),
                  child: Provider.of<ReportStatus>(context).currentStep == 2
                      ? Text(AppLocalizations.of(context)!.send,
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white))
                      : Text(AppLocalizations.of(context)!.next,
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white)),
                )
              ],
            ),
          ),
        ),
      ),
    ]);
  }

  Color currentbuttoncolor(BuildContext context) {
    if (Provider.of<ReportStatus>(context).currentStep == 0) {
      if (Provider.of<ReportStatus>(context).selectedrule == -1) {
        return Colors.green.withAlpha((0.3 * 255).toInt());
      } else {
        return Colors.green;
      }
    } else if (Provider.of<ReportStatus>(context).currentStep == 1) {
      if (Provider.of<ReportStatus>(context).selectedprovider == -1) {
        return Colors.green.withAlpha((0.3 * 255).toInt());
      } else {
        return Colors.green;
      }
    } else if (Provider.of<ReportStatus>(context).currentStep == 2) {
      return Colors.green;
    } else {
      return Colors.green;
    }
  }
}

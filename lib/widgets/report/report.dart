import 'package:auto_size_text/auto_size_text.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/reportstatus.dart';
import 'package:fr0gsite/widgets/report/report1.dart';
import 'package:fr0gsite/widgets/report/report2.dart';
import 'package:fr0gsite/widgets/report/report3.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';

class Report extends StatefulWidget {
  final int id;
  final int type; // type of the report, 1 = upload, 2 = comment, 3 = tag
  const Report({super.key, required this.id, required this.type});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> with TickerProviderStateMixin {

  late final AnimationController controller = AnimationController(
    duration: const Duration(milliseconds: 5000),
    vsync: this,
  )..repeat(reverse: true);

  List<Widget> stepper = <Widget>[
    const Report1(),
    const Report2(),
    const Report3(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ReportStatus>(
        create: (context) => ReportStatus(widget.type, widget.id),
        builder: (context, child) {
          return Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.9 < 800
                  ? MediaQuery.of(context).size.height * 0.9
                  : 800,
              child: Material(
                  color: AppColor.nicegrey,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      side: BorderSide(color: Colors.white, width: 6)),
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    resizeToAvoidBottomInset: false,
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      title: AutoSizeText(
                        AppLocalizations.of(context)!.report,
                        style: const TextStyle(color: Colors.white),
                      ),
                      centerTitle: true,
                    ),
                    body: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight:
                            MediaQuery.of(context).size.height * 0.9 < 800
                                ? MediaQuery.of(context).size.height * 0.9
                                : 800,
                      ),
                      child: ListView(
                        children: [
                          stepper[
                              Provider.of<ReportStatus>(context).currentStep],
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: EasyStepper(
                                    finishedStepBackgroundColor: Colors.green,
                                    activeStepBackgroundColor: Colors.green,
                                    activeStep: Provider.of<ReportStatus>(
                                            context,
                                            listen: false)
                                        .currentStep,
                                    lineStyle: const LineStyle(
                                        lineType: LineType.dashed,
                                        defaultLineColor: Colors.white,
                                        lineThickness: 4),
                                    internalPadding: 0,
                                    showLoadingAnimation: false,
                                    showTitle: false,
                                    stepRadius: 12,
                                    showStepBorder: false,
                                    steps: [
                                      EasyStep(
                                        customStep: CircleAvatar(
                                          radius: 8,
                                          backgroundColor: Colors.white,
                                          child: CircleAvatar(
                                            radius: 7,
                                            backgroundColor:
                                                Provider.of<ReportStatus>(
                                                                context)
                                                            .currentStep >=
                                                        0
                                                    ? Colors.green
                                                    : Colors.white,
                                          ),
                                        ),
                                        title: 'Info',
                                      ),
                                      EasyStep(
                                        customStep: CircleAvatar(
                                          radius: 8,
                                          backgroundColor: Colors.white,
                                          child: CircleAvatar(
                                            radius: 7,
                                            backgroundColor:
                                                Provider.of<ReportStatus>(
                                                                context,
                                                                listen: false)
                                                            .currentStep >=
                                                        1
                                                    ? Colors.green
                                                    : Colors.white,
                                          ),
                                        ),
                                        title: '',
                                      ),
                                      EasyStep(
                                        customStep: CircleAvatar(
                                          radius: 8,
                                          backgroundColor: Colors.white,
                                          child: CircleAvatar(
                                            radius: 7,
                                            backgroundColor:
                                                Provider.of<ReportStatus>(
                                                                context,
                                                                listen: false)
                                                            .currentStep >=
                                                        2
                                                    ? Colors.green
                                                    : Colors.white,
                                          ),
                                        ),
                                        title: AppLocalizations.of(context)!
                                            .provider,
                                        topTitle: true,
                                      ),
                                    ],
                                    onStepReached: (index) {
                                      Provider.of<ReportStatus>(context,
                                              listen: false)
                                          .stepreached(index);
                                    }),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
          );
        });
  }
}

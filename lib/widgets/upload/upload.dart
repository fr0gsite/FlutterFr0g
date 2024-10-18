import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/uploadstatus.dart';
import 'package:fr0gsite/widgets/upload/uploadconfirm.dart';
import 'package:fr0gsite/widgets/upload/uploadscreen1.dart';
import 'package:fr0gsite/widgets/upload/uploadinformation.dart';
import 'package:fr0gsite/widgets/upload/uploadscreen3provider.dart';
import 'package:fr0gsite/widgets/upload/uploadscreen2requirements.dart';
import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Upload extends StatefulWidget {
  const Upload({super.key});

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  int activeStep = 0;
  List<Widget> stepper = <Widget>[
    const Expanded(child: UploadScreen1()),
    const Expanded(child: UploadScreen2requirements()),
    const Expanded(child: Uploadscreen3provider()),
    const Expanded(child: Uploadinformation()),
    const Expanded(child: Uploadconfirm()),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            color: Colors.black38,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        ChangeNotifierProvider<Uploadstatus>(
            create: (context) => Uploadstatus(),
            builder: (context, child) {
              return Center(
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: 500,
                    height: 800,
                    child: Material(
                        color: AppColor.nicegrey,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            side: BorderSide(
                              color: Colors.white,
                              width: 6,
                            )),
                        child: Scaffold(
                          backgroundColor: Colors.transparent,
                          resizeToAvoidBottomInset: true,
                          appBar: AppBar(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            leading: IconButton(
                              icon:
                                  const Icon(Icons.close, color: Colors.white),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          body: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              stepper[Provider.of<Uploadstatus>(context)
                                  .currentStep],
                              Column(
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Provider.of<Uploadstatus>(context)
                                                    .currentStep ==
                                                0
                                            ? Container()
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: TextButton(
                                                  onPressed: () {
                                                    Provider.of<Uploadstatus>(
                                                            context,
                                                            listen: false)
                                                        .previousStep();
                                                  },
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.red
                                                            .withOpacity(0.3),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 8.0,
                                                                bottom: 8.0,
                                                                left: 32.0,
                                                                right: 32.0),
                                                        child: Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .back,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    color: Colors
                                                                        .white)),
                                                      )),
                                                ),
                                              ),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: TextButton(
                                            onPressed: () {
                                              Provider.of<Uploadstatus>(context,
                                                      listen: false)
                                                  .nextStep(context);
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.green,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0,
                                                          bottom: 8.0,
                                                          left: 32.0,
                                                          right: 32.0),
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .next,
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white)),
                                                )),
                                          ),
                                        ),
                                      ]),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: EasyStepper(
                                        activeStep: Provider.of<Uploadstatus>(
                                                context,
                                                listen: false)
                                            .currentStep,
                                        activeStepTextColor: Colors.white,
                                        finishedStepBackgroundColor:
                                            Colors.transparent,
                                        finishedStepBorderColor:
                                            Colors.transparent,
                                        finishedStepIconColor:
                                            Colors.transparent,
                                        activeStepBackgroundColor:
                                            Colors.green.withOpacity(0.5),
                                        finishedStepTextColor: Colors.white,
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
                                                    Provider.of<Uploadstatus>(
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
                                                    Provider.of<Uploadstatus>(
                                                                    context,
                                                                    listen:
                                                                        false)
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
                                                    Provider.of<Uploadstatus>(
                                                                    context,
                                                                    listen:
                                                                        false)
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
                                          EasyStep(
                                            customStep: CircleAvatar(
                                              radius: 8,
                                              backgroundColor: Colors.white,
                                              child: CircleAvatar(
                                                radius: 7,
                                                backgroundColor:
                                                    Provider.of<Uploadstatus>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .currentStep >=
                                                            3
                                                        ? Colors.green
                                                        : Colors.white,
                                              ),
                                            ),
                                            title: AppLocalizations.of(context)!
                                                .upload,
                                          ),
                                          EasyStep(
                                            customStep: CircleAvatar(
                                              radius: 8,
                                              backgroundColor: Colors.white,
                                              child: CircleAvatar(
                                                radius: 7,
                                                backgroundColor:
                                                    Provider.of<Uploadstatus>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .currentStep >=
                                                            4
                                                        ? Colors.green
                                                        : Colors.white,
                                              ),
                                            ),
                                            title: AppLocalizations.of(context)!
                                                .confirm,
                                            topTitle: true,
                                          ),
                                        ],
                                        onStepReached: (index) {
                                          debugPrint("Reached step $index");
                                          Provider.of<Uploadstatus>(context,
                                                  listen: false)
                                              .newStep(index);
                                        }),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
              );
            }),
      ],
    );
  }
}

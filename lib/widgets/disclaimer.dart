import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/reportstatus.dart';
import 'package:fr0gsite/widgets/settings/setlanguageview.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class GlobalDisclaimer extends StatefulWidget {
  const GlobalDisclaimer({super.key});

  @override
  State<GlobalDisclaimer> createState() => _GlobalDisclaimerState();
}

class _GlobalDisclaimerState extends State<GlobalDisclaimer>
    with TickerProviderStateMixin {
  late AnimationController greetingAnimationController;
  late AnimationController pressAnimationController;
  bool showagreebutton = true;
  late Timer greetinganinationtimer;
  late Timer pressaninationtimer;
  double pressanimationrepeattimer = 6;
  TextStyle style = const TextStyle(
    color: Colors.white,
    fontSize: 15,
  );
  static double fontsizebutton = 15;
  static double iconsize = 30;

  String animationpath = 'assets/frog/27.json';
  String animationpath01 = 'assets/frog/27.json';
  String animationpath02 = 'assets/frog/39.json';
  Duration defaultduration = const Duration(milliseconds: 3000);

  @override
  void initState() {
    super.initState();
    greetingAnimationController = AnimationController(vsync: this);
    pressAnimationController = AnimationController(vsync: this);
    greetingAnimationController.duration = defaultduration;
    pressAnimationController.duration = defaultduration;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      greetingAnimationController.forward();
      pressAnimationController.forward();
    });
    greetinganinationtimer =
        Timer.periodic(const Duration(milliseconds: 8000), (timer) {
      if (mounted) {
        greetingAnimationController.reset();
        greetingAnimationController.forward();
      }
    });
    pressaninationtimer =
        Timer.periodic(const Duration(milliseconds: 10000), (timer) {
      if (mounted) {
        setState(() {
          showagreebutton = true;
        });
        pressAnimationController.reset();
        pressAnimationController.forward();
      }
      // showagreebutton false in 3 seconds
      Timer(const Duration(milliseconds: 3000), () {
        if (mounted) {
          setState(() {
            showagreebutton = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ChangeNotifierProvider<ReportStatus>(
        create: (context) => ReportStatus(),
        builder: (context, child) {
          return Center(
            child: SizedBox(
              width: 700,
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
                      title: AutoSizeText(
                        AppLocalizations.of(context)!.disclaimer,
                        style: const TextStyle(color: Colors.white),
                      ),
                      centerTitle: true,
                    ),
                    floatingActionButton: FloatingActionButton(
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.translate, size: 25, color: Colors.black),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) => const SetLanguageView());
                      },
                    ),
                    body: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: ScrollConfiguration(
                    
                        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                        child: ListView(
                          children: [
                            Center(
                              child: MouseRegion(
                                onEnter: (_) {
                                  setState(() {
                                    animationpath = animationpath02;
                                    greetingAnimationController.reset();
                                    //greetingAnimationController.forward();
                                  });
                                },
                                onExit: (_) {
                                  setState(() {
                                    animationpath = animationpath01;
                                    greetingAnimationController.reset();
                                    greetingAnimationController.duration =
                                        defaultduration;
                                    greetingAnimationController.forward();
                                  });
                                },
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (Provider.of<GlobalStatus>(context,
                                              listen: false)
                                          .audionotifications) {
                                        AudioPlayer audioPlayer = AudioPlayer();
                                        audioPlayer.play(
                                            DeviceFileSource(
                                                "assets/sounds/boing.mp3"),
                                            volume: 0.5,
                                            mode: PlayerMode.lowLatency);
                                      }
                        
                                      animationpath = animationpath02;
                                      greetingAnimationController.reset();
                                      greetingAnimationController.duration =
                                          const Duration(milliseconds: 500);
                                      greetingAnimationController.forward();
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Lottie.asset(
                                      animationpath,
                                      height: 150,
                                      width: 150,
                                      controller: greetingAnimationController,
                                      onLoaded: (composition) {
                                        greetingAnimationController.duration =
                                            composition.duration;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              runAlignment: WrapAlignment.center,
                              alignment: WrapAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    launchUrl(Uri.parse(urltoandroidapp));
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all(Colors.white),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.android,
                                          color: Colors.green, size: iconsize),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text("Android",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: fontsizebutton)),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    launchUrl(Uri.parse(urltoiosapp));
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all(Colors.white),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.apple,
                                          color: Colors.black, size: iconsize),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text("Apple",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: fontsizebutton)),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    launchUrl(Uri.parse(urltowindowsapp));
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all(Colors.white),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.window_sharp,
                                          color: Colors.blue, size: iconsize),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text("Windows",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: fontsizebutton)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 10,
                            ),
                            agreebutton(),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: SizedBox(
                                width: 500,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                        AppLocalizations.of(context)!.disclaimer1,
                                        style: style),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    AutoSizeText(
                                        AppLocalizations.of(context)!.disclaimer2,
                                        style: style),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    AutoSizeText(
                                        AppLocalizations.of(context)!.disclaimer3(
                                            AppLocalizations.of(context)!.iagree),
                                        style: style),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    AutoSizeText(
                                        AppLocalizations.of(context)!.disclaimer4(
                                            AppLocalizations.of(context)!.iagree),
                                        style: style),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    AutoSizeText(
                                        AppLocalizations.of(context)!.disclaimer5,
                                        style: style),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        spacing: 10,
                                        runSpacing: 10,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              launchUrl(
                                                  Uri.parse(Documentation.rules));
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.rule,
                                                    color: Colors.black,
                                                    size: iconsize),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                    AppLocalizations.of(context)!
                                                        .rulesandguidelines,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize:
                                                            fontsizebutton)),
                                              ],
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              launchUrl(Uri.parse(githuburl));
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.cloud_circle_sharp,
                                                    color: Colors.black,
                                                    size: iconsize),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text("Github",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize:
                                                            fontsizebutton)),
                                              ],
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              launchUrl(
                                                  Uri.parse(Documentation.url));
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.cloud_circle_sharp,
                                                    color: Colors.black,
                                                    size: iconsize),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                    AppLocalizations.of(context)!
                                                        .documentation,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize:
                                                            fontsizebutton)),
                                              ],
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              launchUrl(Uri.parse(whitepaperurl));
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.document_scanner,
                                                    color: Colors.black,
                                                    size: iconsize),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text("Whitepaper",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize:
                                                            fontsizebutton)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            agreebutton(),
                          ],
                        ),
                      ),
                    )),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget agreebutton() {
    return Align(
      alignment: Alignment.center,
      child: Stack(
        children: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.green),
            ),
            onPressed: () {
              Provider.of<GlobalStatus>(context, listen: false)
                  .localuserconfig
                  .acceptdisclaimer();
              Navigator.pop(context, true);
            },
            child: AutoSizeText(AppLocalizations.of(context)!.iagree,
                style:
                    TextStyle(color: Colors.white, fontSize: fontsizebutton)),
          ),
          Visibility(
            visible: showagreebutton,
            replacement: const SizedBox(height: 60, width: 60),
            child: Lottie.asset('assets/lottie/press.json',
                height: 60, width: 60, controller: pressAnimationController),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    greetingAnimationController.dispose();
    pressAnimationController.dispose();
    greetinganinationtimer.cancel();
    super.dispose();
  }
}

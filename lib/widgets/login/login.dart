import 'package:fr0gsite/widgets/login/loginwithfile.dart';
import 'package:fr0gsite/widgets/login/loginwithqrcode.dart';
import 'package:fr0gsite/widgets/login/loginwithtext.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../config.dart';

// https://pub.dev/packages/percent_indicator

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> with TickerProviderStateMixin {
  late final AnimationController _controller;
  String lottiefile = 'assets/frog/44.json';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  int tabindex = 0;

  void feedback(String key) {
    if (key == 'username') {
      setState(() {
        lottiefile = 'assets/frog/25.json';
      });
      _controller.reset();
      _controller.forward();
    }
    if (key == 'privatekey') {
      setState(() {
        //Close eye
        lottiefile = 'assets/frog/30.json';
      });
      _controller.reset();
      _controller.forward();
      _controller.addListener(() {
        if (_controller.value >= 0.5) {
          _controller.stop();
        }
      });
    }
    if (key == 'wrongprivatekey') {
      setState(() {
        lottiefile = 'assets/frog/13.json';
      });
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> loginmethods = [
      Loginwithtext(feedback: feedback),
      const Loginwithfile(),
      const Loginwithqrcode()
    ];

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
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 800),
            child: Material(
                color: AppColor.nicegrey,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    side: BorderSide(color: Colors.white, width: 6)),
                child: AutofillGroup(
                    child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: Text(
                      AppLocalizations.of(context)!.login,
                      style: const TextStyle(color: Colors.white),
                    ),
                    leading: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    centerTitle: true,
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: Lottie.asset(lottiefile,
                              controller: _controller, onLoaded: (composition) {
                            _controller.duration = composition.duration;
                            _controller.addListener(() {
                              if (_controller.value >= 0.5) {
                                _controller.stop();
                              }
                            });
                            _controller.forward();
                          }),
                        ),
                        const SizedBox(height: 25),
                        //Center(
                        //  child: SegmentedButton(
                        //    multiSelectionEnabled: false,
                        //    selectedIcon: const Icon(
                        //      Icons.check,
                        //      color: Colors.green,
                        //    ),
                        //    style: ButtonStyle(
                        //      backgroundColor:
                        //          WidgetStateProperty.all<Color>(Colors.white),
                        //      foregroundColor:
                        //          WidgetStateProperty.all<Color>(Colors.black),
                        //      overlayColor:
                        //          WidgetStateProperty.all<Color>(Colors.green),
                        //      shadowColor:
                        //          WidgetStateProperty.all<Color>(Colors.black),
                        //      elevation: WidgetStateProperty.all<double>(0.0),
                        //      padding:
                        //          WidgetStateProperty.all<EdgeInsetsGeometry>(
                        //              const EdgeInsets.all(10.0)),
                        //      shape: WidgetStateProperty.all<OutlinedBorder>(
                        //          RoundedRectangleBorder(
                        //              borderRadius:
                        //                  BorderRadius.circular(10.0))),
                        //    ),
                        //    selected: {tabindex},
                        //    segments: [
                        //      ButtonSegment(
                        //          value: 0,
                        //          label: Text(AppLocalizations.of(context)!
                        //              .loginnamekey)),
                        //      ButtonSegment(
                        //          value: 1,
                        //          label: Text(
                        //              AppLocalizations.of(context)!.loginfile)),
                        //      ButtonSegment(
                        //          value: 2,
                        //          label: Text(AppLocalizations.of(context)!
                        //              .loginqrcode)),
                        //    ],
                        //    onSelectionChanged: (p0) {
                        //      setState(() {
                        //        tabindex = p0.first;
                        //        debugPrint('tabindex: $tabindex');
                        //      });
                        //    },
                        //  ),
                        //),
                        const SizedBox(height: 20),
                        loginmethods[tabindex],
                      ],
                    ),
                  ),
                ))),
          ),
        )
      ],
    );
  }

  Widget loginwithFileupload() {
    return Container();
  }

  Widget loginwithQRCode() {
    return Container();
  }
}

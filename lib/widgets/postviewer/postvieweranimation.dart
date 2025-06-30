import 'package:auto_size_text/auto_size_text.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';

class PostViewerAnimation extends StatefulWidget {
  const PostViewerAnimation({super.key});

  @override
  State<PostViewerAnimation> createState() => _PostViewerAnimationState();
}

class _PostViewerAnimationState extends State<PostViewerAnimation>
    with TickerProviderStateMixin {
  bool showswiper = false;
  bool showkeyboard = false;
  bool showmousescroll = false;

  AnimationController? lottieanimationcontrollerswiper;
  AnimationController? lottieanimationcontrollerkeyboard;
  AnimationController? lottieanimationcontrollermousescroll;

  final double textbackgroundopacity = 0.9;
  final double minFontSize = 20.0;

  @override
  void initState() {
    super.initState();
    lottieanimationcontrollerswiper = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    lottieanimationcontrollerkeyboard = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    lottieanimationcontrollermousescroll = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Which Plattform is used?
    Platformdetectionstatus platform =
        Provider.of<GlobalStatus>(context, listen: false).platform;

    if (platform == Platformdetectionstatus.android ||
        platform == Platformdetectionstatus.ios) {
      showswiper = true;
      showkeyboard = false;
      showmousescroll = false;
    } else {
      showswiper = true;
      showkeyboard = true;
      showmousescroll = true;
    }

    lottieanimationcontrollerswiper?.addListener(
      () {
        if (lottieanimationcontrollerswiper!.isCompleted) {
          // hide swiper
          setState(() {
            showswiper = false;
            if (showkeyboard) {
              lottieanimationcontrollerkeyboard?.forward();
            }
          });
        }
      },
    );

    lottieanimationcontrollerkeyboard?.addListener(
      () {
        if (lottieanimationcontrollerkeyboard!.isCompleted) {
          // hide keyboard
          setState(() {
            showkeyboard = false;
            if (showmousescroll) {
              lottieanimationcontrollermousescroll?.forward();
            }
          });
        }
      },
    );

    lottieanimationcontrollermousescroll?.addListener(
      () {
        if (lottieanimationcontrollermousescroll!.isCompleted) {
          // hide mousescroll
          setState(() {
            showmousescroll = false;
          });
        }
      },
    );

    if (!(Provider.of<GlobalStatus>(context, listen: false)
        .showedPostViewerFirstAnimation)) {
      lottieanimationcontrollerswiper?.forward();
      Provider.of<GlobalStatus>(context, listen: false)
          .showedPostViewerFirstAnimation = true;
    } else {
      showswiper = false;
      showkeyboard = false;
      showmousescroll = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return showswiper
        ? buildswipe()
        : showkeyboard
            ? buildkeyboard()
            : showmousescroll
                ? buildmousescroll()
                : Container();
  }

  Widget buildswipe() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        color: Colors.grey.withAlpha((textbackgroundopacity * 255).toInt()),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AutoSizeText(AppLocalizations.of(context)!.swipe,
              style: const TextStyle(color: Colors.white),
              minFontSize: minFontSize),
        ),
      ),
      Lottie.asset(
        'assets/lottie/swipedown.json',
        controller: lottieanimationcontrollerswiper,
        fit: BoxFit.fill,
        height: MediaQuery.of(context).size.height * 0.5,
      ),
    ]);
  }

  Widget buildkeyboard() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        color: Colors.grey.withAlpha((textbackgroundopacity * 255).toInt()),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AutoSizeText(AppLocalizations.of(context)!.arrowkeys,
              style: const TextStyle(color: Colors.white),
              minFontSize: minFontSize),
        ),
      ),
      Lottie.asset(
        'assets/lottie/keyboardupdown.json',
        controller: lottieanimationcontrollerkeyboard,
        fit: BoxFit.fill,
        height: MediaQuery.of(context).size.height * 0.3,
      ),
    ]);
  }

  Widget buildmousescroll() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        color: Colors.grey.withAlpha((textbackgroundopacity * 255).toInt()),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AutoSizeText(AppLocalizations.of(context)!.mousescroll,
              style: const TextStyle(color: Colors.white),
              minFontSize: minFontSize),
        ),
      ),
      Lottie.asset(
        'assets/lottie/mousescroll.json',
        controller: lottieanimationcontrollermousescroll,
        fit: BoxFit.fill,
        height: MediaQuery.of(context).size.height * 0.3,
      )
    ]);
  }

  @override
  void dispose() {
    lottieanimationcontrollerswiper?.dispose();
    lottieanimationcontrollerkeyboard?.dispose();
    lottieanimationcontrollermousescroll?.dispose();
    super.dispose();
  }
}

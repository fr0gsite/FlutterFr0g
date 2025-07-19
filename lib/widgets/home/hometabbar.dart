import 'dart:async';

import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';

class HomeTabBar extends StatefulWidget {
  const HomeTabBar({super.key, required this.controller});
  final TabController controller;
  @override
  State<HomeTabBar> createState() => _HomeTabBarState();
}

class _HomeTabBarState extends State<HomeTabBar> with TickerProviderStateMixin {
  late AnimationController _controller;
  bool animationisPlaying = false;
  Timer? timer5000;

  bool showanimation = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.duration = const Duration(milliseconds: 3000);
    playAnimation();
    timer5000 = Timer.periodic(const Duration(seconds: 7), (timer) {
      if (!animationisPlaying) {
        playAnimation();
      }
    });
  }

  void playAnimation() async {
    if (!animationisPlaying) {
      animationisPlaying = true;
      _controller.reset();
      await _controller.forward();
      animationisPlaying = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (getPlatform(context) == Platformdetectionstatus.web &&
        MediaQuery.of(context).size.width < AppConfig.thresholdValueForMobileLayout) {
      showanimation = false;
    }

    return TabBar(
          controller: widget.controller,
          onTap: (value) {
            setState(() {
              playAnimation();
            });
          },
          dividerColor: Colors.transparent,
          unselectedLabelColor: Colors.grey[500],
          indicator: gloabltabindicator,
          indicatorSize: TabBarIndicatorSize.tab,
          padding: const EdgeInsets.all(5),
          tabs: [
            Column(
              // alignment: Alignment.topCenter,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                showanimation
                    ? Lottie.asset(
                  'assets/lottie/mixer.json',
                  controller: _controller,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  repeat: false,
                )
                    : Container(),
                Tab(
                  text: AppLocalizations.of(context)!.categorymixed,
                ),
              ],
            ),
            Column(
              // alignment: Alignment.topCenter,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                showanimation
                    ? Lottie.asset(
                  'assets/lottie/trophy.json',
                  controller: _controller,
                  width: 45,
                  height: 45,
                  fit: BoxFit.cover,
                  repeat: false,
                )
                    : Container(),

                Tab(
                  text: AppLocalizations.of(context)!.categorypopular,
                ),
              ],
            ),
            Column(
              // alignment: Alignment.topCenter,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                showanimation
                    ? Lottie.asset(
                  'assets/lottie/up.json',
                  controller: _controller,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  repeat: false,
                )
                    : Container(),
                Tab(
                  text: AppLocalizations.of(context)!.trends,
                ),
              ],
            ),
            Column(
              // alignment: Alignment.topCenter,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                showanimation
                    ? Lottie.asset(
                  'assets/lottie/newuploads.json',
                  controller: _controller,
                  height: 40,
                  width: 40,
                  repeat: false,
                )
                    : Container(),
                Tab(
                  text: AppLocalizations.of(context)!.categorynew,
                ),
              ],
            ),
          ],
          labelColor: Colors.white,
    );
  }

  @override
  void dispose() {
    timer5000?.cancel();
    _controller.dispose();
    super.dispose();
  }
}

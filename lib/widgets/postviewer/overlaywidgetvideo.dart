import 'package:fr0gsite/widgets/postviewer/soundbar.dart';
import 'package:fr0gsite/widgets/postviewer/videoprocessIndicatorview.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class OverlayWidgetVideo extends StatefulWidget {
  const OverlayWidgetVideo({super.key, required this.controller});

  final VideoPlayerController controller;

  @override
  State<OverlayWidgetVideo> createState() => _OverlayWidgetVideoState();
}

class _OverlayWidgetVideoState extends State<OverlayWidgetVideo> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          setState(() {
            widget.controller.value.isPlaying
                ? widget.controller.pause()
                : widget.controller.play();
          });
        },
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              playIcon(),
              Positioned(
                  bottom: 0,
                  left: 100,
                  right: 80,
                  child: VideoProcessIndicatorView(
                      controller: widget.controller, allowScrubbing: true)),
              Positioned(
                  bottom: 100,
                  left: 0,
                  child: SoundBar(controller: widget.controller)),
            ],
          ),
        ));
  }

  Widget playIcon() => widget.controller.value.isPlaying
      ? Container()
      : Center(
          child: Lottie.asset(
          'assets/lottie/paused.json',
          width: 300,
          height: 300,
          fit: BoxFit.fill,
          repeat: false,
        ));
}

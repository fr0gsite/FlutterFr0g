import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoProcessIndicatorView extends StatefulWidget {
  const VideoProcessIndicatorView(
      {super.key, required this.controller, required this.allowScrubbing});
  final VideoPlayerController controller;
  final bool allowScrubbing;

  @override
  State<VideoProcessIndicatorView> createState() =>
      _VideoProcessIndicatorViewState();
}

class _VideoProcessIndicatorViewState extends State<VideoProcessIndicatorView> {
  bool hide = true;
  DateTime lastactiveTime = DateTime.now();
  late Timer timer;

  void setTimer() {
    timer = Timer(const Duration(seconds: 3), () {
      if (DateTime.now().difference(lastactiveTime).inSeconds >= 3) {
        if (mounted) {
          setState(() {
            hide = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: !hide ? 30 : 15,
      child: MouseRegion(
        onHover: (event) {
          setState(() {
            hide = false;
          });
          lastactiveTime = DateTime.now();
          setTimer();
        },
        child: VideoProgressIndicator(
          widget.controller,
          allowScrubbing: true,
          colors: VideoProgressColors(
            playedColor: !hide ? Colors.red : Colors.red.withOpacity(0.3),
            bufferedColor: !hide
                ? Colors.white.withOpacity(0.5)
                : Colors.white.withOpacity(0.1),
            backgroundColor: !hide
                ? Colors.white.withOpacity(0.2)
                : Colors.white.withOpacity(0.1),
          ),
        ),
      ),
    );
  }
}

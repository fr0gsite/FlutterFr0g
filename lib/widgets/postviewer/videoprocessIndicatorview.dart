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
  late Timer durationTimer;

  void setTimer() {
    timer = Timer(const Duration(seconds: 3), () {
      if (DateTime.now().difference(lastactiveTime).inSeconds >= 3) {
        if (mounted) {
          setState(() {
            hide = true;
          });
        }
      }
    },
    );
  }



  @override
  void initState() {
    super.initState();
    durationTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (widget.controller.value.isPlaying) {
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 10,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: !hide ? 35 : 15,
            child: Center(
              // In Style MM:SS / MM:SS
              child: Text(
                '${widget.controller.value.position.inMinutes.toString().padLeft(2, '0')}:${widget.controller.value.position.inSeconds.remainder(60).toString().padLeft(2, '0')} / ${widget.controller.value.duration.inMinutes.toString().padLeft(2, '0')}:${widget.controller.value.duration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                style:  TextStyle(color: Colors.white, fontSize: !hide ? 25 : 14),
              ),
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: !hide ? 35 : 15,
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
                playedColor: !hide ? Colors.red.withAlpha((0.7 * 255).toInt()) : Colors.red.withAlpha((0.3 * 255).toInt()),
                bufferedColor: !hide
                    ? Colors.white.withAlpha((0.5 * 255).toInt())
                    : Colors.white.withAlpha((0.1 * 255).toInt()),
                backgroundColor: !hide
                    ? Colors.white.withAlpha((0.2 * 255).toInt())
                    : Colors.white.withAlpha((0.1 * 255).toInt()),
              ),
            ),
          ),
        ),        
      ],
    );
  }
}

import 'package:fr0gsite/datatypes/postviewerstatus.dart';
import 'package:fr0gsite/widgets/postviewer/soundbar.dart';
import 'package:fr0gsite/widgets/postviewer/videoprocessIndicatorview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          setState(() {
            if(widget.controller.value.isPlaying){
              widget.controller.pause();
              Provider.of<PostviewerStatus>(context, listen: false).pause();
            } else{
              widget.controller.play();
              Provider.of<PostviewerStatus>(context, listen: false).resume();
            }
                
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
        ),
      );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget playIcon() => widget.controller.value.isPlaying
      ? Container()
      : Center(
            child: Image.asset(
            'assets/images/paused.png',
            width: 150,
            height: 150,
            fit: BoxFit.fill,
          ),
        );
}

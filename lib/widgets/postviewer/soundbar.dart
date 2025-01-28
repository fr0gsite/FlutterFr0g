import 'dart:async';

import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/slider_step.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:fr0gsite/datatypes/postviewerstatus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class SoundBar extends StatefulWidget {
  const SoundBar({super.key, required this.controller});

  final VideoPlayerController controller;

  @override
  State<SoundBar> createState() => _SoundBarState();
}

class _SoundBarState extends State<SoundBar> {
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
    return Consumer<PostviewerStatus>(
        builder: (context, postviewerstatus, child) {
      //widget.controller.setVolume(postviewerstatus.soundvolume);
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: !hide ||
                    Provider.of<PostviewerStatus>(context, listen: true).soundvolume == 0
                ? 150
                : 150,
            child: MouseRegion(
              onHover: (event) {
                setState(() {
                  hide = false;
                });
                lastactiveTime = DateTime.now();
                setTimer();
              },
              child: FlutterSlider(
                axis: Axis.vertical,
                step: const FlutterSliderStep(step: 0.1),
                values: [postviewerstatus.soundvolume],
                max: 1,
                min: 0,
                rtl: true,
                trackBar: FlutterSliderTrackBar(
                  activeTrackBarHeight: 15,
                  inactiveTrackBarHeight: 15,
                  activeTrackBar: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: !hide ? Colors.white : Colors.white.withAlpha((0.3 * 255).toInt()),
                  ),
                  inactiveTrackBar: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: !hide ? Colors.grey : Colors.grey.withAlpha((0.3 * 255).toInt()),
                  ),
                ),
                handler: FlutterSliderHandler(
                  decoration: const BoxDecoration(),
                  child: !hide
                      ? Container(
                          decoration: BoxDecoration(
                            color: !hide
                                ? Colors.white.withAlpha((0.6 * 255).toInt())
                                : Colors.white.withAlpha((0.1 * 255).toInt()),
                            shape: BoxShape.circle,
                          ),
                        )
                      : Container(),
                ),
                onDragging: (handlerIndex, lowerValue, upperValue) {
                  widget.controller.setVolume(lowerValue);
                  //postviewerstatus.soundvolume = lowerValue;
                  postviewerstatus.setsoundvolume(lowerValue);
                },
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Provider.of<PostviewerStatus>(context, listen: true).soundvolume == 0
                  ? Icons.volume_off
                  : Icons.volume_up,
              color: !hide ||
                      Provider.of<PostviewerStatus>(context, listen: true)
                              .soundvolume ==
                          0
                  ? Colors.white
                  : Colors.white.withAlpha((0.3 * 255).toInt()),
              size: 30,
            ),
            onPressed: () {
              setState(() {
                widget.controller
                    .setVolume(widget.controller.value.volume == 0 ? 0.5 : 0);

                postviewerstatus.soundvolume == 0
                    ? postviewerstatus.setsoundvolume(0.5)
                    : postviewerstatus.setsoundvolume(0);
              });
            },
          ),
        ],
      );
    });
  }
}

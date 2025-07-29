import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SpeedDropdown extends StatefulWidget {
  final VideoPlayerController controller;
  const SpeedDropdown({super.key, required this.controller});

  @override
  State<SpeedDropdown> createState() => _SpeedDropdownState();
}

class _SpeedDropdownState extends State<SpeedDropdown> {
  // List of possible playback speeds
  final List<double> _speeds = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];

  // Currently selected speed
  late double _selectedSpeed;

  @override
  void initState() {
    super.initState();
    _selectedSpeed = widget.controller.value.playbackSpeed;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withAlpha((0.6 * 255).toInt()),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<double>(
          dropdownColor: Colors.black87,
          style: const TextStyle(color: Colors.white),
          icon: const Icon(Icons.speed, color: Colors.white),
          iconEnabledColor: Colors.white, 
          value: _selectedSpeed,
          items: _speeds.map((speed) {
            return DropdownMenuItem<double>(
              value: speed,
              child: Text(
                speed.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            //if (newValue == null) return;
            //if (newValue < 0.25) newValue = 0.25;
            //if (newValue > 2.0) newValue = 2.0;
            //setState(() {
            //  _selectedSpeed = newValue!;
            //});
            //widget.controller.setPlaybackSpeed(newValue);
            
          },
        ),
      ),
    );
  }
}

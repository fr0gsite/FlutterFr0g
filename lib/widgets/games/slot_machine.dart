import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fr0gsite/config.dart';

class SlotMachine extends StatefulWidget {
  const SlotMachine({super.key});

  @override
  State<SlotMachine> createState() => _SlotMachineState();
}

class _SlotMachineState extends State<SlotMachine>
    with SingleTickerProviderStateMixin {
  static const List<String> _symbols = ['🍒', '🍋', '🔔', '💎', '7️⃣'];
  final List<int> _reels = [0, 0, 0];
  bool _spinning = false;
  late final AnimationController _leverController;
  late final Animation<double> _leverAnimation;

  @override
  void initState() {
    super.initState();
    _leverController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _leverAnimation = Tween(begin: 0.0, end: 0.8).animate(
        CurvedAnimation(parent: _leverController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _leverController.dispose();
    super.dispose();
  }

  Future<void> _pullLever() async {
    if (_spinning) return;
    _leverController.forward().then((_) => _leverController.reverse());
    _spinning = true;
    setState(() {});
    AudioPlayer().play(AssetSource('sounds/boing.mp3'));
    _startSpin();
  }

  void _startSpin() {
    AudioPlayer().play(AssetSource('sounds/wow.m4a'));
    for (int i = 0; i < _reels.length; i++) {
      Future.delayed(Duration(milliseconds: 200 * i), () {
        _spinReel(i);
      });
    }
    Future.delayed(const Duration(seconds: 2), _finishSpin);
  }

  void _spinReel(int index) {
    final random = Random();
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!_spinning) {
        timer.cancel();
      } else {
        setState(() {
          _reels[index] = random.nextInt(_symbols.length);
        });
      }
    });
  }

  void _finishSpin() {
    _spinning = false;
    setState(() {});
    if (_reels[0] == _reels[1] && _reels[1] == _reels[2]) {
      final winnings = ['cash1.m4a', 'cash2.m4a', 'cash3.m4a'];
      final choice = winnings[Random().nextInt(winnings.length)];
      AudioPlayer().play(AssetSource('sounds/' + choice));
    } else {
      AudioPlayer().play(AssetSource('sounds/fail.m4a'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.nicegrey,
      appBar: AppBar(
        title: const Text('How Lucky'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/games/howlucky/automate.png'),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(3, (i) => _buildReel(_reels[i])),
              const SizedBox(width: 40),
              _buildLever(),
            ],
          ),
        ),
        ]
      ),
    );
  }

  Widget _buildReel(int value) {
    return Container(
      margin: const EdgeInsets.all(8),
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        _symbols[value],
        style: const TextStyle(fontSize: 40),
      ),
    );
  }

  Widget _buildLever() {
    return GestureDetector(
      onTap: _pullLever,
      child: AnimatedBuilder(
        animation: _leverAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _leverAnimation.value,
            alignment: Alignment.bottomCenter,
            child: child,
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                  color: Colors.red, shape: BoxShape.circle),
            ),
            Container(
              width: 8,
              height: 120,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}


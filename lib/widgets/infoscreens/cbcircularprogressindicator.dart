import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CBCircularProgressIndicator extends StatelessWidget {
  const CBCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/lottie/world.json',
      height: 50,
      width: 50,
    );
  }
}

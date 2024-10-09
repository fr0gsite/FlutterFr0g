import 'dart:math';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CubeLoading extends StatefulWidget {
  const CubeLoading({super.key});

  @override
  State<CubeLoading> createState() => _CubeLoadingState();
}

class _CubeLoadingState extends State<CubeLoading>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(seconds: 5), vsync: this, upperBound: 0.3)
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    String returnstring = 'assets/frogwebp/${Random().nextInt(104)}.webp';

    //Return Random Image from 'assets/frogwebp/'

    return Stack(children: [
      Image.asset(
        returnstring,
        opacity: _controller,
      ),
      Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            AppLocalizations.of(context)!.loading,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      )
    ]);
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }
}

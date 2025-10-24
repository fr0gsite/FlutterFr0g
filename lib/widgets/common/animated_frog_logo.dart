import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Animated Frog Logo with predefined frog animations
class AnimatedFrogLogo extends StatefulWidget {
  final double width;
  final double height;

  const AnimatedFrogLogo({super.key, this.width = 50, this.height = 50});

  @override
  State<AnimatedFrogLogo> createState() => _AnimatedFrogLogoState();
}

class _AnimatedFrogLogoState extends State<AnimatedFrogLogo>
    with TickerProviderStateMixin {
  late AnimationController _swayController;
  late Animation<double> _swayAnimation;
  late Timer _switchTimer;
  late Random _random;

  int _currentFrogIndex = 0;

  static const List<int> _selectedFrogs = [32, 42, 28, 25, 20, 29, 8, 6];

  @override
  void initState() {
    super.initState();

    // Initialize random number generator
    _random = Random();

    _swayController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _swayAnimation = Tween<double>(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(parent: _swayController, curve: Curves.easeInOut),
    );

    _swayController.repeat(reverse: true);

    // Timer for random frog switching every 10 seconds
    _switchTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        setState(() {
          // Select a random frog from the list
          _currentFrogIndex = _random.nextInt(_selectedFrogs.length);
        });
      }
    });
  }

  @override
  void dispose() {
    _swayController.dispose();
    _switchTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _swayAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _swayAnimation.value,
          child: Container(
            width: widget.width,
            height: widget.height,
            child: _buildCurrentFrog(),
          ),
        );
      },
    );
  }

  /// Builds the current frog widget
  Widget _buildCurrentFrog() {
    final currentFrog = _selectedFrogs[_currentFrogIndex];
    final assetPath = 'assets/frog/$currentFrog.json';

    return Lottie.asset(
      assetPath,
      width: widget.width,
      height: widget.height,
      fit: BoxFit.contain,
      repeat: true,
      animate: true,
      errorBuilder: (context, error, stackTrace) {
        // Fallback on error: Show static logo
        debugPrint('Error loading frog animation $assetPath: $error');
        return Image.asset(
          "assets/images/logo_g.png",
          width: widget.width,
          height: widget.height,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Last fallback: Simple green circle
            return Container(
              width: widget.width,
              height: widget.height,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
              child: const Icon(Icons.pets, color: Colors.white, size: 30),
            );
          },
        );
      },
    );
  }
}

/// Smaller variant for navigation and other areas
class AnimatedFrogLogoSmall extends StatelessWidget {
  const AnimatedFrogLogoSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnimatedFrogLogo(width: 30, height: 30);
  }
}

/// Larger variant for header
class AnimatedFrogLogoLarge extends StatelessWidget {
  const AnimatedFrogLogoLarge({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnimatedFrogLogo(width: 60, height: 60);
  }
}

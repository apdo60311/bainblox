import 'package:brain_blox/presentaition/screens/calender_screen/calendar_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_animate/flutter_animate.dart';

class SplashScreen extends StatefulWidget {
  final String nextScreen;

  const SplashScreen({Key? key, required this.nextScreen}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _scaleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    );

    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacementNamed(widget.nextScreen);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Image.asset(
                'assets/images/logo.png',
                width: 120,
                height: 120,
              )
                  .animate(
                      onPlay: (controller) => controller.repeat(reverse: true))
                  .scale(
                      begin: const Offset(0.7, 0.7),
                      end: const Offset(1, 1),
                      duration: Durations.long4),
            ),
            const SizedBox(height: 30),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: const [
                        Color(0xfffcc99b),
                        Color(0xFFF5821F),
                        Color(0xFF5e7c9e),
                        Color(0xFF004B76),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      transform:
                          GradientRotation(_controller.value * 2 * 3.14159),
                    ).createShader(bounds);
                  },
                  child: const Text(
                    'BrainBlox',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

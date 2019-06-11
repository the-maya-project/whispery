import 'package:flutter/material.dart';

/// Placeholder splash screen for authentication during BLoC logic.
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset("assets/images/splash_screen_bird.png")),
    );
  }
}

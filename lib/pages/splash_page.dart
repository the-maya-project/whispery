import 'package:flutter/material.dart';

/// Placeholder splash screen for authentication during BLoC logic.
class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(120.0),
        child: Center(
          child: Image.asset("assets/images/splash_screen_bird.png"),
        ),
      ),
    );
  }
}

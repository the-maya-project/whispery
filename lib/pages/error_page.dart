import 'package:flutter/material.dart';
import 'package:whispery/globals/strings.dart';

/// Placeholder splash screen for authentication during BLoC logic.
class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(120.0),
        child: Center(
          child: Text(Strings.errorMesage),
        ),
      ),
    );
  }
}

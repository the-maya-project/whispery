import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(15.0),
      padding: EdgeInsets.all(15.0),
      child: LinearProgressIndicator(
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Buttons {
  Widget textButton(VoidCallback action, String description) {
    return Container(
      padding: EdgeInsets.all(10),
      child: RaisedButton(
        child: SizedBox(
          width: double.infinity,
          child: Text(
            description,
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: () => action,
      ),
    );
  }
}

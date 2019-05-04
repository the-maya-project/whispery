import 'package:flutter/material.dart';

/// Library class encapulsating all button-based widgets.
class Buttons {
  /// Template for standard text button.
  /// Button take up full width of parent by convention.
  Widget textButton(VoidCallback action, String text) {
    return Container(
      padding: EdgeInsets.all(20),
      child: RaisedButton(
        child: SizedBox(
          width: double.infinity,
          child: Text(
            text,
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: () => action,
      ),
    );
  }

  /// Template for standard icon button.
  /// Button take up full width of parent by convention.
  Widget iconButton(VoidCallback action, var icon) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(20),
      child: RaisedButton(
        child: SizedBox(
          child: Icon(icon),
        ),
        onPressed: () => action,
      ),
    );
  }

  /// Template for standard text button.
  /// Buttons take up full width of parent by convention.
  Widget switchButton(VoidCallback action, bool state) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Switch(
        value: state,
        onChanged: (e) => action,
      ),
    );
  }
}

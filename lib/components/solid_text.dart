import 'package:flutter/material.dart';

class SolidText extends StatelessWidget {
  final String _title;
  final TextAlign _textAlign;
  final double _size = 32.0;

  SolidText({Key key, @required String title, @required textAlign})
      : _title = title,
        _textAlign = textAlign,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Text(
        _title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: _size,
        ),
        textAlign: _textAlign,
      ),
    );
  }
}

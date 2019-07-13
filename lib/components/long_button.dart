import 'package:flutter/material.dart';

class LongButton extends StatelessWidget {
  final String _text;
  final double _size = 16.0;

  LongButton({Key key, @required String text})
      : _text = text,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(15.0),
      padding: EdgeInsets.all(15.0),
      child: RaisedButton(
        child: Text(_text),
        onPressed: () => null,
      ),
    );
  }
}

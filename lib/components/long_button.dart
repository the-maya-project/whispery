import 'package:flutter/material.dart';

class LongButton extends StatelessWidget {
  final String _text;
  final VoidCallback _onPressed;

  LongButton({Key key, @required String text, @required VoidCallback onPressed})
      : _text = text,
        _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(15.0),
      padding: EdgeInsets.all(15.0),
      child: RaisedButton(
        child: Text(_text),
        onPressed: _onPressed,
      ),
    );
  }
}

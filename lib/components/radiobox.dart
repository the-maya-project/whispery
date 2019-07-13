import 'package:flutter/material.dart';

class RadioBox extends StatefulWidget {
  final String _text;

  RadioBox({Key key, @required String text})
      : _text = text,
        super(key: key);

  State<RadioBox> createState() => _RadioBoxState();
}

class _RadioBoxState extends State<RadioBox> {
  bool booleanValue = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.all(15.0),
      // padding: EdgeInsets.all(15.0),
      child: CheckboxListTile(
        value: booleanValue,
        title: Text(widget._text),
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (e) {
          setState(() {
            booleanValue = e;
          });
        },
      ),
    );
  }
}

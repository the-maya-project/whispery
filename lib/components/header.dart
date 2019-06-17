import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String _title;
  final double _size = 64.0;

  Header({Key key, @required String title})
      : _title = title,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Center(
        child: Text(
          _title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: _size,
          ),
        ),
      ),
    );
  }
}

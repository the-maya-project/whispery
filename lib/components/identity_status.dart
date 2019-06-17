import 'package:flutter/material.dart';

class IdentityStatus extends StatelessWidget {
  final String _title;
  final double _size = 16.0;

  IdentityStatus({Key key, @required String title})
      : _title = title,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      padding: EdgeInsets.all(15.0),
      child: Center(
        child: Text(
          _title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: _size,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.pinkAccent,
          width: 2.0,
        ),
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    );
  }
}

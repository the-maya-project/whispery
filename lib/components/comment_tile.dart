import 'package:flutter/material.dart';

class CommentTile extends StatelessWidget {
  final String _content;
  final String _username;
  final GestureTapCallback _tapCallback;

  CommentTile({Key key, @required content, @required username, @required tapCallback})
      : _content = content,
        _username = username,
        _tapCallback = tapCallback,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        title: Text(_content),
        trailing: Container(
          child: Column(
            children: <Widget>[
              Text(_username),
            ],
          ),
        ),
        onTap: () => _tapCallback,
      ),
    );
  }
}
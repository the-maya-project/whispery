import 'package:flutter/material.dart';

class FeedTile extends StatefulWidget {
  final String _content;
  final int _likeCount;
  final double _distance;
  final int _timeStamp;
  final GestureTapCallback _tapCallback;

  FeedTile(
      {Key key,
      @required String content,
      @required int likeCount,
      @required double distance,
      @required int timeStamp,
      @required GestureTapCallback tapCallback})
      : _content = content,
        _likeCount = likeCount,
        _distance = distance,
        _timeStamp = timeStamp,
        _tapCallback = tapCallback,
        super(key: key);

  State<FeedTile> createState() => _FeedTileState();
}

class _FeedTileState extends State<FeedTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        leading: Container(
          child: Column(
            children: <Widget>[
              Icon(Icons.healing),
              Container(
                child: Text(widget._likeCount.toString()),
              ),
            ],
          ),
        ),
        title: Text(widget._content),
        trailing: Container(
          child: Column(
            children: <Widget>[
              Text(widget._distance.toString()),
              Text(widget._timeStamp.toString()),
            ],
          ),
        ),
        onTap: () => widget._tapCallback,
      ),
    );
  }
}

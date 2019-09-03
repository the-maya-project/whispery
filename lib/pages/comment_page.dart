import 'package:flutter/material.dart';
import 'package:whispery/components/comment_tile.dart';
import 'package:whispery/components/identity_status.dart';

class CommentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          IdentityStatus(
            title: "People should stop reserving seats at UTown Starbucks by leaving their bags there",
          ),
          ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return CommentTile(
                  content:
                      "I agree, some people aren't even physically there half the time",
                  username: "carrein",
                  tapCallback: null,);
            },
            itemCount: 30,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
          )
        ],
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  final String text;
  final int index;
  PostWidget({Key key, @required this.text, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Text('$index'),
      title: Text('$text'),
    );
  }
}

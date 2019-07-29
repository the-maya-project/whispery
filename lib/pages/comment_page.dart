import 'package:flutter/material.dart';
import 'package:whispery/components/comment_tile.dart';
import 'package:whispery/components/identity_status.dart';

class CommentPage extends StatelessWidget {
  /// Placeholder widget for biography page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          IdentityStatus(
            title: "思春期爆発して疎遠になっちゃったり　背も伸びて視線の高さだってさ･ 色んなことが変わっていって　幼馴染って難しいな。ムズ痒いな。。恥ずかしいな、あぁ･･････",
          ),
          ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return CommentTile(
                  content:
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
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

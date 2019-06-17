import 'package:flutter/material.dart';
import 'package:whispery/components/header.dart';
import 'package:whispery/components/long_button.dart';
import 'package:whispery/components/post_field.dart';
import 'package:whispery/components/radiobox.dart';

/// The post page of Whispery.
class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage>
    with AutomaticKeepAliveClientMixin {
  /// Keep alive property for mixin to prevent page from being refreshed when scrolling in [PageView].
  @override
  bool get wantKeepAlive => true;

  /// Placeholder widget for post page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Header(
            title: "post",
          ),
          PostField(),
          RadioBox(
            text: 'Post anonymously.',
          ),
          RadioBox(
            text: 'I will post in good faith.',
          ),
          RadioBox(
            text: 'I adhered to Whispery\'s terms.',
          ),
          LongButton(
            text: 'ignite',
          )
        ],
      ),
    );
  }
}

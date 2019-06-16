import 'package:flutter/material.dart';

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
    return Container(
        child: Center(
      child: Text("Post Page"),
    ));
  }
}

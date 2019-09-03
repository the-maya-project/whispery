import 'package:flutter/material.dart';
import 'package:whispery/components/header.dart';
import 'package:whispery/components/identity_status.dart';
import 'package:whispery/components/solid_text.dart';

/// The biography page of Whispery.
class BioPage extends StatefulWidget {
  @override
  _BioPageState createState() => _BioPageState();
}

class _BioPageState extends State<BioPage> with AutomaticKeepAliveClientMixin {
  /// Keep alive property for mixin to prevent page from being refreshed when scrolling in [PageView].
  @override
  bool get wantKeepAlive => true;

  /// Placeholder widget for biography page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Header(
            title: "John Appleseed",
          ),
          IdentityStatus(
            title: "Year 1 NUS Computing Student.",
          ),
          SolidText(
            title: "post history",
            textAlign: TextAlign.left,
          ),
          ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return PostWidget(text: "sample post", index: index);
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

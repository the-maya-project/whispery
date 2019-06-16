import 'package:flutter/material.dart';

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
    return Container(
        child: Center(
      child: Text("Bio Page"),
    ));
  }
}

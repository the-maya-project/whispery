import 'package:flutter/material.dart';

import 'package:whispery/pages/bio_page.dart';
import 'package:whispery/pages/feed_page.dart';
import 'package:whispery/pages/post_page.dart';

/// A landing page implementing [PageView] to wrap around:
/// [FeedForm]
/// [PostForm]
/// [BioForm]
class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  
  /// Controller for [PageView] builder, the index for [PageView] is set to the center.
  final _pageViewController = PageController(initialPage: 1);

  /// List of page widgets to populate the [PageView] component.
  /// Widgets are displayed based on corresponding order in list.
  final List<Widget> _pages = <Widget>[
    PostPage(),
    FeedPage(),
    BioPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageViewController,
      itemBuilder: (BuildContext context, int index) {
        return _pages[index];
      },
      itemCount: _pages.length,
    );
  }
}

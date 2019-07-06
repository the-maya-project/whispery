import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:whispery/components/feed_tile.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:whispery/components/loading_indicator.dart';
import 'package:whispery/models/post.dart';
import 'package:whispery/post_bloc/bloc.dart';
import 'package:whispery/geolocation_bloc/bloc.dart';
import 'package:whispery/globals/config.dart';

/// The main [FeedPage] of the Whispery application.
/// The [FeedPage] implements lazing loading of queried post, pull-to-refresh and a slider to vary radius.
class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

/// Mixin with [AutomaticKeepAliveClientMixin] to prevent page from being refreshed when switching between pages.
class _FeedPageState extends State<FeedPage>
    with AutomaticKeepAliveClientMixin {
  /// Enable keep alive bit in the mixin.
  @override
  bool get wantKeepAlive => true;

  /// Controllers for managing refresh state and BLoC loaders.
  final ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  PostBloc _postBloc;
  GeolocationBloc _geolocationBloc;

  /// Temp variable for visual
  double radii = Config.DEFAULT_RADIUS;
  double lat = 0;
  double long = 0;

  /// Request geolocation on first launch.
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  /// Dispose all controllers on widget destruction.
  @override
  void dispose() {
    _postBloc.dispose();
    _geolocationBloc.dispose();
    _refreshController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Slider widget to adjust radius where post are fetched from.
  Widget slider() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Slider(
        divisions: Config.SLIDER_DIVISIONS,
        min: Config.SLIDER_MIN,
        max: Config.SLIDER_MAX,
        onChanged: ((response) {
          setState(() {
            if (radii != response) {
              radii = response;
            }
          });
        }),
        onChangeEnd: ((response) {
          // updateLocation();
          // reset();
        }),
        value: radii,
        label: radii.round().toString(),
      ),
    );
  }

  /// Main build method for [FeedPage].
  /// Implements both [GeolocationBloc] and [PostBloc] to populate the listviewBuilder
  /// depending on the radius provided by the slider widget.
  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: Text('Username')),
      body: BlocProviderTree(
        blocProviders: [
          BlocProvider<PostBloc>(
            builder: (BuildContext context) {
              _postBloc = PostBloc(httpClient: http.Client());
              return _postBloc;
            },
          ),
          BlocProvider<GeolocationBloc>(
            builder: (BuildContext context) {
              _geolocationBloc = GeolocationBloc();
              _geolocationBloc.dispatch(RequestLocation());
              return _geolocationBloc;
            },
          ),
        ],
        child: Builder(
          refreshController: _refreshController,
          scrollController: _scrollController,
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          slider(),
        ],
      ),
    );
  }

  /// Fetch new post if user has scrolled past a certain threshold.
  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= Config.SCROLL_THRESHOLD) {
      _postBloc.dispatch(Fetch());
    }
  }
}

class Builder extends StatelessWidget {
  final RefreshController _refreshController;
  final ScrollController _scrollController;

  Builder(
      {Key key,
      @required RefreshController refreshController,
      @required ScrollController scrollController})
      : _refreshController = refreshController,
        _scrollController = scrollController,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final GeolocationBloc _geolocationBloc =
        BlocProvider.of<GeolocationBloc>(context);
    final PostBloc _postBloc = BlocProvider.of<PostBloc>(context);

    /// Refresh all post in the [FeedPage] by fetching a new location.
    /// Called by pull-to-refresh and slider.
    /// Note that refresh disposes all previous requested posts i.e. listviewBuilder is cleared.
    void _onRefresh() {
      _geolocationBloc.dispatch(RequestLocation());
    }

    return BlocListenerTree(
      blocListeners: [
        BlocListener<GeolocationEvent, GeolocationState>(
          bloc: _geolocationBloc,
          listener: (BuildContext context, GeolocationState state) {
            /// If BLoC is able to retrieve a location, issue a [PostEvent] to retrieve post based on radius.
            if (state is LocationLoaded) {
              // lat = state.latitude;
              // long = state.longitude;
              _postBloc.dispatch(Refresh());
            }

            /// If Bloc is unable to retrieve a location, throw snackbar to warn user.
            if (state is GeolocationDisabled) {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Geolocation Access Disabled'),
                        Icon(Icons.error),
                      ],
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
            }
          },
        ),
      ],
      child: BlocBuilder(
        bloc: BlocProvider.of<PostBloc>(context),
        builder: (BuildContext context, PostState state) {
          /// Draw an indicator of [PostEvent] is uninitalized.
          if (state is PostUninitialized) {
            return Center(
              child: LoadingIndicator(),
            );
          }

          /// If the PostBLoc is unable to query to the database, warn user.
          if (state is PostError) {
            return Center(
              child: Text('failed to fetch posts'),
            );
          }

          /// If PostLoaded, populate and draw listviewBuilder.
          if (state is PostLoaded) {
            /// Unset refresh controller.
            _refreshController.refreshCompleted();
            if (state.posts.isEmpty) {
              return Center(
                child: Text('no posts'),
              );
            } else {
              return SmartRefresher(
                enablePullDown: true,
                enablePullUp: false,
                header: ClassicHeader(),
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return index >= state.posts.length
                        ? LoadingIndicator()
                        : PostWidget(
                            post: state.posts[index],
                            lat: 0,
                            long: 0,
                            radii: 0,
                            index: index,
                          );
                  },
                  itemCount: state.hasReachedMax
                      ? state.posts.length
                      : state.posts.length + 1,
                  controller: _scrollController,
                ),
              );
            }
          }
        },
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  final Post post;
  final double lat;
  final double long;
  final double radii;
  final int index;

  PostWidget(
      {Key key,
      @required this.post,
      @required this.lat,
      @required this.long,
      @required this.radii,
      @required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return ListTile(
    //   title: Text(
    //     'Index: $index + Latitude: $lat  + Longitude: $long + Radius: $radii',
    //   ),
    // );
    return FeedTile(
      content: '$index',
      distance: 100,
      likeCount: 100,
      timeStamp: 100,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:whispery/components/loading_indicator.dart';
import 'package:whispery/components/radius_slider.dart';
import 'package:whispery/models/post.dart';
import 'package:whispery/blocs/post_bloc/bloc.dart';
import 'package:whispery/blocs/geolocation_bloc/bloc.dart';
import 'package:whispery/blocs/authentication_bloc/bloc.dart';
import 'package:whispery/globals/config.dart';
import 'package:whispery/components/feed_tile.dart';

/// The main [FeedPage] of the Whispery application.
/// The [FeedPage] implements lazing loading of queried post, pull-to-refresh and a slider to vary radius.
class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

/// Mixin with [AutomaticKeepAliveClientMixin] to prevent page from being refreshed when switching between pages.
class _FeedPageState extends State<FeedPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    super.build(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostBloc>(
          builder: (BuildContext context) {
            final PostBloc _postBloc = PostBloc(httpClient: http.Client());
            return _postBloc;
          },
        ),
        BlocProvider<GeolocationBloc>(
          builder: (BuildContext context) {
            final GeolocationBloc _geolocationBloc = GeolocationBloc()
              ..dispatch(RequestLocation());
            return _geolocationBloc;
          },
        ),
      ],
      child: Builder(),
    );
  }
}

class Builder extends StatefulWidget {
  @override
  _BuilderState createState() => _BuilderState();
}

// State of the FeedPage builder
class _BuilderState extends State<Builder> {
  final ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    final GeolocationBloc _geolocationBloc = BlocProvider.of<GeolocationBloc>(context);
    final PostBloc _postBloc = BlocProvider.of<PostBloc>(context);
    final AuthenticationBloc _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    /// Upon refreshing of [FeedPage], fetch new location.
    /// Called by pull-to-refresh and slider.
    /// Note that refresh disposes all previous requested posts i.e. listviewBuilder is cleared.
    void _onRefresh() {
      _geolocationBloc.dispatch(RequestLocation());
    }

    // Upon scrolling within SCROLL_THRESHOLD, fetch more posts
    void _onScroll() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScroll - currentScroll <= Config.SCROLL_THRESHOLD) {
        _postBloc.dispatch(Fetch());
      }
    }

    _scrollController.addListener(_onScroll);

    // Scaffold for Feed Page
    return Scaffold(
      appBar: AppBar(
        title: Text('Username'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _authenticationBloc.dispatch(LoggedOut());
            },
          ),
        ],
      ),
      // Multiple Blocs with listeners
      body: MultiBlocListener(
        listeners: [
          
          BlocListener<GeolocationEvent, GeolocationState>(
            bloc: _geolocationBloc,
            listener: (BuildContext context, GeolocationState state) {    // Listener is invoked when there is a state change in GeolocationState
              /// If BLoC is able to retrieve a location, issue a [PostEvent] to retrieve post based on radius.
              /// Location loaded, refresh the feed page
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
        /// BlocBuilder calls builder everytime there is a change in the state
        child: BlocBuilder(
          bloc: _postBloc,
          builder: (BuildContext context, PostState state) {
            /// [PostEvent] is uninitalized, display loading indicator
            if (state is PostUninitialized) {
              return Center(
                child: LoadingIndicator(),
              );
            }
            /// If PostBLoc is unable to query to the database, warn user.
            if (state is PostError) {
              return Center(
                child: Text('failed to fetch posts'),
              );
            }
            /// If PostBloc successfully loads a post, load the posts w animation
            if (state is PostLoadedAnimateToTop) {
              /// Unset refresh controller.
              _refreshController.refreshCompleted();
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  0.0,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 300),
                );
              }
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
                    // itemBuilder builds scrollable list of widgets while index less than itemCount
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
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RadiusSlider(),
        ],
      ),
    );
  }
}

// Widget for a single post
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

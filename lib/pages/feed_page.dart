import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:whispery/components/feed_tile.dart';

import 'package:whispery/models/post.dart';
import 'package:whispery/post_bloc/bloc.dart';
import 'package:whispery/geolocation_bloc/bloc.dart';
import 'package:whispery/globals/config.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  RefreshController _refreshController;
  final PostBloc _postBloc = PostBloc(httpClient: http.Client());
  final GeolocationBloc _geolocationBloc = GeolocationBloc();

  /// Temp variable for visual
  double radii = Config.SLIDER_DEFAULT;
  double lat = 0;
  double long = 0;

  @override
  void initState() {
    super.initState();
    _geolocationBloc.dispatch(RequestLocation());
    _scrollController.addListener(_onScroll);
    _refreshController = RefreshController(initialRefresh: false);
  }

  @override
  void dispose() {
    _postBloc.dispose();
    _geolocationBloc.dispose();
    _refreshController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onRefresh() {
    _geolocationBloc.dispatch(RequestLocation());
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Username')),
      body: BlocProviderTree(
        blocProviders: [
          BlocProvider<PostBloc>(bloc: _postBloc),
          BlocProvider<GeolocationBloc>(bloc: _geolocationBloc),
        ],
        child: BlocListenerTree(
          blocListeners: [
            BlocListener<GeolocationEvent, GeolocationState>(
              bloc: _geolocationBloc,
              listener: (BuildContext context, GeolocationState state) {
                if (state is LocationLoaded) {
                  lat = state.latitude;
                  long = state.longitude;
                  _postBloc.dispatch(Fetch());
                  setState(() {});
                }
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
                if (state is GeolocationRestricted) {
                  Scaffold.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                'Geolocation Access RestricedGeolocationRestricted'),
                            Icon(Icons.error),
                          ],
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                }
                if (state is GeolocationUnknown) {
                  Scaffold.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Geolocation Access Unknown'),
                            Icon(Icons.error),
                          ],
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                }
                if (state is GeolocationDenied) {
                  Scaffold.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Geolocation Access Denied'),
                            Icon(Icons.error),
                          ],
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                }
                if (state is GeolocationOff) {
                  Scaffold.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Geolocation Access Off'),
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
            bloc: _postBloc,
            builder: (BuildContext context, PostState state) {
              if (state is PostUninitialized) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is PostError) {
                return Center(
                  child: Text('failed to fetch posts'),
                );
              }
              if (state is PostLoaded) {
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
                            ? BottomLoader()
                            : PostWidget(
                                post: state.posts[index],
                                lat: lat,
                                long: long,
                                radii: radii,
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
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          slider(),
        ],
      ),
    );
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _postBloc.dispatch(Fetch());
    }
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
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

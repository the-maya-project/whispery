import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whispery/authentication_bloc/bloc.dart';
import 'package:whispery/post_bloc/bloc.dart';
import 'package:whispery/models/post.dart';
import 'package:whispery/globals/config.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  final PostBloc _postBloc = PostBloc(httpClient: http.Client());
  final _scrollThreshold = 200.0;
  RefreshController _refreshController;
  Completer<void> _refreshCompleter;

  /// Temp variable for visual
  double radii = Config.SLIDER_DEFAULT;

  _HomePageState() {
    _scrollController.addListener(_onScroll);
    _postBloc.dispatch(Fetch());
  }

  @override
  initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    _refreshController = RefreshController(initialRefresh: false);
  }

  @override
  void dispose() {
    _postBloc.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() {
    _postBloc.dispatch(Refresh());
    print("refresh");
    setState(() {});
    _refreshController.refreshCompleted();
    return _refreshCompleter.future;
  }

  void _onLoading() {
    print("loading");
    _refreshController.loadComplete();
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context).dispatch(
                  LoggedOut(),
                );
              },
            )
          ],
        ),
        body: BlocBuilder(
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
              if (state.posts.isEmpty) {
                return Center(
                  child: Text('no posts'),
                );
              }
              return SmartRefresher(
                enablePullDown: true,
                enablePullUp: false,
                header: WaterDropMaterialHeader(),
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return index >= state.posts.length
                        ? BottomLoader()
                        : PostWidget(post: state.posts[index]);
                  },
                  itemCount: state.hasReachedMax
                      ? state.posts.length
                      : state.posts.length + 1,
                  controller: _scrollController,
                ),
              );
            }
          },
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            slider(),
          ],
        ));
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
  Random rng = Random();

  PostWidget({Key key, @required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        // '${post.id}',
        rng.nextInt(100).toString(),
        style: TextStyle(fontSize: 10.0),
      ),
      // title: Text(post.title),
      title: Text(
        rng.nextInt(100).toString(),
      ),

      isThreeLine: true,
      // subtitle: Text(post.body),
      subtitle: Text(
        rng.nextInt(100).toString(),
      ),

      dense: true,
    );
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:whispery/blocs/post_bloc/bloc.dart';
import 'package:whispery/models/post.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final http.Client httpClient;

  // Client required from http package to keep open a persistent connection
  PostBloc({@required this.httpClient});

  @override
  Stream<PostState> transform(
    Stream<PostEvent> events,
    Stream<PostState> Function(PostEvent event) next,
  ) {
    return super.transform(
      (events as Observable<PostEvent>).debounceTime(
        Duration(milliseconds: 1000),
      ),
      next,
    );
  }

  @override
  get initialState => PostUninitialized();

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {

    if (event is RefreshAnimateToTop) {
      // Current posts loaded, clear them
      if (currentState is PostLoadedAnimateToTop) {
        (currentState as PostLoadedAnimateToTop).posts.clear();
      }
      // Fetch 20 new posts, yield new state
      final posts = await _fetchPosts(0, 20);
      yield PostLoadedAnimateToTop(posts: posts, hasReachedMax: false);
      return;
    }

    if (event is Refresh) {
      // Current posts loaded, clear them
      if (currentState is PostLoaded) {
        (currentState as PostLoaded).posts.clear();
      }
      // Fetch 20 new posts, yield new state
      final posts = await _fetchPosts(0, 20);
      yield PostLoaded(posts: posts, hasReachedMax: false);
      return;
    }

    // Fetch new posts, has not reached max
    if (event is Fetch && !_hasReachedMax(currentState)) {
      try {
        // Posts not initialised, fetch posts, yield [PostLoaded]
        if (currentState is PostUninitialized) {
          final posts = await _fetchPosts(0, 20);
          yield PostLoaded(posts: posts, hasReachedMax: false);
          return;
        }
        // Posts initialised
        if (currentState is PostLoaded) {
          final posts = await _fetchPosts((currentState as PostLoaded).posts.length, 20);
          
          yield posts.isEmpty
              ? (currentState as PostLoaded).copyWith(hasReachedMax: true)  // If currently no posts, hasReachedMax = true
              : PostLoaded(
                  posts: (currentState as PostLoaded).posts + posts,
                  hasReachedMax: false,
                );  // Else, hasReachedMax = false
        }

        if (currentState is PostLoadedAnimateToTop) {
          final posts = await _fetchPosts((currentState as PostLoadedAnimateToTop).posts.length, 20);
          yield posts.isEmpty
              ? (currentState as PostLoadedAnimateToTop).copyWith(hasReachedMax: true)  // If currently no posts, hasReachedMax = true
              : PostLoaded(
                  posts: (currentState as PostLoadedAnimateToTop).posts + posts,
                  hasReachedMax: false,
                );  // Else, hasReachedMax = false
        }
      } catch (_) {
        yield PostError();
      }
      return;
    }
  }

  bool _hasReachedMax(PostState state) =>
      state is PostLoaded && state.hasReachedMax;

  // Fetch posts from url as json format
  Future<List<Post>> _fetchPosts(int startIndex, int limit) async {
    final response = await httpClient.get(
        'https://jsonplaceholder.typicode.com/posts?_start=$startIndex&_limit=$limit');

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((rawPost) {
        return Post(
          id: rawPost['id'],
          title: rawPost['title'],
          body: rawPost['body'],
        );
      }).toList();
    } else {
      throw Exception('error fetching posts');
    }
  }
}

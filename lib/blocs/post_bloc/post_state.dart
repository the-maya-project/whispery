import 'package:equatable/equatable.dart';
import 'package:whispery/models/post.dart';

abstract class PostState extends Equatable {
  PostState([List props = const []]) : super(props);
}

class PostUninitialized extends PostState {
  @override
  String toString() => 'PostUninitialized';
}

class PostError extends PostState {
  @override
  String toString() => 'PostError';
}

class PostLoaded extends PostState {
  final List<Post> posts;
  final bool hasReachedMax;

  PostLoaded({
    this.posts,
    this.hasReachedMax,
  }) : super([posts, hasReachedMax]);

  PostLoaded copyWith({
    List<Post> posts,
    bool hasReachedMax,
  }) {
    return PostLoaded(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}
class PostLoadedAnimateToTop extends PostState {
  final List<Post> posts;
  final bool hasReachedMax;

  PostLoadedAnimateToTop({
    this.posts,
    this.hasReachedMax,
  }) : super([posts, hasReachedMax]);

  PostLoadedAnimateToTop copyWith({
    List<Post> posts,
    bool hasReachedMax,
  }) {
    return PostLoadedAnimateToTop(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

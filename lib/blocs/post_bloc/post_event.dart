import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
    PostEvent([List props = const []]) : super(props);
}

class Fetch extends PostEvent {
  @override
  String toString() => 'Fetch';
}

class Refresh extends PostEvent {
  @override
  String toString() => 'Refresh';
}

class RefreshAnimateToTop extends PostEvent {
  @override
  String toString() => 'RefreshAnimateToTop';
}
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SharedPreferencesState extends Equatable {
  SharedPreferencesState([List props = const []]) : super(props);
}

class SharedPreferencesUninitalized extends SharedPreferencesState {
  @override
  String toString() => 'SharedPreferencesUninitalized';
}

class SharedPreferencesLoaded extends SharedPreferencesState {
  final dynamic value;

  SharedPreferencesLoaded({this.value}) : super([value]);

  @override
  String toString() => 'SharedPreferencesLoaded { value: $value }';
}

class SharedPreferencesCompleted extends SharedPreferencesState {
  @override
  String toString() => 'SharedPreferencesCompleted';
}

class SharedPreferencesGetRadius extends SharedPreferencesState {
  final double radius;

  SharedPreferencesGetRadius({@required this.radius}) : super([radius]);

  @override
  String toString() => 'SharedPreferencesGetRadius { value: $radius }';
}

class SharedPreferencesRadiusError extends SharedPreferencesState {
  @override
  String toString() => 'SharedPreferencesRadiusError';
}

class SharedPreferencesError extends SharedPreferencesState {
  @override
  String toString() => 'SharedPreferencesError';
}

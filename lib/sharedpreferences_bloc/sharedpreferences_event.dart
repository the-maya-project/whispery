import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SharedPreferencesEvent extends Equatable {
  SharedPreferencesEvent([List props = const []]) : super(props);
}

class InitializeEvent extends SharedPreferencesEvent {
  @override
  String toString() => 'InitializeEvent';
}

class Write extends SharedPreferencesEvent {
  final String property;
  final dynamic value;

  Write({
    @required this.property,
    @required this.value,
  }) : super([property, value]);

  @override
  String toString() => 'SharedPreferenceWrite';
}

class Read extends SharedPreferencesEvent {
  final String property;

  Read({
    @required this.property,
  }) : super([property]);

  @override
  String toString() => 'SharedPreferenceRead';
}

class GetRadius extends SharedPreferencesEvent {
  @override
  String toString() => 'GetRadius';
}

class SetRadius extends SharedPreferencesEvent {
  final double radius;

  SetRadius({
    this.radius,
  }) : super([radius]);

  @override
  String toString() => 'SetRadius: $radius';
}

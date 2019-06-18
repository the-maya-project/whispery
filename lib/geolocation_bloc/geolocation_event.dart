import 'package:meta/meta.dart';

@immutable
abstract class GeolocationEvent {}

class RequestLocation extends GeolocationEvent {
  @override
  String toString() => 'RequestLocation';
}

class RequestStatus extends GeolocationEvent {
  @override
  String toString() => 'RequestStatus';
}

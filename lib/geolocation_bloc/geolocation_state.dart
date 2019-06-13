import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class GeolocationState extends Equatable {
  GeolocationState([List props = const []]) : super(props);
}

// class Uninitialized extends GeolocationState {
//   @override
//   String toString() => 'Uninitialized';
// }

class LocationLoaded extends GeolocationState {
  final double latitude;
  final double longitude;

  LocationLoaded(this.latitude, this.longitude) : super([latitude, longitude]);

  @override
  String toString() =>
      'LocationLoaded { latitude: $latitude, longitude: $longitude}';
}

// class Unauthenticated extends GeolocationState {
//   @override
//   String toString() => 'Unauthenticated';
// }

class GeolocationDenied extends GeolocationState {
  @override
  String toString() => 'GeolocationDenied';
}

class GeolocationDisabled extends GeolocationState {
  @override
  String toString() => 'GeolocationDisabled';
}

class GeolocationGranted extends GeolocationState {
  @override
  String toString() => 'GeolocationGranted';
}

class GeolocationRestricted extends GeolocationState {
  @override
  String toString() => 'GeolocationRestricted';
}

class GeolocationUnknown extends GeolocationState {
  @override
  String toString() => 'GeolocationUnknown';
}

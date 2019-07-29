import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:whispery/blocs/geolocation_bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';

class GeolocationBloc extends Bloc<GeolocationEvent, GeolocationState> {
  @override
  GeolocationState get initialState => GeolocationUninitialized();

  @override
  Stream<GeolocationState> mapEventToState(GeolocationEvent event) async* {
    if (event is RequestStatus) {
      yield* _mapGeolocationRequestStatus();
    } else if (event is RequestLocation) {
      yield* _mapGeolocationRequestLocation();
    }
  }

  Stream<GeolocationState> _mapGeolocationRequestStatus() async* {
    var geolocator = Geolocator();
    final status = await geolocator.checkGeolocationPermissionStatus();
    if (status == GeolocationStatus.denied) {
      yield GeolocationDenied();
    } else if (status == GeolocationStatus.disabled) {
      yield GeolocationDisabled();
    } else if (status == GeolocationStatus.restricted) {
      yield GeolocationRestricted();
    } else if (status == GeolocationStatus.unknown) {
      yield GeolocationUnknown();
    } else if (status == GeolocationStatus.granted) {
      yield GeolocationGranted();
    }
  }

  Stream<GeolocationState> _mapGeolocationRequestLocation() async* {
    Position position = await Geolocator()
        .getCurrentPosition()
        .timeout(Duration(seconds: 1), onTimeout: () {
      return null;
    });
    if (position == null) {
      position = await Geolocator().getLastKnownPosition();
      yield LocationLoaded(position.latitude, position.longitude);
    } else {
      yield LocationLoaded(position.latitude, position.longitude);
    }
  }
}

import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class GeolocationBloc extends Bloc<GeolocationEvent, GeolocationState> {
  @override
  GeolocationState get initialState => InitialGeolocationState();

  @override
  Stream<GeolocationState> mapEventToState(
    GeolocationEvent event,
  ) async* {
    if (event is GeolocationChanged) {
      // yield* _mapEmailChangedToState(event.email);
      // yield* _mapPasswordChangedToState(event.password);
      yield* updateGeolocationState();
    }
  }

  Stream<GeolocationState> updateGeolocationState() async* {

  }
}

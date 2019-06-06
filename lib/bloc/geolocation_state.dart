import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class GeolocationState extends Equatable {
  GeolocationState([List props = const []]) : super(props);
}

class InitialGeolocationState extends GeolocationState {
  int radius;

  InitialGeolocationState({
    this.radius,
  }) : super([radius]);

  pollSharedPreferenceGeolocation() async {
    await SharedPreferences.getInstance().then((prefs) {
      /// TODO - config for default radius;
      radius = prefs.getInt("radius").isNaN ? 5 : prefs.getInt("radius");
    });
  }

  @override
  String toString() => 'InitialGeolocationState';
}

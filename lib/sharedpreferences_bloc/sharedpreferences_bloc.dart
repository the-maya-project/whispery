import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whispery/globals/config.dart';
import 'package:whispery/sharedpreferences_bloc/bloc.dart';

class SharedPreferencesBloc
    extends Bloc<SharedPreferencesEvent, SharedPreferencesState> {
  @override
  SharedPreferencesState get initialState => SharedPreferencesUninitalized();

  @override
  Stream<SharedPreferencesState> mapEventToState(
      SharedPreferencesEvent event) async* {
    if (event is Read) {
      yield* _mapRead(event);
    } else if (event is Write) {
      yield* _mapWrite(event);
    } else if (event is GetRadius) {
      yield* _mapGetRadius(event);
    } else if (event is SetRadius) {
      yield* _mapSetRadius(event);
    } else if (event is InitializeEvent) {
      yield* __mapInitializeEvent(event);
    }
  }

  Stream<SharedPreferencesState> _mapRead(SharedPreferencesEvent event) async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final String key = (event as Read).property;
    final String value = await prefs.get(key);

    yield SharedPreferencesLoaded(value: value);
  }

  /// Note that while [SharedPreferences] can accept booleans as a value
  /// pair for a key, the bool type is not parsed in this method as there
  /// is no explicit way to cast the dynamic typing. This will throw a
  /// [SharedPreferencesError] event.
  Stream<SharedPreferencesState> _mapWrite(
      SharedPreferencesEvent event) async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final String key = (event as Write).property;
    final dynamic value = (event as Write).value;

    if (value is int) {
      await prefs.setInt(key, value.toInt());
    }
    if (value is String) {
      await prefs.setString(key, value.toString());
    }
    if (value is double) {
      await prefs.setDouble(key, value.toDouble());
    } else {
      yield SharedPreferencesError();
    }
    yield SharedPreferencesCompleted();
  }

  Stream<SharedPreferencesState> _mapGetRadius(
      SharedPreferencesEvent event) async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    yield prefs.containsKey('radius')
        ? SharedPreferencesGetRadius(radius: await prefs.get('radius'))
        : SharedPreferencesRadiusError();
  }

  Stream<SharedPreferencesState> _mapSetRadius(
      SharedPreferencesEvent event) async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setDouble('radius', (event as SetRadius).radius);
    yield SharedPreferencesCompleted();
  }

  Stream<SharedPreferencesState> __mapInitializeEvent(
      SharedPreferencesEvent event) async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('radius')) {
      await prefs.setDouble('radius', Config.DEFAULT_RADIUS);
    }
    yield SharedPreferencesCompleted();
  }
}

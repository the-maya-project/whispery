import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:whispery/blocs/sharedpreferences_bloc/bloc.dart';
import 'package:whispery/blocs/sharedpreferences_bloc/sharedpreferences_bloc.dart';
import 'package:whispery/blocs/slider_bloc/bloc.dart';

class SliderBloc extends Bloc<SliderEvent, SliderState> {
  final SharedPreferencesBloc _sharedPreferencesBloc;
  StreamSubscription _sharedPreferencesSubscription;

  SliderBloc(this._sharedPreferencesBloc) {
    _sharedPreferencesSubscription =
        _sharedPreferencesBloc.state.listen((state) {
      if (state is SharedPreferencesGetRadius) {}
    });
  }

  @override
  SliderState get initialState => SliderStateUninitalized();

  @override
  Stream<SliderState> mapEventToState(SliderEvent event) async* {
    if (event is InitializeSlider) {
      yield* _mapInitializeSlider(event);
    } else if (event is OnChangedSlider) {
      yield* _mapOnChangedSlider(event.sliderValue);
    } else if (event is OnChangeEndSlider) {
      yield* _mapOnChangeEndSlider(event);
    }
  }

  Stream<SliderState> _mapInitializeSlider(SliderEvent event) async* {
    // _sharedPreferencesBloc.dispatch(GetRadius());
    // yield SliderChange();
  }

  Stream<SliderState> _mapOnChangedSlider(double sliderValue) async* {
    yield SliderChange(sliderValue: sliderValue);
  }

  Stream<SliderState> _mapOnChangeEndSlider(SliderEvent event) async* {
    yield SliderChangeCompleted();
  }
}

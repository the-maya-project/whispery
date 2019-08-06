import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:whispery/blocs/post_bloc/bloc.dart';
import 'package:whispery/blocs/sharedpreferences_bloc/bloc.dart';
import 'package:whispery/blocs/sharedpreferences_bloc/sharedpreferences_bloc.dart';
import 'package:whispery/blocs/slider_bloc/bloc.dart';

class SliderBloc extends Bloc<SliderEvent, SliderState> {
  final SharedPreferencesBloc _sharedPreferencesBloc;
  final PostBloc _postBloc;

  StreamSubscription _sharedPreferencesSubscription;

  SliderBloc(this._sharedPreferencesBloc, this._postBloc) {
    _sharedPreferencesSubscription = _sharedPreferencesBloc.state.listen(
      (state) {
        if (state is SharedPreferencesGetRadius) {
          this.dispatch(OnChangedSlider(sliderValue: state.radius));
        }
      },
    );
  }

  @override
  void dispose() {
    _sharedPreferencesSubscription.cancel();
    super.dispose();
  }

  @override
  SliderState get initialState => SliderStateUninitalized();

  @override
  Stream<SliderState> mapEventToState(SliderEvent event) async* {
    if (event is InitializeSlider) {
      yield* _mapInitializeSlider(event);
    } else if (event is OnChangedSlider) {
      yield* _mapOnChangedSlider(event);
    } else if (event is OnChangeEndSlider) {
      yield* _mapOnChangeEndSlider(event);
    }
  }

  Stream<SliderState> _mapInitializeSlider(SliderEvent event) async* {
    _sharedPreferencesBloc.dispatch(GetRadius());
  }

  Stream<SliderState> _mapOnChangedSlider(OnChangedSlider event) async* {
    yield SliderChange(sliderValue: event.sliderValue);
  }

  Stream<SliderState> _mapOnChangeEndSlider(OnChangeEndSlider event) async* {
    _postBloc.dispatch(RefreshAnimateToTop());
    _sharedPreferencesBloc.dispatch(SetRadius(radius: event.sliderValue));
  }
}

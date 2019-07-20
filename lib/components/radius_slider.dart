import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whispery/blocs/sharedpreferences_bloc/bloc.dart';
import 'package:whispery/blocs/slider_bloc/bloc.dart';
import 'package:whispery/components/loading_indicator.dart';
import 'package:whispery/globals/config.dart';

class RadiusSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (BuildContext context) {
        final SliderBloc _sliderBloc =
            SliderBloc(BlocProvider.of<SharedPreferencesBloc>(context))
              ..dispatch(InitializeSlider());
        return _sliderBloc;
      },
      child: Builder(),
    );
  }
}

class Builder extends StatelessWidget {
  double _radius;

  @override
  Widget build(BuildContext context) {
    final SliderBloc _sliderBloc = BlocProvider.of<SliderBloc>(context);

    return BlocBuilder(
      bloc: _sliderBloc,
      builder: (BuildContext context, SliderState state) {
        if (state is SliderChangeCompleted) {
          return Container(
            child: Slider(
              divisions: Config.SLIDER_DIVISIONS,
              min: Config.SLIDER_MIN,
              max: Config.SLIDER_MAX,
              value: _radius,
              label: _radius.round().toString(),
              onChanged: ((response) {
                if (response != _radius) {
                  _sliderBloc.dispatch(OnChangedSlider(sliderValue: response));
                }
              }),
              onChangeEnd: ((response) {}),
            ),
          );
        } else if (state is SliderChange) {
          _radius = state.sliderValue;
          return Slider(
            divisions: Config.SLIDER_DIVISIONS,
            min: Config.SLIDER_MIN,
            max: Config.SLIDER_MAX,
            value: _radius,
            label: _radius.round().toString(),
            onChanged: ((response) {
              if (response != _radius) {
                _sliderBloc.dispatch(OnChangedSlider(sliderValue: response));
              }
            }),
            onChangeEnd: ((response) {}),
          );
        } else {
          return Center(
            child: LoadingIndicator(),
          );
        }
      },
    );
  }
}

// class RadiusSlider extends StatefulWidget {
//   @override
//   _RadiusSlider createState() => _RadiusSlider();
// }

// class _RadiusSlider extends State<RadiusSlider> {
//   double _radius = 0;

//   @override
//   Widget build(BuildContext context) {
//     final SharedPreferencesBloc _sharedPreferencesBloc =
//         BlocProvider.of<SharedPreferencesBloc>(context);
//     if (_radius == 0) {
//       _sharedPreferencesBloc.dispatch(GetRadius());
//     }

//     return BlocBuilder(
//       bloc: _sharedPreferencesBloc,
//       builder: (BuildContext context, SharedPreferencesState state) {
//         if (state is SharedPreferencesGetRadius) {
//           _radius = state.radius;
//           return Container(
//             child: Slider(
//               divisions: Config.SLIDER_DIVISIONS,
//               min: Config.SLIDER_MIN,
//               max: Config.SLIDER_MAX,
//               value: _radius,
//               label: _radius.round().toString(),
//               onChanged: ((response) {
//                 setState(() => _radius = response);
//               }),
//               onChangeEnd: ((response) {}),
//             ),
//           );
//         } else {
//           return Center(
//             child: LoadingIndicator(),
//           );
//         }
//       },
//     );
//   }
// }

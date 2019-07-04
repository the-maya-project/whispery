import 'package:flutter/material.dart';
import 'package:whispery/globals/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RadiusSlider extends StatefulWidget {
  final double _radius = Config.SLIDER_DEFAULT;
  final VoidCallback _onChange;

  RadiusSlider({Key key, @required VoidCallback onChange})
      : _onChange = onChange,
        super(key: key);

  State<RadiusSlider> createState() => _RadiusSliderState();
}

class _RadiusSliderState extends State<RadiusSlider> {
  void writeRadiusToSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('radius', widget._radius);
  }

  @override
  Widget build(BuildContext context) {
    double _radius = widget._radius;
    return Container(
      child: Slider(
        divisions: Config.SLIDER_DIVISIONS,
        min: Config.SLIDER_MIN,
        max: Config.SLIDER_MAX,
        value: _radius,
        label: _radius.round().toString(),
        onChanged: ((response) {
          setState(() {
            if (_radius != response) {
              _radius = response;
            }
          });
        }),
        onChangeEnd: ((response) {
          widget._onChange();
        }),
      ),
    );
  }
}

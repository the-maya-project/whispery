import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SliderEvent extends Equatable {
  SliderEvent([List props = const []]) : super(props);
}

class InitializeSlider extends SliderEvent {
  @override
  String toString() => 'InitializeEvent';
}

class OnChangedSlider extends SliderEvent {
  double sliderValue;

  OnChangedSlider({
    @required this.sliderValue,
  }) : super([sliderValue]);


  @override
  String toString() => 'OnChangedSlider';
}

class OnChangeEndSlider extends SliderEvent {
  final double sliderValue;

  OnChangeEndSlider({
    @required this.sliderValue,
  }) : super([sliderValue]);

  @override
  String toString() => 'OnChangeEndSlider';
}

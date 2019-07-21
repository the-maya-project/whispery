import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SliderState extends Equatable {
  SliderState([List props = const []]) : super(props);
}

class SliderStateUninitalized extends SliderState {
  @override
  String toString() => 'SliderStateUninitalized';
}

class SliderChangeCompleted extends SliderState {
  final dynamic sliderValue;

  SliderChangeCompleted({@required this.sliderValue}) : super([sliderValue]);

  @override
  String toString() => 'SliderChangeCompleted';
}

class SliderChange extends SliderState {
  @override
  String toString() => 'SliderChange';
}

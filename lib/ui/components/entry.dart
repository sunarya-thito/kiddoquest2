import 'dart:ui';

import 'package:animation_toolkit/animation_toolkit.dart';
import 'package:data_widget/data_widget.dart';
import 'package:flutter/material.dart';

import '../game_screen.dart';

abstract class EntryProperty {
  Widget wrap(Widget child, double value);
}

class ScaleProperty implements EntryProperty {
  final double start;
  final double end;
  final AlignmentGeometry? alignment;

  const ScaleProperty(this.start, this.end, {this.alignment});

  @override
  Widget wrap(Widget child, double value) {
    double scale = lerpDouble(start, end, value)!;
    return Transform.scale(
      scale: scale,
      alignment: alignment,
      child: child,
    );
  }
}

class TranslateProperty implements EntryProperty {
  final Offset start;
  final Offset end;

  const TranslateProperty(this.start, this.end);

  @override
  Widget wrap(Widget child, double value) {
    Offset offset = Offset.lerp(start, end, value)!;
    return Transform.translate(
      offset: offset,
      child: child,
    );
  }
}

class FractionallyTranslateProperty implements EntryProperty {
  final Offset start;
  final Offset end;

  const FractionallyTranslateProperty(this.start, this.end);

  @override
  Widget wrap(Widget child, double value) {
    Offset offset = Offset.lerp(start, end, value)!;
    return FractionalTranslation(
      translation: offset,
      child: child,
    );
  }
}

class RotateProperty implements EntryProperty {
  final double start;
  final double end;
  final AlignmentGeometry? alignment;

  const RotateProperty(this.start, this.end, {this.alignment});

  @override
  Widget wrap(Widget child, double value) {
    double angle = lerpDouble(start, end, value)!;
    return Transform.rotate(
      angle: angle,
      alignment: alignment,
      child: child,
    );
  }
}

class OpaqueProperty implements EntryProperty {
  final double start;
  final double end;

  const OpaqueProperty(this.start, this.end);

  @override
  Widget wrap(Widget child, double value) {
    double opacity = lerpDouble(start, end, value)!;
    return Opacity(
      opacity: opacity,
      child: child,
    );
  }
}

class ChainedCurve extends Curve {
  final Curve first;
  final Curve second;

  const ChainedCurve(this.first, this.second);

  @override
  double transformInternal(double t) {
    return second.transform(first.transform(t));
  }
}

class Entry extends StatelessWidget {
  final Iterable<EntryProperty> inProperties;
  final Iterable<EntryProperty> outProperties;
  final Curve curve;
  final Curve? reverseCurve;
  final Duration duration;
  final Duration? reverseDuration;
  final Widget child;
  final Duration delay;
  final Duration? reverseDelay;
  final bool? visible;

  const Entry.scale({
    super.key,
    this.inProperties = const [
      ScaleProperty(0.0, 1.0, alignment: Alignment.center),
    ],
    this.outProperties = const [
      ScaleProperty(1.0, 0.0, alignment: Alignment.center),
    ],
    this.curve = Curves.bounceOut,
    this.reverseCurve = Curves.easeIn,
    this.duration = const Duration(milliseconds: 700),
    this.reverseDuration = const Duration(milliseconds: 200),
    this.delay = Duration.zero,
    this.reverseDelay,
    this.visible,
    required this.child,
  });

  const Entry.fade({
    super.key,
    this.inProperties = const [
      OpaqueProperty(0.0, 1.0),
    ],
    this.outProperties = const [
      OpaqueProperty(1.0, 0.0),
    ],
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 300),
    this.delay = Duration.zero,
    this.reverseDelay,
    required this.child,
    this.reverseCurve,
    this.reverseDuration,
    this.visible,
  });

  @override
  Widget build(BuildContext context) {
    final gameScreenInfo = Data.of<GameScreenInfo>(context);
    var visible = this.visible ?? gameScreenInfo.visible;
    double delayValue;
    // delay.inMilliseconds / (duration + delay).inMilliseconds;
    if (visible) {
      delayValue = delay.inMilliseconds / (duration + delay).inMilliseconds;
    } else {
      delayValue = (reverseDelay ?? delay).inMilliseconds /
          ((reverseDuration ?? duration) + (reverseDelay ?? delay))
              .inMilliseconds;
    }
    var valueDuration = visible
        ? (duration + delay)
        : ((reverseDuration ?? duration) + (reverseDelay ?? delay));
    return AnimatedValueBuilder(
      initialValue: 0.0,
      value: visible ? 1.0 : 0.0,
      curve: ChainedCurve(
        visible ? Interval(delayValue, 1.0) : Interval(0.0, 1.0 - delayValue),
        visible ? curve : reverseCurve ?? curve,
      ),
      duration: valueDuration,
      builder: (context, value, child) {
        Widget result = this.child;
        if (visible) {
          for (EntryProperty property in inProperties) {
            result = property.wrap(result, value);
          }
        } else {
          for (EntryProperty property in outProperties) {
            result = property.wrap(result, 1 - value);
          }
        }
        return result;
      },
    );
  }
}

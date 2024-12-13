import 'dart:math';

import 'package:animation_toolkit/animation_toolkit.dart';
import 'package:flutter/widgets.dart';
import 'package:kiddoquest2/assets/images.dart';
import 'package:kiddoquest2/ui/components/outlined_text.dart';
import 'package:kiddoquest2/ui/music_scene.dart';

import '../../assets/theme.dart';

class RoundCountdown extends StatefulWidget {
  final double value;
  final Duration duration;

  const RoundCountdown(
      {super.key, required this.value, required this.duration});

  @override
  State<RoundCountdown> createState() => _RoundCountdownState();
}

class _RoundCountdownState extends State<RoundCountdown> {
  int secondsDuration = 0;

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() {
    final newSecondsDuration =
        (widget.duration.inSeconds * (1 - widget.value)).ceil();
    if (newSecondsDuration != secondsDuration) {
      secondsDuration = newSecondsDuration;
      playCountdown(secondsDuration);
    }
  }

  @override
  void didUpdateWidget(covariant RoundCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    _update();
  }

  @override
  Widget build(BuildContext context) {
    if (secondsDuration > 5 || secondsDuration <= 0) {
      return const SizedBox();
    }
    return Stack(
      children: [
        Positioned.fill(
          child: Center(
            child: AnimatedValueBuilder(
                initialValue: 0.0,
                value: 1.0,
                duration: const Duration(seconds: 1),
                builder: (context, scale, child) {
                  return RepeatedAnimationBuilder(
                    start: 0.0,
                    end: 360.0,
                    duration: Duration(seconds: 5),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: scale,
                        child: Transform.rotate(
                          angle: value / 180 * pi,
                          child: imageShine1.createImage(
                              fit: BoxFit.fill, width: 500, height: 500),
                        ),
                      );
                    },
                  );
                }),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: AnimatedValueBuilder(
                initialValue: 0.0,
                value: 1.0,
                duration: const Duration(seconds: 2),
                builder: (context, scale, child) {
                  return RepeatedAnimationBuilder(
                    start: 360.0,
                    end: 0.0,
                    duration: Duration(seconds: 10),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: scale,
                        child: Transform.rotate(
                          angle: value / 180 * pi,
                          child: imageShine2.createImage(
                              fit: BoxFit.fill, width: 500, height: 500),
                        ),
                      );
                    },
                  );
                }),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: AnimatedValueBuilder(
                key: ValueKey(secondsDuration),
                initialValue: 0.0,
                value: 1.0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: DefaultTextStyle(
                      style: TextStyle(
                          fontSize: 300,
                          color: colorStrongYellow,
                          fontFamily: 'MoreSugar'),
                      child: OutlinedText(
                        child: Text(
                          '$secondsDuration',
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}

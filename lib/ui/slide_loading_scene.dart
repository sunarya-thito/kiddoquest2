import 'package:animation_toolkit/animation_toolkit.dart';
import 'package:data_widget/data_widget.dart';
import 'package:flutter/material.dart';
import 'package:kiddoquest2/assets/theme.dart';

import 'game_screen.dart';

class SlideLoadingScene extends StatefulWidget {
  const SlideLoadingScene({Key? key}) : super(key: key);

  @override
  State<SlideLoadingScene> createState() => _SlideLoadingSceneState();
}

class _SlideLoadingSceneState extends State<SlideLoadingScene>
    with SingleTickerProviderStateMixin {
  final List<Color> colors = [
    colorYellow,
    colorPurple,
    colorTeal,
    Colors.white,
  ];

  late List<TimelineAnimation<Rect>> _animation;
  late List<TimelineAnimation<Rect>> _reverseAnimation;

  @override
  void initState() {
    super.initState();
    colors.shuffle();
    _animation = List.generate(colors.length, (index) {
      final beginStart = Rect.fromLTWH(0, 0, 0, 1); // relative to the screen
      final beginEnd = Rect.fromLTWH(0, 0, 1, 1); // relative to the screen
      final initialDelay = Duration(milliseconds: 500 * index);
      final extraDelay = Duration(milliseconds: 500 * (colors.length - index));
      final keyframes = [
        StillKeyframe<Rect>(
          initialDelay,
          beginStart,
        ),
        AbsoluteKeyframe<Rect>(
          Duration(seconds: 1) + extraDelay,
          beginStart,
          beginEnd,
        ),
      ];
      return TimelineAnimation<Rect>(
        keyframes: keyframes,
        lerp: Rect.lerp,
      );
    });
    _reverseAnimation = List.generate(colors.length, (index) {
      final endStart = Rect.fromLTWH(0, 0, 1, 1); // relative to the screen
      final endEnd = Rect.fromLTWH(1, 0, 0, 1); // relative to the screen
      final initialDelay =
          Duration(milliseconds: 500 * (colors.length - index));
      final extraDelay = Duration(milliseconds: 500 * index);
      final keyframes = [
        StillKeyframe<Rect>(
          initialDelay,
          endStart,
        ),
        AbsoluteKeyframe<Rect>(
          const Duration(seconds: 1) + extraDelay,
          endStart,
          endEnd,
        ),
      ];
      return TimelineAnimation<Rect>(
        keyframes: keyframes,
        lerp: Rect.lerp,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameScreenInfo = Data.of<GameScreenInfo>(context);
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final height = constraints.maxHeight;
      return Stack(
        children: [
          for (var i = 0; i < colors.length; i++)
            Builder(
              builder: (context) {
                final animation = (gameScreenInfo.showLoading
                        ? _animation[i]
                        : _reverseAnimation[i])
                    .transform(gameScreenInfo.showLoading
                        ? gameScreenInfo.progress
                        : 1 - gameScreenInfo.progress);
                return Positioned(
                  left: width * animation.left,
                  top: height * animation.top,
                  child: Container(
                    color: colors[i],
                    width: width * animation.width,
                    height: height * animation.height,
                    alignment: Alignment.topLeft,
                  ),
                );
              },
            ),
        ],
      );
    });
  }
}

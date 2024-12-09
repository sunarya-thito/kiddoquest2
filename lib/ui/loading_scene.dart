import 'dart:math';

import 'package:data_widget/data_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:kiddoquest2/assets/asset_manager.dart';
import 'package:kiddoquest2/assets/audios.dart';
import 'package:kiddoquest2/assets/theme.dart';
import 'package:kiddoquest2/ui/game_screen.dart';
import 'package:kiddoquest2/ui/music_scene.dart';

import '../assets/images.dart';
import 'components/background_pattern.dart';
import 'components/curly_circle.dart';
import 'components/entry.dart';
import 'components/logo.dart';

class LoadingScene extends StatelessWidget {
  static List<AnimationAsset> loadingAnimations = [
    imageLoading1,
    imageLoading2,
    imageLoading3,
    imageLoading4,
    imageLoading5,
    imageLoading6,
    imageLoading7,
  ];

  const LoadingScene({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MusicScene(
      music: bgmSettings,
      child: DataBuilder<GameScreenInfo>(
        builder: (context, gameScreenInfo, child) {
          return ClipOval(
            clipper: ClipOvalClipper(gameScreenInfo.progress),
            child: child!,
          );
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: BackgroundPattern(
                imageAsset: imageStar,
                color: colorYellowDark,
              ),
            ),
            Positioned(
              bottom: -450,
              left: -100,
              width: 900,
              height: 900,
              child: Entry.scale(
                reverseDelay: Duration(milliseconds: 500),
                child: CurlyCircle(
                  points: 12,
                  radius: 0.85,
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              left: 100,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Entry.fade(
                    delay: Duration(milliseconds: 500),
                    reverseDelay: Duration.zero,
                    child: SizedBox(
                      width: 250,
                      height: 250,
                      child: _RandomLoadingAnimation(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Entry.fade(
                    delay: Duration(milliseconds: 500),
                    reverseDelay: Duration.zero,
                    curve: Curves.linear,
                    inProperties: [
                      OpaqueProperty(0, 1),
                    ],
                    outProperties: [
                      OpaqueProperty(1, 0),
                    ],
                    child: DefaultTextStyle(
                      style: TextStyle(
                        fontFamily: 'MoreSugar',
                        fontSize: 48,
                      ),
                      child: Text(
                        'Sedang memuat konten...',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: -70,
              right: 40,
              width: 600,
              height: 600,
              child: KiddoQuestLogo(),
            ),
          ],
        ),
      ),
    );
  }
}

class _RandomLoadingAnimation extends StatefulWidget {
  @override
  State<_RandomLoadingAnimation> createState() =>
      _RandomLoadingAnimationState();
}

class _RandomLoadingAnimationState extends State<_RandomLoadingAnimation> {
  late int _index;

  @override
  void initState() {
    super.initState();
    Random random = Random();
    _index = random.nextInt(LoadingScene.loadingAnimations.length);
  }

  @override
  Widget build(BuildContext context) {
    return LoadingScene.loadingAnimations[_index].createImage(
      fit: BoxFit.contain,
    );
  }
}

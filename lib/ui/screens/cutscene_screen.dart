import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:kiddoquest2/assets/audios.dart';
import 'package:kiddoquest2/ui/music_scene.dart';
import 'package:video_player/video_player.dart';

import 'game_session_screen.dart';

class CutsceneScreen extends StatefulWidget {
  final VideoPlayerController video;
  final FutureOr<Widget> Function() onContinue;

  const CutsceneScreen(
      {Key? key, required this.video, required this.onContinue})
      : super(key: key);

  @override
  State<CutsceneScreen> createState() => _CutsceneScreenState();
}

class _CutsceneScreenState extends State<CutsceneScreen> {
  @override
  void initState() {
    super.initState();
    widget.video.addListener(() {
      if (widget.video.value.isInitialized &&
          widget.video.value.position >= widget.video.value.duration) {
        GameSessionScreen.nextScreen(
          context,
          widget.onContinue(),
        );
      }
    });
    Future.delayed(Duration(seconds: 1, milliseconds: 500), () {
      widget.video.play();
    });
  }

  @override
  void dispose() {
    widget.video.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MusicScene(
      music: bgmGameMode1,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          GameSessionScreen.nextScreen(
            context,
            widget.onContinue(),
          );
        },
        child: VideoPlayer(widget.video),
      ),
    );
  }
}

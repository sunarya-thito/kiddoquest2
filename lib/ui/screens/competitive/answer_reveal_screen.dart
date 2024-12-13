import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kiddoquest2/assets/audios.dart';
import 'package:kiddoquest2/game.dart';
import 'package:kiddoquest2/ui/components/curly_circle.dart';
import 'package:kiddoquest2/ui/components/outlined_text.dart';
import 'package:kiddoquest2/ui/music_scene.dart';
import 'package:kiddoquest2/ui/screens/competitive/game_round_screen.dart';
import 'package:kiddoquest2/ui/screens/competitive/players_screen.dart';

import '../../components/entry.dart';
import '../../components/menu_button.dart';
import '../../slide_loading_scene.dart';
import '../game_session_screen.dart';

class AnswerRevealScreen extends StatefulWidget {
  final GameRound gameRound;
  final FutureOr<Widget> onEnd;

  const AnswerRevealScreen(
      {super.key, required this.gameRound, required this.onEnd});

  @override
  State<AnswerRevealScreen> createState() => _AnswerRevealScreenState();
}

class _AnswerRevealScreenState extends State<AnswerRevealScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    _controller.forward().then((value) {
      GameSessionScreen.nextScreen(
        context,
        widget.onEnd,
        delay: Duration.zero,
        duration: Duration(milliseconds: 500),
        reverseDuration: Duration(milliseconds: 500),
        loadingScreen: SlideLoadingScene(),
      );
    });
    Future.delayed(Duration(seconds: 1), () async {
      await playVoiceline(tamaRoundEndReveal);
      await widget.gameRound.playCorrectTTS();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: CompetitiveBackgroundPattern(),
        ),
        Positioned(
          top: 50,
          left: 50,
          child: MenuIconButton(
              onPressed: () {
                GameSessionScreen.of(context).pause(true);
              },
              icon: Icon(Icons.pause)),
        ),
        const Positioned(
          top: 300,
          left: 0,
          right: 0,
          bottom: 0,
          child: OverflowBox(
            minWidth: 0,
            minHeight: 0,
            maxWidth: double.infinity,
            maxHeight: double.infinity,
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 4500,
              height: 4500,
              child: CurlyCircle(
                points: 16,
                radius: 0.9,
              ),
            ),
          ),
        ),
        Positioned.fill(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Entry.scale(
              child: DefaultTextStyle(
                style: TextStyle(
                    fontSize: 100,
                    color: Colors.white,
                    fontFamily: 'MoreSugar'),
                textAlign: TextAlign.center,
                child: OutlinedText(
                  child: Text(
                    widget.gameRound.question,
                    maxLines: 3,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            ),
            Entry.scale(
              delay: const Duration(seconds: 3),
              duration: const Duration(milliseconds: 400),
              child: SizedBox(
                width: 700,
                height: 700,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: AnswerWidget(
                    answer: AnswerData(
                        widget.gameRound.correctAnswer.content.textContent,
                        widget.gameRound.correctAnswer.content.imageContent,
                        true),
                    fill: false,
                  ),
                ),
              ),
            ),
          ],
        ))
      ],
    );
  }
}

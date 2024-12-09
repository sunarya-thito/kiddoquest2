import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kiddoquest2/game.dart';
import 'package:kiddoquest2/ui/screens/competitive/player_list_screen.dart';
import 'package:kiddoquest2/ui/screens/competitive/players_screen.dart';
import 'package:kiddoquest2/ui/screens/competitive/round_screen.dart';

import '../../components/entry.dart';
import '../../components/menu_button.dart';
import '../../components/outlined_text.dart';
import '../../slide_loading_scene.dart';
import '../game_session_screen.dart';

class RoundScoreScreen extends StatelessWidget {
  final int round;
  final FutureOr<Widget> onContinue;
  final bool slide;

  const RoundScoreScreen(
      {super.key,
      required this.round,
      required this.onContinue,
      this.slide = true});

  @override
  Widget build(BuildContext context) {
    var players = GameSessionScreen.of(context).game.players.value;
    return Stack(
      children: [
        Positioned.fill(
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
        Positioned(
          top: 25,
          right: 25,
          child: SizedBox(
            width: 250,
            height: 250,
            child: FittedBox(
              fit: BoxFit.fill,
              child: GameRoundCounter(
                round: round,
              ),
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Entry.scale(
                child: DefaultTextStyle(
                  style: TextStyle(
                      fontSize: 100,
                      color: Colors.white,
                      fontFamily: 'MoreSugar'),
                  child: OutlinedText(
                    child: Text('Perolehan Nilai'),
                  ),
                ),
              ),
              PlayerListScene(
                faces: players,
                showName: true,
                showScore: true,
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 80,
          right: -10,
          child: Entry.scale(
            inProperties: [
              ScaleProperty(0.0, 1.0, alignment: Alignment.centerRight),
            ],
            outProperties: [
              ScaleProperty(1.0, 0.0, alignment: Alignment.centerRight),
            ],
            delay: Duration(seconds: 2),
            child: MenuButton(
              label: Text('Lanjutkan'),
              width: 400,
              type: MenuButtonType.right,
              onPressed: () {
                for (final player in players) {
                  (player as CompetitivePlayer).score.value +=
                      player.currentRoundScore.value;
                }
                if (slide) {
                  GameSessionScreen.of(context).nextScreen(
                    onContinue,
                    delay: Duration.zero,
                    duration: Duration(milliseconds: 500),
                    reverseDuration: Duration(milliseconds: 500),
                    loadingScreen: SlideLoadingScene(),
                  );
                } else {
                  GameSessionScreen.of(context).nextScreen(onContinue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

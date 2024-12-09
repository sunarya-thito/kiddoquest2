import 'package:flutter/material.dart';
import 'package:kiddoquest2/assets/images.dart';
import 'package:kiddoquest2/assets/theme.dart';
import 'package:kiddoquest2/ui/components/curly_circle.dart';
import 'package:kiddoquest2/ui/music_scene.dart';
import 'package:kiddoquest2/ui/screens/competitive/game_round_screen.dart';
import 'package:kiddoquest2/ui/screens/competitive/players_screen.dart';
import 'package:kiddoquest2/ui/slide_loading_scene.dart';

import '../../../assets/audios.dart';
import '../../components/entry.dart';
import '../../components/menu_button.dart';
import '../../components/outlined_text.dart';
import '../game_session_screen.dart';

class RoundScreen extends StatefulWidget {
  final int round;

  const RoundScreen({
    super.key,
    required this.round,
  });

  @override
  State<RoundScreen> createState() => _RoundScreenState();
}

class _RoundScreenState extends State<RoundScreen>
    with SingleTickerProviderStateMixin {
  static const duration = Duration(seconds: 4);
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: duration,
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onDone();
      }
    });
    _controller.forward();
  }

  void _onDone() {
    GameSessionScreen.nextScreen(
      context,
      GameRoundScreen(round: widget.round),
      loadingScreen: const SlideLoadingScene(),
      delay: Duration.zero,
      duration: Duration(milliseconds: 500),
      reverseDuration: Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MusicScene(
      music: bgmGameMode1,
      child: Stack(
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
          Center(
              child: GameRoundCounter(
            round: widget.round,
          ))
        ],
      ),
    );
  }
}

class GameRoundCounter extends StatelessWidget {
  const GameRoundCounter({
    super.key,
    required this.round,
  });

  final int round;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 800,
      height: 800,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Entry.scale(
              delay: Duration(milliseconds: 300),
              child: CurlyCircle(),
            ),
          ),
          Positioned(
            left: 200,
            right: 200,
            top: -30,
            child: Entry.scale(
              delay: Duration(milliseconds: 600),
              child: imageRound.createImage(fit: BoxFit.fill),
            ),
          ),
          // outlined text
          Positioned(
            top: 200,
            left: 0,
            right: 0,
            child: Center(
              child: DefaultTextStyle(
                style: TextStyle(
                    color: colorStrongYellow, fontFamily: 'MoreSugar'),
                child: Entry.scale(
                  delay: Duration(milliseconds: 900),
                  child: OutlinedText(
                    strokeWidth: 25,
                    child:
                        Text(round.toString(), style: TextStyle(fontSize: 450)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:animation_toolkit/animation_toolkit.dart';
import 'package:data_widget/data_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:kiddoquest2/assets/audios.dart';
import 'package:kiddoquest2/game.dart';
import 'package:kiddoquest2/ui/game_screen.dart';
import 'package:kiddoquest2/ui/loading_scene.dart';
import 'package:kiddoquest2/ui/music_scene.dart';
import 'package:kiddoquest2/ui/screens/pause_screen.dart';

class GameSessionScreen extends StatefulWidget {
  final FutureOr<Widget> child;
  final Game game;
  const GameSessionScreen({
    Key? key,
    required this.child,
    required this.game,
  }) : super(key: key);

  @override
  State<GameSessionScreen> createState() => GameSessionScreenState();

  static GameSessionScreenState of(BuildContext context) {
    return Data.of<GameSessionScreenState>(context);
  }

  static void nextScreen(BuildContext context, FutureOr<Widget> screen,
      {Widget? loadingScreen,
      Duration? duration,
      Duration? reverseDuration,
      Duration? delay}) {
    of(context).nextScreen(screen,
        loadingScreen: loadingScreen,
        duration: duration,
        reverseDuration: reverseDuration,
        delay: delay);
  }
}

class ScreenQueue {
  final FutureOr<Widget> screen;
  final Widget? loadingScreen;
  final Duration? duration;
  final Duration? reverseDuration;
  final Duration? delay;

  ScreenQueue(this.screen,
      {this.loadingScreen, this.duration, this.reverseDuration, this.delay});
}

extension GameSessionScreenContext on BuildContext {
  GameSessionScreenState get gameSession => GameSessionScreen.of(this);
}

class GameSessionScreenState extends State<GameSessionScreen> {
  // late ScreenQueue currentScreen;
  final List<ScreenQueue> screenQueue = [];
  final List<Widget> overlays = [];
  Game get game => widget.game;
  final ValueNotifier<bool> paused = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    screenQueue.add(ScreenQueue(widget.child));
  }

  void pushOverlay(Widget overlay) {
    setState(() {
      overlays.add(overlay);
    });
  }

  void removeOverlay(Widget overlay) {
    setState(() {
      overlays.remove(overlay);
    });
  }

  void nextScreen(FutureOr<Widget> screen,
      {Widget? loadingScreen,
      Duration? duration,
      Duration? reverseDuration,
      Duration? delay}) {
    setState(() {
      screenQueue.add(ScreenQueue(screen,
          loadingScreen: loadingScreen,
          duration: duration,
          reverseDuration: reverseDuration,
          delay: delay));
    });
  }

  void popScreen() {
    setState(() {
      screenQueue.removeLast();
    });
  }

  void pause(bool pause) {
    paused.value = pause;
  }

  @override
  Widget build(BuildContext context) {
    final currentScreen = screenQueue.last;
    return Data.inherit(
      data: this,
      child: ListenableBuilder(
          listenable: paused,
          builder: (context, child) {
            return MusicScene(
              music: bgmPauseMenu,
              play: paused.value,
              child: Stack(
                children: [
                  TickerMode(
                    enabled: !paused.value,
                    child: GameScreen(
                      loadingChild:
                          currentScreen.loadingScreen ?? const LoadingScene(),
                      duration:
                          currentScreen.duration ?? const Duration(seconds: 1),
                      reverseDuration: currentScreen.reverseDuration ??
                          const Duration(seconds: 1),
                      delay: currentScreen.delay ??
                          const Duration(milliseconds: 300),
                      child: currentScreen.screen,
                    ),
                  ),
                  Positioned.fill(
                    child: AnimatedValueBuilder(
                      value: paused.value ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        if (value == 0) {
                          return const SizedBox();
                        }
                        return Data.inherit(
                          data: GameScreenInfo(
                            visible: (paused.value && value > 0.8) ||
                                (!paused.value && value < 0.2),
                            progress: value,
                            showLoading: false,
                          ),
                          child: ClipOval(
                            clipper: PauseClipper(
                                center: Offset(100, 100), progress: value),
                            child: PauseScreen(),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}

Future<Game> createGame(String id) async {
  await Future.delayed(Duration(seconds: 2));
  CompetitiveGame game =
      CompetitiveGame('Quiz Pengetahuan Umum', Duration(seconds: 10));
  // format is wrong answer, correct answer
  game.rounds.add(GameRound(
      'Hewan pemakan daging',
      GameRoundAnswer(AnswerContent('Kuda',
          'https://png.pngtree.com/png-clipart/20201112/ourmid/pngtree-hand-drawn-cartoon-goat-clipart-animal-illustration-png-image_2419046.jpg')),
      GameRoundAnswer(AnswerContent('Singa',
          'https://png.pngtree.com/png-clipart/20230819/original/pngtree-cute-lion-cartoon-on-white-background-picture-image_8052533.png')),
      null));
  game.rounds.add(GameRound(
      'Hewan pemakan tumbuhan',
      GameRoundAnswer(AnswerContent('Singa', null)),
      GameRoundAnswer(AnswerContent('Kambing', null)),
      null));
  game.rounds.add(GameRound(
      '1 + 1 = ?',
      GameRoundAnswer(AnswerContent('3', null)),
      GameRoundAnswer(AnswerContent('2', null)),
      null));
  game.rounds.add(GameRound(
      '2 + 2 = ?',
      GameRoundAnswer(AnswerContent('9', null)),
      GameRoundAnswer(AnswerContent('4', null)),
      null));
  game.rounds.shuffle();
  return game;
}

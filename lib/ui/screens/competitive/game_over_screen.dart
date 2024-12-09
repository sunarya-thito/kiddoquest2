import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:animation_toolkit/animation_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kiddoquest2/assets/asset_manager.dart';
import 'package:kiddoquest2/assets/images.dart';
import 'package:kiddoquest2/assets/theme.dart';
import 'package:kiddoquest2/game.dart';
import 'package:kiddoquest2/ui/components/outlined_text.dart';
import 'package:kiddoquest2/ui/game_app.dart';
import 'package:kiddoquest2/ui/screens/competitive/players_screen.dart';
import 'package:kiddoquest2/ui/screens/game_session_screen.dart';

import '../../components/logo.dart';
import '../../components/menu_button.dart';

Future<void> loadGameMode1GameOverResources() async {
  await loadAll([
    imageFrame1,
    imageFrame2,
    imageFrame3,
    imageFrame4,
    imageTrophyGold,
    imageTrophySilver,
    imageTrophyBronze,
  ]);
}

class GameOverScreen extends StatefulWidget {
  const GameOverScreen({super.key});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

final List<ImageAsset> imageFrames = [
  imageFrame1,
  imageFrame2,
  imageFrame3,
  imageFrame4,
];

class _GameOverScreenState extends State<GameOverScreen> {
  @override
  Widget build(BuildContext context) {
    final game = GameSessionScreen.of(context).game;
    List<Player> players = List.of(game.players.value);
    players.sort((a, b) => (b as CompetitivePlayer)
        .score
        .value
        .compareTo((a as CompetitivePlayer).score.value));
    return Stack(
      children: [
        Positioned.fill(
          child: CompetitiveBackgroundPattern(),
        ),
        Positioned.fill(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(100),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.scale(
                    scale: 0.9,
                    child: StageLeaderboard(game: game),
                  ),
                  const SizedBox(height: 100),
                  DefaultTextStyle(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontFamily: 'MoreSugar',
                    ),
                    child: Text('Scroll ke bawah untuk melihat daftar lengkap'),
                  ),
                  RepeatedAnimationBuilder(
                    start: 0.0,
                    end: 1.0,
                    duration: Duration(milliseconds: 500),
                    mode: RepeatMode.pingPong,
                    curve: Curves.easeInOut,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, 20 * value),
                        child: const Icon(Icons.keyboard_double_arrow_down,
                            color: Colors.white, size: 50),
                      );
                    },
                  ),
                  const SizedBox(height: 50),
                  for (var i = 0; i < players.length; i++)
                    PlayerTile(
                      player: players[i] as CompetitivePlayer,
                      index: i,
                    ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: -15,
          right: 25,
          child: Transform.scale(
            scale: 0.7,
            alignment: Alignment.topRight,
            child: SizedBox(
              width: 600,
              height: 600,
              child: KiddoQuestLogo(
                yellowBackground: true,
              ),
            ),
          ),
        ),
        Positioned(
          top: 50,
          left: 50,
          child: MenuIconButton(
              onPressed: () {
                context.go('/');
              },
              icon: Icon(Icons.close)),
        ),
        Positioned(
          bottom: 80,
          right: 80,
          child: DownloadButton(game: game),
        ),
      ],
    );
  }
}

class StageLeaderboard extends StatelessWidget {
  final Game game;

  const StageLeaderboard({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    final players = List.of(game.players.value);
    players.sort((a, b) => (b as CompetitivePlayer)
        .score
        .value
        .compareTo((a as CompetitivePlayer).score.value));
    // Player? top1 = players.isNotEmpty ? players.last : null;
    // Player? top2 = players.length > 1 ? players[players.length - 2] : null;
    // Player? top3 = players.length > 2 ? players[players.length - 3] : null;
    Player? top1 = players.isNotEmpty ? players.first : null;
    Player? top2 = players.length > 1 ? players[1] : null;
    Player? top3 = players.length > 2 ? players[2] : null;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (top2 != null)
          Transform.translate(
            offset: Offset(0, 50),
            child: Padding(
              padding: const EdgeInsets.all(50),
              child: StageScore(
                stage: 2,
                stageColor: colorSilver,
                trophyImage: imageTrophySilver,
                image: top2.faceImage,
                name: top2.character.value!.name,
                frameImage: imageFrames[1],
              ),
            ),
          ),
        if (top1 != null)
          Padding(
            padding: const EdgeInsets.all(50),
            child: StageScore(
              stage: 1,
              stageColor: colorYellowDark,
              trophyImage: imageTrophyGold,
              image: top1.faceImage,
              name: top1.character.value!.name,
              frameImage: imageFrames[0],
            ),
          ),
        if (top3 != null)
          Transform.translate(
            offset: Offset(0, 100),
            child: Padding(
              padding: const EdgeInsets.all(50),
              child: StageScore(
                stage: 3,
                stageColor: colorBronze,
                trophyImage: imageTrophyBronze,
                image: top3.faceImage,
                name: top3.character.value!.name,
                frameImage: imageFrames[2],
              ),
            ),
          ),
      ],
    );
  }
}

class StageScore extends StatelessWidget {
  final int stage;
  final Color stageColor;
  final ImageAsset trophyImage;
  final Uint8List image;
  final String name;
  final ImageAsset frameImage;

  const StageScore({
    super.key,
    required this.stage,
    required this.stageColor,
    required this.trophyImage,
    required this.image,
    required this.name,
    required this.frameImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DefaultTextStyle(
          style: TextStyle(
              color: stageColor,
              fontSize: 150,
              fontFamily: 'MoreSugar',
              shadows: [
                Shadow(
                  color: _darkenColor(stageColor, 0.5).withOpacity(0.5),
                  offset: const Offset(10, 10),
                  blurRadius: 0,
                ),
              ]),
          child: Text('#$stage'),
        ),
        DefaultTextStyle(
          style: TextStyle(
            color: Colors.white,
            fontSize: 50,
            fontFamily: 'MoreSugar',
          ),
          child: Text(name),
        ),
        Transform.translate(
          offset: Offset(0, -40),
          child: PlayerFrame(
              image: image, frameImage: frameImage, trophyImage: trophyImage),
        )
      ],
    );
  }
}

class DownloadButton extends StatefulWidget {
  final Game game;
  const DownloadButton({super.key, required this.game});

  @override
  State<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _hover = true;
        });
      },
      onExit: (_) {
        setState(() {
          _hover = false;
        });
      },
      child: GestureDetector(
        onTap: widget.game.downloadReport,
        child: AnimatedScale(
          scale: _hover ? 1.1 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Column(
            children: [
              Icon(
                Icons.download,
                color: Colors.white,
                size: 200,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(5, 5),
                    blurRadius: 0,
                  ),
                ],
              ),
              DefaultTextStyle(
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily: 'MoreSugar',
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(5, 5),
                        blurRadius: 0,
                      ),
                    ]),
                child: Text(
                  'Unduh Hasil Permainan',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlayerTile extends StatelessWidget {
  final CompetitivePlayer player;
  final int index;
  const PlayerTile({
    super.key,
    required this.player,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Row(
              children: [
                // score text
                SizedBox(
                  width: 300,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Transform.rotate(
                      angle: -3 * pi / 180,
                      alignment: Alignment.center,
                      child: DefaultTextStyle(
                        style: TextStyle(
                          color: colorStrongYellow,
                          fontSize: 150,
                          fontFamily: 'MoreSugar',
                        ),
                        child:
                            OutlinedText(child: Text('+${player.score.value}')),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 50),
                // player image
                PlayerFrame(
                  image: player.faceImage,
                  frameImage: imageFrames[index % imageFrames.length],
                ),
                const SizedBox(width: 50),
                // player name
                Transform.rotate(
                  angle: -3 * pi / 180,
                  alignment: Alignment.center,
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 100,
                      fontFamily: 'MoreSugar',
                    ),
                    child: Text(player.character.value!.name),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlayerFrame extends StatelessWidget {
  const PlayerFrame({
    super.key,
    required this.image,
    required this.frameImage,
    this.trophyImage,
  });

  final Uint8List image;
  final ImageAsset frameImage;
  final ImageAsset? trophyImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 400,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 75,
            bottom: 80,
            left: 30,
            right: 25,
            child: Transform.rotate(
              angle: -3 * pi / 180,
              alignment: Alignment.center,
              child: Image.memory(
                image,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned.fill(
              child: frameImage.createImage(
            fit: BoxFit.fill,
          )),
          if (trophyImage != null)
            Positioned(
              bottom: -50,
              left: -50,
              width: 250,
              height: 250,
              child: trophyImage!.createImage(fit: BoxFit.fill),
            ),
        ],
      ),
    );
  }
}

Color _darkenColor(Color c, double f) {
  assert(f >= 0 && f <= 1);
  return Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(),
      (c.blue * f).round());
}

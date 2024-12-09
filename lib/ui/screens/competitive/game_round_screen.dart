import 'dart:math';

import 'package:data_widget/data_widget.dart';
import 'package:face_api_web/face_api_web.dart';
import 'package:flutter/material.dart';
import 'package:kiddoquest2/assets/images.dart';
import 'package:kiddoquest2/assets/theme.dart';
import 'package:kiddoquest2/ui/screens/competitive/game_over_screen.dart';
import 'package:kiddoquest2/ui/screens/competitive/players_screen.dart';
import 'package:kiddoquest2/ui/screens/competitive/round_score_screen.dart';
import 'package:kiddoquest2/ui/screens/competitive/round_screen.dart';
import 'package:kiddoquest2/ui/slide_loading_scene.dart';

import '../../../game.dart';
import '../../components/entry.dart';
import '../../components/menu_button.dart';
import '../../components/outlined_text.dart';
import '../game_session_screen.dart';
import 'answer_reveal_screen.dart';

class GameRoundScreen extends StatefulWidget {
  final int round;

  const GameRoundScreen({
    super.key,
    required this.round,
  });

  @override
  State<GameRoundScreen> createState() => _GameRoundScreenState();
}

class _FaceScoreSection {
  final FaceScore faceScore;
  final bool isLeft;

  _FaceScoreSection(this.faceScore, this.isLeft);
}

class AnswerData {
  final String? text;
  final String? image;
  final bool isCorrect;

  AnswerData(this.text, this.image, this.isCorrect);
}

class _GameRoundScreenState extends State<GameRoundScreen>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<List<_FaceScoreSection>> detectedFaces =
      ValueNotifier([]);
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );
  }

  late FaceReferences _references;
  Game? _game;
  late AnswerData leftAnswer;
  late AnswerData rightAnswer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Game game = GameSessionScreen.of(context).game;
    if (_game == game) {
      return;
    }
    _game = game;
    for (Player player in game.players.value) {
      (player as CompetitivePlayer).currentRoundDurationCorrect.value =
          Duration.zero;
      player.currentRoundScore.value = 0;
    }
    _controller.duration =
        game.rounds[widget.round - 1].duration ?? game.defaultRoundDuration;
    List<FaceReference> references = [];
    for (int i = 0; i < game.players.value.length; i++) {
      Player player = game.players.value[i];
      FaceScore face = player.face;
      FaceReference reference =
          FaceReference(face.reference.references, label: i.toString());
      references.add(reference);
    }
    _references = FaceReferences(references);
    final round = game.rounds[widget.round - 1];
    Random random = Random();
    if (random.nextBool()) {
      leftAnswer = AnswerData(round.correctAnswer.content.textContent,
          round.correctAnswer.content.imageContent, true);
      rightAnswer = AnswerData(round.wrongAnswer.content.textContent,
          round.wrongAnswer.content.imageContent, false);
    } else {
      leftAnswer = AnswerData(round.wrongAnswer.content.textContent,
          round.wrongAnswer.content.imageContent, false);
      rightAnswer = AnswerData(round.correctAnswer.content.textContent,
          round.correctAnswer.content.imageContent, true);
    }
    double? previous;
    _controller.addListener(
      () {
        double delta = _controller.value - (previous ?? 0);
        previous = _controller.value;
        Duration duration = _controller.duration!;
        Duration deltaDuration = Duration(
          milliseconds: (delta * duration.inMilliseconds).round(),
        );
        // List<Player> undetected = List.of(game.players.value);
        for (_FaceScoreSection detected in detectedFaces.value) {
          String? label = detected.faceScore.reference.label;
          if (label == null) {
            continue;
          }
          int? index = double.tryParse(label)?.toInt();
          if (index == null ||
              index < 0 ||
              index >= game.players.value.length) {
            continue;
          }
          CompetitivePlayer player =
              game.players.value[index] as CompetitivePlayer;
          // undetected.remove(player);
          if (detected.isLeft) {
            if (leftAnswer.isCorrect) {
              player.currentRoundDurationCorrect.value += deltaDuration;
              player.currentRoundCorrect.value = true;
            } else {
              player.currentRoundCorrect.value = false;
            }
          } else {
            if (rightAnswer.isCorrect) {
              player.currentRoundDurationCorrect.value += deltaDuration;
              player.currentRoundCorrect.value = true;
            } else {
              player.currentRoundCorrect.value = false;
            }
          }
        }
        // for (Player unselected in undetected) {
        //   (unselected as CompetitivePlayer).currentRoundCorrect.value = false;
        // }
      },
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Game currentGame = _game!;
        int currentRound = widget.round;
        for (Player player in currentGame.players.value) {
          Duration correctDuration =
              (player as CompetitivePlayer).currentRoundDurationCorrect.value;
          if (!player.currentRoundCorrect.value) {
            player.currentRoundScore.value = 0;
            player.reports.add(PlayerReport(round, 0, round.wrongAnswer));
            continue;
          }
          double point = (correctDuration.inMilliseconds / 1000.0);
          player.reports
              .add(PlayerReport(round, point.round(), round.correctAnswer));
          player.currentRoundScore.value += point.round();
        }
        if (currentRound < currentGame.rounds.length) {
          GameSessionScreen.nextScreen(
              context,
              AnswerRevealScreen(
                  gameRound: round,
                  onEnd: RoundScoreScreen(
                      round: widget.round,
                      onContinue: RoundScreen(round: currentRound + 1))),
              delay: Duration.zero,
              duration: Duration(milliseconds: 500),
              reverseDuration: Duration(milliseconds: 500),
              loadingScreen: SlideLoadingScene());
        } else {
          GameSessionScreen.nextScreen(
              context,
              AnswerRevealScreen(
                  gameRound: round,
                  onEnd: RoundScoreScreen(
                      round: widget.round,
                      slide: false,
                      onContinue: Future(() async {
                        await loadGameMode1GameOverResources();
                        return GameOverScreen();
                      }))),
              delay: Duration.zero,
              duration: Duration(milliseconds: 500),
              reverseDuration: Duration(milliseconds: 500),
              loadingScreen: SlideLoadingScene());
        }
      }
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final CameraInfo cameraInfo = Data.of<CameraInfo>(context);
    final Game game = GameSessionScreen.of(context).game;
    final GameRound gameRound = game.rounds[widget.round - 1];
    return Stack(
      children: [
        Positioned.fill(
          child: CompetitiveBackgroundPattern(),
        ),
        ListenableBuilder(
          listenable: _controller,
          builder: (context, child) {
            return Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                value: 1 - _controller.value,
                backgroundColor: Colors.white,
                color: colorStrongYellow,
                minHeight: 50,
                borderRadius: BorderRadius.zero,
              ),
            );
          },
        ),
        Positioned.fill(
            bottom: 30,
            child: Container(
              padding: EdgeInsets.all(70),
              child: ClipPath(
                clipper: _CustomRoundedRectangleClipper(
                  radius: 70,
                  gap: 50,
                ),
                child: LayoutBuilder(builder: (context, constraints) {
                  double width = constraints.maxWidth;
                  double height = constraints.maxHeight;
                  return Stack(
                    fit: StackFit.passthrough,
                    children: [
                      FaceCameraDetector(
                        selectedCamera: cameraInfo,
                        references: _references,
                        captureMode: const MultipleFacesCaptureMode(
                          FaceDetectionModel.tinyFace,
                          features: [
                            FaceDetectionFeature.faceLandmark,
                            FaceDetectionFeature.faceDescriptor,
                            FaceDetectionFeature.faceAgeAndGender,
                          ],
                        ),
                        onFaceDetected: (faces) {
                          detectedFaces.value = faces.map((face) {
                            Rect relativeRect =
                                face.reference.references.first.boundingBox;
                            bool isLeft =
                                (relativeRect.left + relativeRect.width / 2) <
                                    0.5;
                            return _FaceScoreSection(face, isLeft);
                          }).toList();
                        },
                      ),
                      Positioned.fill(
                        child: ListenableBuilder(
                          listenable: detectedFaces,
                          builder: (context, child) {
                            int totalLeft = detectedFaces.value
                                .where((face) => face.isLeft)
                                .length;
                            int totalRight =
                                detectedFaces.value.length - totalLeft;
                            return Stack(
                              children: [
                                for (_FaceScoreSection face
                                    in detectedFaces.value)
                                  Builder(builder: (context) {
                                    var list =
                                        face.faceScore.reference.references;
                                    if (list.isEmpty) {
                                      return Container();
                                    }
                                    final relativeRect = list.first.boundingBox;
                                    var label = face.faceScore.reference.label;
                                    if (label == null) {
                                      return Container();
                                    }
                                    int? index =
                                        double.tryParse(label)?.toInt();
                                    if (index == null ||
                                        index < 0 ||
                                        index >= game.players.value.length) {
                                      return Container();
                                    }
                                    Player player = game.players.value[index];
                                    return AnimatedPositioned(
                                      duration: Duration(milliseconds: 150),
                                      curve: Curves.easeInOut,
                                      left: relativeRect.left * width,
                                      top: relativeRect.top * height - 150,
                                      width: relativeRect.width * width,
                                      height: relativeRect.height * height,
                                      child: Nametag(
                                        name: player.character.value!.name,
                                      ),
                                    );
                                  }),
                                Positioned(
                                  bottom: 25,
                                  left: width / 2 - 150,
                                  child: Entry.scale(
                                    delay: Duration(milliseconds: 500),
                                    child: DefaultTextStyle(
                                      style: TextStyle(
                                        fontSize: 120,
                                        color: colorSkyBlue,
                                        fontFamily: 'MoreSugar',
                                      ),
                                      textAlign: TextAlign.center,
                                      child: OutlinedText(
                                        child: Text(
                                          totalLeft.toString(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 25,
                                  right: width / 2 - 150,
                                  child: Entry.scale(
                                    delay: Duration(milliseconds: 500),
                                    child: DefaultTextStyle(
                                      style: TextStyle(
                                        fontSize: 120,
                                        color: colorSkyBlue,
                                        fontFamily: 'MoreSugar',
                                      ),
                                      textAlign: TextAlign.center,
                                      child: OutlinedText(
                                        child: Text(totalRight.toString()),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 25,
                        left: 25,
                        child: AnswerWidget(answer: leftAnswer),
                      ),
                      Positioned(
                        bottom: 25,
                        right: 25,
                        child: AnswerWidget(answer: rightAnswer),
                      ),
                    ],
                  );
                }),
              ),
            )),
        Positioned(
          top: 25,
          right: 25,
          child: SizedBox(
            width: 250,
            height: 250,
            child: FittedBox(
              fit: BoxFit.fill,
              child: GameRoundCounter(
                round: widget.round,
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 400,
          right: 400,
          child: Entry.scale(
            delay: Duration(milliseconds: 500),
            inProperties: [
              FractionallyTranslateProperty(Offset(0, -1), Offset(0, 0)),
            ],
            outProperties: [
              FractionallyTranslateProperty(Offset(0, 0), Offset(0, -1)),
            ],
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 10,
                  ),
                ],
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                horizontal: 100,
                vertical: 50,
              ),
              child: FittedBox(
                fit: BoxFit.contain,
                child: DefaultTextStyle(
                  style: TextStyle(
                      fontSize: 80,
                      color: colorStrongYellow,
                      fontFamily: 'MoreSugar'),
                  child: Entry.scale(
                    delay: Duration(milliseconds: 1000),
                    child: OutlinedText(
                      child: Text(gameRound.question),
                    ),
                  ),
                ),
              ),
            ),
          ),
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
      ],
    );
  }
}

class AnswerWidget extends StatelessWidget {
  final AnswerData answer;
  final bool fill;

  const AnswerWidget({
    super.key,
    required this.answer,
    this.fill = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        fit: StackFit.passthrough,
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: fill
                ? BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        spreadRadius: 10,
                      ),
                    ],
                  )
                : null,
            child: answer.image != null
                ? ClipOval(
                    clipBehavior: fill ? Clip.antiAlias : Clip.none,
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Image.network(answer.image!),
                    ),
                  )
                : answer.text == null
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.all(30),
                        child: FittedBox(
                          child: DefaultTextStyle(
                            style: const TextStyle(
                              fontSize: 80,
                              color: Colors.white,
                              fontFamily: 'MoreSugar',
                            ),
                            child: OutlinedText(
                              child: Text(answer.text ?? ''),
                            ),
                          ),
                        ),
                      ),
          ),
          if (answer.image != null)
            Positioned(
              bottom: -25,
              left: 0,
              right: 0,
              child: Center(
                child: FittedBox(
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 80,
                      color: Colors.white,
                      fontFamily: 'MoreSugar',
                    ),
                    child: OutlinedText(
                      child: Text(answer.text ?? '???'),
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}

class Nametag extends StatelessWidget {
  final String name;

  const Nametag({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Stack(
        children: [
          Positioned.fill(
            top: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 20,
                    decoration: TextDecoration.none,
                    color: Colors.white,
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -40),
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: imagePointer.createImage(fit: BoxFit.fill),
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

class _CustomRoundedRectangleClipper extends CustomClipper<Path> {
  final double radius;
  final double gap;

  _CustomRoundedRectangleClipper({
    required this.radius,
    required this.gap,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    // create 2 closed paths, in column layout, with gap
    final rect1 = Rect.fromLTWH(0, 0, size.width / 2 - gap / 2, size.height);
    final rect2 = Rect.fromLTWH(
        size.width / 2 + gap / 2, 0, size.width / 2 - gap / 2, size.height);
    path.addRRect(RRect.fromRectAndRadius(rect1, Radius.circular(radius)));
    path.addRRect(RRect.fromRectAndRadius(rect2, Radius.circular(radius)));
    return path;
  }

  @override
  bool shouldReclip(covariant _CustomRoundedRectangleClipper oldClipper) {
    return oldClipper.radius != radius || oldClipper.gap != gap;
  }
}

import 'dart:math';

import 'package:animation_toolkit/animation_toolkit.dart';
import 'package:face_api_web/face_api_web.dart';
import 'package:flutter/material.dart';
import 'package:kiddoquest2/assets/audios.dart';
import 'package:kiddoquest2/assets/images.dart';
import 'package:kiddoquest2/assets/theme.dart';
import 'package:kiddoquest2/game.dart';
import 'package:kiddoquest2/ui/components/background_pattern.dart';
import 'package:kiddoquest2/ui/components/keyboard_focus.dart';
import 'package:kiddoquest2/ui/components/menu_button.dart';
import 'package:kiddoquest2/ui/components/outlined_text.dart';
import 'package:kiddoquest2/ui/flash_loading_scene.dart';
import 'package:kiddoquest2/ui/music_scene.dart';
import 'package:kiddoquest2/ui/screens/competitive/player_list_screen.dart';
import 'package:kiddoquest2/ui/screens/game_session_screen.dart';

class PlayersScreen extends StatefulWidget {
  final CameraInfo selectedCamera;
  const PlayersScreen({super.key, required this.selectedCamera});

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  Widget buildImage(BuildContext context, Widget child) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Positioned(
          left: 40,
          right: 40,
          top: 245,
          bottom: 245,
          child: child,
        ),
        imageFilmFrame.createImage(fit: BoxFit.fill),
      ],
    );
  }

  final ValueNotifier<List<FaceScore>> faces = ValueNotifier([]);
  late CameraSession session;

  @override
  void initState() {
    super.initState();
    playVoiceline(tamaPlayerIntroduction);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardFocus(
      onProceed: () {
        lanjutkan(context);
      },
      child: MusicScene(
        music: bgmGameMode1Intro,
        child: LayoutBuilder(builder: (context, constraints) {
          return Stack(
            children: [
              Positioned.fill(
                child: CompetitiveBackgroundPattern(),
              ),
              Positioned(
                top: -100,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: constraints.maxWidth / 5,
                      height: constraints.maxHeight + 200,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            right: 0,
                            bottom: 0,
                            child: SizedBox(
                              width: constraints.maxWidth * 3 / 5,
                              height: constraints.maxHeight + 200,
                              child: buildImage(
                                  context,
                                  Container(
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: constraints.maxWidth * 3 / 5,
                      height: constraints.maxHeight + 200,
                      child: buildImage(
                        context,
                        Stack(
                          fit: StackFit.passthrough,
                          children: [
                            FaceCameraDetector(
                              selectedCamera: widget.selectedCamera,
                              captureMode: const MultipleFacesCaptureMode(
                                FaceDetectionModel.tinyFace,
                                features: [
                                  FaceDetectionFeature.faceLandmark,
                                  FaceDetectionFeature.faceDescriptor,
                                  FaceDetectionFeature.faceAgeAndGender,
                                ],
                              ),
                              onFaceDetected: (faces) {
                                this.faces.value = faces;
                              },
                              onCameraCreated: (session) {
                                this.session = session;
                              },
                            ),
                            Positioned.fill(
                              child: LayoutBuilder(
                                  builder: (context, constraints) {
                                double width = constraints.maxWidth;
                                double height = constraints.maxHeight;
                                return ListenableBuilder(
                                  listenable: faces,
                                  builder: (context, child) {
                                    List<Widget> children = [];
                                    // for (var face in faces.value) {
                                    for (int i = 0;
                                        i < faces.value.length;
                                        i++) {
                                      final face = faces.value[i];
                                      var faceHeight = face.reference.references
                                              .first.boundingBox.height *
                                          height;
                                      var faceWidth = face.reference.references
                                              .first.boundingBox.width *
                                          width;
                                      double widthAdjustment = faceWidth * 0.4;
                                      double heightAdjustment =
                                          faceHeight * 0.8;
                                      children.add(AnimatedPositioned.fromRect(
                                        key: ValueKey(i),
                                        duration: Duration(milliseconds: 150),
                                        curve: Curves.easeInOut,
                                        rect: Rect.fromLTWH(
                                          face.reference.references.first
                                                      .boundingBox.left *
                                                  width -
                                              widthAdjustment / 2,
                                          face.reference.references.first
                                                      .boundingBox.top *
                                                  height -
                                              heightAdjustment * 3 / 4,
                                          faceWidth + widthAdjustment,
                                          faceHeight + heightAdjustment,
                                        ),
                                        child: imageFaceFrame.createImage(
                                            fit: BoxFit.fill),
                                      ));
                                    }
                                    return Stack(
                                      children: children,
                                    );
                                  },
                                );
                              }),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: constraints.maxWidth / 5,
                      height: constraints.maxHeight + 200,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            bottom: 0,
                            child: SizedBox(
                              width: constraints.maxWidth * 3 / 5,
                              height: constraints.maxHeight + 200,
                              child: buildImage(
                                  context,
                                  Container(
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 80,
                left: 0,
                right: 0,
                child: Center(
                  child: DefaultTextStyle(
                    style: TextStyle(
                        fontSize: 80,
                        color: colorStrongYellow,
                        fontFamily: 'MoreSugar'),
                    child: OutlinedText(
                      child: Text('Semua Menghadap ke Kamera!'),
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
              Positioned(
                right: -10,
                bottom: 100,
                child: ListenableBuilder(
                  listenable: faces,
                  builder: (context, child) {
                    return AnimatedValueBuilder(
                        value: faces.value.length >= gameMinPlayers ? 0.0 : 1.0,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        builder: (context, value, child) {
                          return FractionalTranslation(
                            translation: Offset(value, 0),
                            child: MenuButton(
                              label: Text('Lanjutkan'),
                              width: 500,
                              type: MenuButtonType.right,
                              onPressed: () {
                                lanjutkan(context);
                              },
                            ),
                          );
                        });
                  },
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  void lanjutkan(BuildContext context) {
    Game game = context.gameSession.game;
    if (faces.value.length >= gameMinPlayers) {
      List<Player> players = [];
      List<Character> characterPool = List.of(characters);
      Random random = Random();
      for (var face in faces.value) {
        if (characterPool.isEmpty) {
          break;
        }
        var candidate = Candidate(
            session.capture(
                relativeRect: face.reference.references.first.boundingBox,
                expand: const Rect.fromLTWH(50, 50, 50, 50)),
            face,
            face.reference.references.first.gender);
        // players.add(player);
        for (int i = 0; i < 1; i++) {
          var player = game.createPlayer(candidate);
          for (int i = 0; i < characterPool.length; i++) {
            if (candidate.canAcceptGender(characterPool[i].gender) &&
                random.nextDouble() < 0.5) {
              player.character.value = characterPool.removeAt(i);
              break;
            }
          }
          // desperate measure
          player.character.value ??=
              characterPool.removeAt(random.nextInt(characterPool.length));
          players.add(player);
        }
      }
      GameSessionScreen.nextScreen(
        context,
        PlayerListScreen(
          faces: players,
        ),
        duration: Duration(milliseconds: 300),
        loadingScreen: const FlashLoadingScene(),
        reverseDuration: Duration(milliseconds: 1000),
      );
    }
  }
}

class CompetitiveBackgroundPattern extends StatelessWidget {
  const CompetitiveBackgroundPattern({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BackgroundPattern(
      imageAsset: imageCurlyLine,
      color: colorPurple,
      rotation: -45,
      patternSize: Size(450, 450),
      gap: Offset(0, 0),
      patternOffset: Offset(500 / 2, 0),
    );
  }
}

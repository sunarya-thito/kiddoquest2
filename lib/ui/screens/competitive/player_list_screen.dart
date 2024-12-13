import 'dart:math';
import 'dart:typed_data';

import 'package:animation_toolkit/animation_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:kiddoquest2/assets/images.dart';
import 'package:kiddoquest2/assets/theme.dart';
import 'package:kiddoquest2/game.dart';
import 'package:kiddoquest2/ui/components/curly_circle.dart';
import 'package:kiddoquest2/ui/components/keyboard_focus.dart';
import 'package:kiddoquest2/ui/music_scene.dart';
import 'package:kiddoquest2/ui/screens/competitive/players_screen.dart';
import 'package:kiddoquest2/ui/screens/competitive/round_screen.dart';

import '../../../assets/audios.dart';
import '../../components/entry.dart';
import '../../components/menu_button.dart';
import '../../components/outlined_text.dart';
import '../game_session_screen.dart';

class PlayerListScreen extends StatefulWidget {
  final List<Player> faces;
  const PlayerListScreen({super.key, required this.faces});

  @override
  State<PlayerListScreen> createState() => _PlayerListScreenState();
}

class _FaceIndex {
  final int index;
  final String? name;
  final int? countdown;

  _FaceIndex(this.index, this.name, {this.countdown});

  static _FaceIndex? lerped(_FaceIndex? a, _FaceIndex? b, double t) {
    if (t < 1) {
      return a;
    } else {
      return b;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _FaceIndex &&
        other.index == index &&
        other.name == name &&
        other.countdown == countdown;
  }

  @override
  int get hashCode {
    return Object.hash(index, name, countdown);
  }
}

class _PlayerListScreenState extends State<PlayerListScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late TimelineAnimation<_FaceIndex> timeline;
  late List<Player> players;
  late ValueNotifier<_FaceIndex?> faceIndex;
  @override
  void initState() {
    super.initState();
    timeline = TimelineAnimation(keyframes: [
      StillKeyframe(const Duration(milliseconds: 1000), _FaceIndex(-6, null)),
      StillKeyframe(const Duration(seconds: 2), _FaceIndex(0, null)),
      for (int i = 0; i < widget.faces.length; i++) ...[
        if (i != 0)
          StillKeyframe(const Duration(seconds: 1), _FaceIndex(i, null)),
        StillKeyframe(const Duration(seconds: 3),
            _FaceIndex(i, widget.faces[i].character.value!.name)),
      ],
      StillKeyframe(const Duration(seconds: 1), _FaceIndex(-2, null)),
      StillKeyframe(
          const Duration(seconds: 2), _FaceIndex(-3, null, countdown: 10)),
      StillKeyframe(
          const Duration(seconds: 1), _FaceIndex(-3, null, countdown: 9)),
      StillKeyframe(
          const Duration(seconds: 1), _FaceIndex(-3, null, countdown: 8)),
      StillKeyframe(
          const Duration(seconds: 1), _FaceIndex(-3, null, countdown: 7)),
      StillKeyframe(
          const Duration(seconds: 1), _FaceIndex(-3, null, countdown: 6)),
      StillKeyframe(
          const Duration(seconds: 1), _FaceIndex(-3, null, countdown: 5)),
      StillKeyframe(
          const Duration(seconds: 1), _FaceIndex(-3, null, countdown: 4)),
      StillKeyframe(
          const Duration(seconds: 1), _FaceIndex(-3, null, countdown: 3)),
      StillKeyframe(
          const Duration(seconds: 1), _FaceIndex(-3, null, countdown: 2)),
      StillKeyframe(
          const Duration(seconds: 1), _FaceIndex(-3, null, countdown: 1)),
      StillKeyframe(const Duration(seconds: 1), _FaceIndex(-4, null)),
    ], lerp: _FaceIndex.lerped);
    controller =
        AnimationController(vsync: this, duration: timeline.totalDuration);
    faceIndex = ValueNotifier(null);
    controller.addListener(() {
      final value = timeline.transform(controller.value);
      if (faceIndex.value != value) {
        faceIndex.value = value;
        if (value.index >= 0 && value.name != null) {
          Character character = widget.faces[value.index].character.value!;
          playVoiceline(character.nameAnnounceSound);
          return;
        }
        if (value.index == 0 && value.name == null) {
          playVoiceline(tamaPlayer);
          return;
        }
        if (value.index == -4) {
          GameSessionScreen.of(context).nextScreen(Future(() async {
            await Future.delayed(Duration(seconds: 2));
            return RoundScreen(
              round: 1,
              character: GameCharacter.tama,
            );
          }));
        } else if (value.countdown != null) {
          if (value.countdown == 10) {
            playVoiceline(tamaGameStart);
          }
          playCountdown(value.countdown!);
        }
      }
    });

    Future.delayed(Duration(seconds: 1), () {
      playVoiceline(tamaPlayerConfirmation);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardFocus(
      onProceed: () {
        controller.forward();
      },
      onCancel: () {
        GameSessionScreen.of(context).popScreen();
      },
      child: MusicScene(
        music: bgmGameMode1Intro,
        child: Stack(
          children: [
            Positioned.fill(child: CompetitiveBackgroundPattern()),
            Positioned(
              top: 50,
              left: 50,
              child: MenuIconButton(
                  onPressed: () {
                    GameSessionScreen.of(context).pause(true);
                  },
                  icon: Icon(Icons.pause)),
            ),
            ListenableBuilder(
              listenable: faceIndex,
              builder: (context, child) {
                final faceIndex = this.faceIndex.value ?? _FaceIndex(-5, null);
                return Stack(
                  children: [
                    Positioned.fill(
                      child: PlayerListScene(
                        faces: widget.faces,
                        show: controller.value == 0 ||
                            (faceIndex.index < -2 && faceIndex.index >= -3),
                        showName: faceIndex.index < -2 && faceIndex.index >= -3,
                      ),
                    ),
                    for (int i = 0; i < widget.faces.length; i++)
                      Positioned.fill(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Entry.scale(
                              visible:
                                  controller.value != 0 && faceIndex.index >= 0,
                              delay: Duration(milliseconds: 300),
                              duration: const Duration(milliseconds: 400),
                              child: DefaultTextStyle(
                                style: TextStyle(
                                    fontSize: 80,
                                    color: Colors.white,
                                    fontFamily: 'MoreSugar'),
                                child: OutlinedText(
                                  child: Text('Kamu akan bermain sebagai...'),
                                ),
                              ),
                            ),
                            Entry.scale(
                                visible: faceIndex.index == i &&
                                    controller.value != 0,
                                curve: Curves.easeInOut,
                                delay: Duration(milliseconds: 500),
                                duration: const Duration(milliseconds: 400),
                                child: SizedBox(
                                  width: 500,
                                  height: 500,
                                  child: PlayerFrame(
                                      face: widget.faces[i].faceImage),
                                )),
                            Entry.scale(
                              visible: faceIndex.index == i &&
                                  faceIndex.name != null &&
                                  controller.value != 0,
                              delay: Duration(milliseconds: 500),
                              duration: const Duration(milliseconds: 400),
                              child: DefaultTextStyle(
                                style: TextStyle(
                                    fontSize: 150,
                                    color: colorStrongYellow,
                                    fontFamily: 'MoreSugar'),
                                child: OutlinedText(
                                  child: Text(
                                      widget.faces[i].character.value!.name),
                                ),
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
                              color: Colors.white,
                              fontFamily: 'MoreSugar'),
                          child: Entry.scale(
                            visible: controller.value == 0 ||
                                (faceIndex.index < -2 && faceIndex.index >= -3),
                            child: OutlinedText(
                              child: Text('Daftar Pemain'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 80,
                      right: -10,
                      child: Entry.scale(
                        visible: controller.value == 0,
                        inProperties: [
                          ScaleProperty(0.0, 1.0,
                              alignment: Alignment.centerRight),
                        ],
                        outProperties: [
                          ScaleProperty(1.0, 0.0,
                              alignment: Alignment.centerRight),
                        ],
                        child: MenuButton(
                          label: Text('Lanjutkan'),
                          width: 400,
                          type: MenuButtonType.right,
                          onPressed: () {
                            controller.forward();
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 80,
                      left: -10,
                      child: Entry.scale(
                        visible: controller.value == 0,
                        inProperties: [
                          ScaleProperty(0.0, 1.0,
                              alignment: Alignment.centerLeft),
                        ],
                        outProperties: [
                          ScaleProperty(1.0, 0.0,
                              alignment: Alignment.centerLeft),
                        ],
                        child: MenuButton(
                          label: Text('Ulangi'),
                          width: 400,
                          type: MenuButtonType.left,
                          onPressed: () {
                            GameSessionScreen.of(context).popScreen();
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      right: 50,
                      bottom: 50,
                      child: Entry.scale(
                        visible: faceIndex.countdown != null,
                        delay: Duration(milliseconds: 500),
                        duration: const Duration(milliseconds: 400),
                        child: SizedBox(
                          width: 300,
                          height: 300,
                          child: CurlyCircle(
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  top: -35,
                                  left: 40,
                                  right: 40,
                                  child: Entry.scale(
                                    visible: faceIndex.countdown != null,
                                    delay: Duration(milliseconds: 700),
                                    child: imageRoundStartsIn.createImage(
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  child: Transform.translate(
                                    offset: Offset(0, 10),
                                    child: DefaultTextStyle(
                                        style: TextStyle(
                                            fontSize: 150,
                                            color: colorSkyBlue,
                                            fontFamily: 'MoreSugar'),
                                        child: Entry.scale(
                                          key: ValueKey(
                                              faceIndex.countdown ?? -1),
                                          visible: faceIndex.countdown != null,
                                          duration:
                                              const Duration(milliseconds: 400),
                                          child: Center(
                                            child: OutlinedText(
                                              child: Text(faceIndex.countdown
                                                  .toString()),
                                            ),
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerListScene extends StatelessWidget {
  final List<Player> faces;
  final bool show;
  final bool showName;
  final bool showScore;

  const PlayerListScene(
      {super.key,
      required this.faces,
      this.show = true,
      this.showName = false,
      this.showScore = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(150),
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (int i = 0; i < faces.length; i++)
              Transform.rotate(
                angle: (-20 + Random(i * 4213).nextDouble() * 40) * pi / 180,
                child: Entry.scale(
                  visible: show,
                  delay: Duration(milliseconds: (i + 1) * 250) +
                      const Duration(milliseconds: 500),
                  reverseDelay:
                      Duration(milliseconds: (faces.length - i) * 250),
                  duration: const Duration(milliseconds: 400),
                  child: SizedBox(
                    width: 380,
                    height: 380,
                    child: PlayerFrame(
                      face: faces[i].faceImage,
                      name: showName ? faces[i].character.value!.name : null,
                      score: showScore
                          ? (faces[i] as CompetitivePlayer)
                              .currentRoundScore
                              .value
                          : null,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class PlayerFrame extends StatelessWidget {
  final Uint8List face;
  final String? name;
  final int? score;

  const PlayerFrame({super.key, required this.face, this.name, this.score});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fill,
      child: SizedBox(
        width: 380,
        height: 380,
        child: Stack(
          children: [
            Positioned(
              top: 30,
              left: 55,
              bottom: 70,
              right: 50,
              child: Image.memory(
                face,
                fit: BoxFit.fill,
              ),
            ),
            imagePhotoFrame.createImage(fit: BoxFit.fill),
            if (name != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 35,
                child: Center(
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontFamily: 'MoreSugar',
                      fontSize: 40,
                      color: Colors.black,
                    ),
                    child: Text(name!),
                  ),
                ),
              ),
            if (score != null)
              Positioned(
                right: 0,
                bottom: 50,
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontFamily: 'MoreSugar',
                    fontSize: 100,
                    color: colorStrongYellow,
                  ),
                  child: OutlinedText(
                    child: Text('+$score'),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

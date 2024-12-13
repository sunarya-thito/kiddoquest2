import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kiddoquest2/assets/audios.dart';
import 'package:kiddoquest2/assets/images.dart';
import 'package:kiddoquest2/assets/theme.dart';
import 'package:kiddoquest2/ui/components/background_pattern.dart';
import 'package:kiddoquest2/ui/components/curly_circle.dart';
import 'package:kiddoquest2/ui/components/entry.dart';
import 'package:kiddoquest2/ui/components/logo.dart';
import 'package:kiddoquest2/ui/components/menu_button.dart';
import 'package:kiddoquest2/ui/music_scene.dart';
import 'package:web/web.dart' as web;

import '../components/message_box.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

bool _hasRequestedCamera = true;

Future<web.MediaStream> _createCameraSession(
    web.MediaDeviceInfo selectedCamera) async {
  web.MediaStream mediaStream = await web.window.navigator.mediaDevices
      .getUserMedia(web.MediaStreamConstraints(
        video: web.MediaTrackConstraints(
          deviceId: selectedCamera.deviceId.toJS,
        ),
      ))
      .toDart;
  return mediaStream;
}

bool requestedCamera = false;

class _MainMenuScreenState extends State<MainMenuScreen> {
  bool _hovering = false;
  @override
  void initState() {
    super.initState();
    if (_hasRequestedCamera) {
      Future.delayed(Duration(seconds: 1), () async {
        if (!mounted || requestedCamera) return;
        GlobalKey key = GlobalKey();
        bool hasCameraAccess = false;
        Future.delayed(Duration(milliseconds: 1000), () {
          if (hasCameraAccess) return;
          playVoiceline(amelPermission);
        });
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return Center(
              child: DefaultTextStyle(
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'MoreSugar',
                  fontSize: 24,
                ),
                child: MessageBox(
                  'Kami membutuhkan izin untuk mengakses kamera anda!',
                  key: key,
                ),
              ),
            );
          },
        );
        final devices =
            (await web.window.navigator.mediaDevices.enumerateDevices().toDart)
                .toDart;
        final session = await _createCameraSession(devices.first);
        hasCameraAccess = true;
        requestedCamera = true;
        // close session
        session.getTracks().toDart.forEach((track) {
          track.stop();
        });
        final currentContext = key.currentContext;
        if (currentContext != null && currentContext.mounted) {
          Navigator.of(currentContext).pop();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MusicScene(
      music: bgmMainMenu,
      child: Stack(
        children: [
          Positioned.fill(
            child: BackgroundPattern(
              imageAsset: imageSpiralLine,
              gap: Offset(100, 100),
              patternSize: Size(250, 250),
              patternOffset: Offset(100, 100),
              animateRotation: true,
              color: colorTeal,
            ),
          ),
          Positioned(
            bottom: -300,
            left: -200,
            width: 1000,
            height: 1000,
            child: Entry.scale(
              reverseDelay: Duration(milliseconds: 600),
              child: CurlyCircle(),
            ),
          ),
          Positioned(
            bottom: 80,
            left: -10,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Entry.scale(
                    delay: Duration(milliseconds: 200),
                    inProperties: [
                      ScaleProperty(0, 1, alignment: Alignment.centerLeft),
                    ],
                    outProperties: [
                      ScaleProperty(1, 0, alignment: Alignment.centerLeft),
                    ],
                    reverseDelay: Duration(milliseconds: 400),
                    child: MenuButton(
                      label: Text('Mode Kompetitif'),
                      width: 800,
                      icon: imageMenuTama.createImage(),
                      onHover: () async {
                        if (!_hovering) {
                          _hovering = true;
                          await playVoiceline(tamaHover);
                          _hovering = false;
                        }
                      },
                      onPressed: () {
                        context.go('/competitive');
                      },
                      type: MenuButtonType.left,
                    ),
                  ),
                  SizedBox(height: 35),
                  Entry.scale(
                    inProperties: [
                      ScaleProperty(0, 1, alignment: Alignment.centerLeft),
                    ],
                    outProperties: [
                      ScaleProperty(1, 0, alignment: Alignment.centerLeft),
                    ],
                    delay: Duration(milliseconds: 400),
                    reverseDelay: Duration(milliseconds: 200),
                    child: MenuButton(
                      label: Text('Mode Kooperatif'),
                      width: 900,
                      icon: imageMenuAmel.createImage(),
                      onHover: () async {
                        if (!_hovering) {
                          _hovering = true;
                          await playVoiceline(amelHover);
                          _hovering = false;
                        }
                      },
                      onPressed: () {
                        context.go('/cooperative');
                      },
                      type: MenuButtonType.left,
                    ),
                  ),
                  SizedBox(height: 35),
                  Entry.scale(
                    inProperties: [
                      ScaleProperty(0, 1, alignment: Alignment.centerLeft),
                    ],
                    outProperties: [
                      ScaleProperty(1, 0, alignment: Alignment.centerLeft),
                    ],
                    delay: Duration(milliseconds: 600),
                    reverseDelay: Duration.zero,
                    child: MenuButton(
                      label: Text('Mode Kreatif'),
                      width: 1000,
                      icon: imageMenuRobot.createImage(),
                      onHover: () async {
                        if (!_hovering) {
                          _hovering = true;
                          await playTTS(
                              'Buat quizmu sendiri dan mainkan bersama teman!');
                          _hovering = false;
                        }
                      },
                      onPressed: () {
                        context.go('/creative');
                      },
                      type: MenuButtonType.left,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -70,
            right: 40,
            width: 600,
            height: 600,
            child: KiddoQuestLogo(
              yellowBackground: true,
            ),
          )
        ],
      ),
    );
  }
}

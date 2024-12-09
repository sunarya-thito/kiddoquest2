import 'package:flutter/widgets.dart';
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

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

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

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:kiddoquest2/assets/audios.dart';
import 'package:kiddoquest2/assets/images.dart';
import 'package:kiddoquest2/ui/components/background_pattern.dart';
import 'package:kiddoquest2/ui/components/logo.dart';
import 'package:kiddoquest2/ui/components/menu_button.dart';
import 'package:kiddoquest2/ui/components/outlined_text.dart';
import 'package:kiddoquest2/ui/music_scene.dart';

import '../../assets/theme.dart';

class UnderConstructionScreen extends StatelessWidget {
  const UnderConstructionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MusicScene(
      music: bgmGameMode2,
      child: Stack(
        children: [
          Positioned.fill(
            child: BackgroundPattern(imageAsset: imageHeart, color: colorPink),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 600,
                  height: 600,
                  child: KiddoQuestLogo(),
                ),
                DefaultTextStyle(
                  style: TextStyle(
                    color: colorStrongYellow,
                    fontSize: 48,
                    fontFamily: 'MoreSugar',
                  ),
                  child: OutlinedText(
                    child: Text(
                      'Permainan ini sedang dalam pengembangan!\nStay tuned!',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                MenuButton(
                    label: Text('Kembali'),
                    width: 400,
                    type: MenuButtonType.center,
                    onPressed: () {
                      context.go('/');
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../assets/images.dart';
import '../../assets/theme.dart';
import '../components/background_pattern.dart';
import '../components/menu_button.dart';
import 'game_session_screen.dart';

class PauseScreen extends StatelessWidget {
  const PauseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
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
          top: 50,
          left: 50,
          child: MenuIconButton(
              onPressed: () {
                GameSessionScreen.of(context).pause(false);
              },
              icon: Icon(Icons.close)),
        ),
      ],
    );
  }
}

class PauseClipper extends CustomClipper<Rect> {
  final Offset center;
  final double progress;

  PauseClipper({
    required this.center,
    required this.progress,
  });

  @override
  Rect getClip(Size size) {
    final maxSide = size.shortestSide + size.longestSide;
    return Rect.fromCircle(center: center, radius: maxSide * progress);
  }

  @override
  bool shouldReclip(covariant PauseClipper oldClipper) {
    return oldClipper.center != center || oldClipper.progress != progress;
  }
}

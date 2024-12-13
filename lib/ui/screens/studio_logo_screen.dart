import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kiddoquest2/assets/audios.dart';
import 'package:kiddoquest2/ui/components/logo.dart';
import 'package:kiddoquest2/ui/game_screen.dart';

import '../../assets/images.dart';
import '../game_app.dart';
import '../loading_scene.dart';

class StudioLogoScreen extends StatefulWidget {
  final FutureOr<Widget> child;
  final bool showGame;
  const StudioLogoScreen(
      {super.key, required this.child, this.showGame = true});

  @override
  State<StudioLogoScreen> createState() => _StudioLogoScreenState();
}

Future<void> loadBasicResources() async {
  await loadAll([
    imageLogoUpper,
    imageLogoLower,
    imageLogoVersion,
    imageLogoSplashWhite,
    imageLogoSplash,
    imageStar,
    imageSpiralLine,
    ...LoadingScene.loadingAnimations,
    bgmPauseMenu,
    bgmSettings,
    countdown1,
    countdown2,
    countdown3,
    countdown4,
    countdown5,
    tamaHover,
    amelHover,
    amelPermission,
  ]);
}

class _StudioLogoScreenState extends State<StudioLogoScreen> {
  late bool showGame;
  late Widget child;

  @override
  void initState() {
    super.initState();
    showGame = widget.showGame;
    _updateChild();
  }

  @override
  void didUpdateWidget(covariant StudioLogoScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.showGame != widget.showGame) {
      showGame = widget.showGame;
    }
    if (oldWidget.child != widget.child) {
      _updateChild();
    }
  }

  void _updateChild() {
    child = DefaultTextStyle(
      style: TextStyle(
        color: Colors.black,
        fontFamily: 'MoreSugar',
      ),
      child: FutureBuilder(
          future: loadBasicResources().catchError((err, trace) {
            print(err);
            print(trace);
          }),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    showGame = true;
                  });
                },
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 600,
                          height: 600,
                          child: KiddoQuestLogo(
                            yellowBackground: true,
                          ),
                        ),
                        const SizedBox(height: 80),
                        Text('Tekan dimana saja untuk melanjutkan',
                            style: TextStyle(fontSize: 40)),
                      ],
                    ),
                  ),
                ),
              );
            }
            return Container(
              color: Colors.white,
              child: Center(
                child: SizedBox(
                  width: 600,
                  height: 600,
                  child: KiddoQuestLogo(),
                ),
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (showGame) {
      return GameScreen(child: widget.child);
    }
    return GameScreen(
      child: child,
    );
  }
}

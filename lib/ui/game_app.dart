import 'package:data_widget/data_widget.dart';
import 'package:face_api_web/face_api_web.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kiddoquest2/assets/asset_manager.dart';
import 'package:kiddoquest2/assets/audios.dart';
import 'package:kiddoquest2/assets/images.dart';
import 'package:kiddoquest2/ui/music_scene.dart';
import 'package:kiddoquest2/ui/screens/competitive/players_screen.dart';
import 'package:kiddoquest2/ui/screens/game_session_screen.dart';
import 'package:kiddoquest2/ui/screens/main_menu_screen.dart';
import 'package:kiddoquest2/ui/screens/studio_logo_screen.dart';

GoRouter router = GoRouter(routes: [
  GoRoute(
    path: '/',
    pageBuilder: (context, state) {
      return NoTransitionPage(
        child: StudioLogoScreen(
          showGame: false,
          child: Future(() async {
            await loadMainMenuResources();
            return const MainMenuScreen();
          }),
        ),
      );
    },
  ),
  GoRoute(
    path: '/competitive',
    pageBuilder: (context, state) {
      return NoTransitionPage(
        child: StudioLogoScreen(
          showGame: false,
          child: Future(() async {
            await loadCompetitiveResources();
            final cameras = await getAvailableCameras();
            final game = await createGame('1');
            return Data<CameraInfo>.inherit(
              data: cameras.first,
              child: GameSessionScreen(
                  game: game,
                  child: PlayersScreen(
                    selectedCamera: cameras.first,
                  )),
            );
          }),
        ),
      );
    },
  ),
  GoRoute(
    path: '/cooperative',
    pageBuilder: (context, state) {
      return NoTransitionPage(
        child: StudioLogoScreen(
          showGame: false,
          child: Future(() async {
            await loadMainMenuResources();
            return const MainMenuScreen();
          }),
        ),
      );
    },
  ),
]);

Future<void> loadMainMenuResources() async {
  await Future.delayed(Duration(seconds: 5));
  await loadBasicResources();
  await loadAll([
    imageSpiralLine,
    imageMenuRobot,
    imageMenuTama,
    imageMenuAmel,
    imageLogoSplash,
    bgmMainMenu,
  ]);
}

Future<void> loadCompetitiveResources() async {
  await Future.delayed(Duration(seconds: 5));
  await loadBasicResources();
  await loadAll([
    imageCurlyLine,
    imageFilmFrame,
    imagePhotoFrame,
    imageRoundStartsIn,
    imageFaceFrame,
    imageRound,
    imagePointer,
    bgmGameMode1Intro,
    bgmGameMode1,
  ]);
}

Future<void> loadAll(Iterable<GameAsset> assets) {
  return Future.wait(assets.map((asset) {
    return asset.loadBytes();
  }));
}

class GameApp extends StatelessWidget {
  const GameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MusicManager(
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

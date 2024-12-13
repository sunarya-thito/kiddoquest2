import 'package:data_widget/data_widget.dart';
import 'package:face_api_web/face_api_web.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kiddoquest2/assets/asset_manager.dart';
import 'package:kiddoquest2/assets/audios.dart';
import 'package:kiddoquest2/assets/images.dart';
import 'package:kiddoquest2/ui/music_scene.dart';
import 'package:kiddoquest2/ui/screens/competitive/players_screen.dart';
import 'package:kiddoquest2/ui/screens/cutscene_screen.dart';
import 'package:kiddoquest2/ui/screens/game_session_screen.dart';
import 'package:kiddoquest2/ui/screens/main_menu_screen.dart';
import 'package:kiddoquest2/ui/screens/studio_logo_screen.dart';
import 'package:kiddoquest2/ui/screens/under_construction_screen.dart';
import 'package:video_player/video_player.dart';

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
            final controller =
                VideoPlayerController.asset('assets/videos/tama.mp4');
            await controller.initialize();
            await loadCompetitiveResources();
            final cameras = await getAvailableCameras();
            final game = await createGame('1');
            return GameSessionScreen(
              game: game,
              child: CutsceneScreen(
                  video: controller,
                  onContinue: () {
                    return Data<CameraInfo>.inherit(
                      data: cameras.first,
                      child: GameSessionScreen(
                          game: game,
                          child: PlayersScreen(
                            selectedCamera: cameras.first,
                          )),
                    );
                  }),
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
            await loadCooperativeResources();
            return const UnderConstructionScreen();
          }),
        ),
      );
    },
  ),
  GoRoute(
    path: '/creative',
    pageBuilder: (context, state) {
      return NoTransitionPage(
        child: StudioLogoScreen(
          showGame: false,
          child: Future(() async {
            await loadCooperativeResources();
            return const UnderConstructionScreen();
          }),
        ),
      );
    },
  )
]);

Future<void> loadMainMenuResources() async {
  await Future.delayed(const Duration(seconds: 3));
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

Future<void> loadCooperativeResources() async {
  await Future.delayed(const Duration(seconds: 3));
  await loadBasicResources();
  await loadAll([
    imageHeart,
    bgmGameMode2,
    bgmVictory,
  ]);
}

Future<void> loadCompetitiveResources() async {
  await Future.delayed(const Duration(seconds: 3));
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
    bgmVictory,
    imageShine1,
    imageShine2,

    // voice lines
    audioAnnounceGajahTerbang,
    audioAnnounceKaptenLautan,
    audioAnnounceKucingNinja,
    audioAnnounceNagaBerkilau,
    audioAnnouncePahlawanSuper,
    audioAnnouncePandaAjaib,
    audioAnnouncePangeranBulan,
    audioAnnouncePeriEmbun,
    audioAnnouncePutriAwan,
    audioAnnouncePutriPelangi,
    audioAnnounceRajaBuah,
    audioAnnounceRajaMadu,
    audioAnnounceRaksasaHutan,
    audioAnnounceRatuEs,
    audioAnnounceRatuKebaikan,
    audioAnnounceSingaCeria,
    audioNameGajahTerbang,
    audioNameKaptenLautan,
    audioNameKucingNinja,
    audioNameNagaBerkilau,
    audioNamePahlawanSuper,
    audioNamePandaAjaib,
    audioNamePangeranBulan,
    audioNamePeriEmbun,
    audioNamePutriAwan,
    audioNamePutriPelangi,
    audioNameRajaBuah,
    audioNameRajaMadu,
    audioNameRaksasaHutan,
    audioNameRatuEs,
    audioNameRatuKebaikan,
    audioNameSingaCeria,
    tamaBabakKe,
    tamaBelas,
    tamaDelapan,
    tamaDua,
    tamaEmpat,
    tamaEnam,
    tamaGameOver,
    tamaGameOverSingleWinnerPrefix,
    tamaGameOverSingleWinnerSuffix,
    tamaGameStart,
    tamaHover,
    tamaLima,
    tamaPlayer,
    tamaPlayerConfirmation,
    tamaPlayerIntroduction,
    tamaPuluh,
    tamaRound1,
    tamaRoundEndMultiWinner,
    tamaRoundEndNoWinner,
    tamaRoundEndReveal,
    tamaRoundEndSingleWinnerPrefix,
    tamaRoundEndSingleWinnerSuffix,
    tamaSatu,
    tamaSebelas,
    tamaSembilan,
    tamaSepuluh,
    tamaTiga,
    tamaTujuh,
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

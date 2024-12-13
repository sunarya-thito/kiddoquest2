import 'package:face_api_web/face_api_web.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:kiddoquest2/ui/game_app.dart';
import 'package:kiddoquest2/ui/music_scene.dart';
import 'package:kiddoquest2/ui/screens/studio_logo_screen.dart';
import 'package:kiddoquest2/util.dart';

main() async {
  while (!prepareTTS()) {
    await Future.delayed(Duration(milliseconds: 100));
  }
  GoRouter.optionURLReflectsImperativeAPIs = true;
  WidgetsFlutterBinding.ensureInitialized();
  await faceapi.loadModel(FaceDetectionModel.tinyFace);
  await faceapi.loadFeature(FaceDetectionFeature.faceLandmark);
  await faceapi.loadFeature(FaceDetectionFeature.faceDescriptor);
  await faceapi.loadFeature(FaceDetectionFeature.faceAgeAndGender);
  await loadBasicResources();
  runApp(
    FixedResolution(
      width: 1920,
      height: 1080,
      child: WebAudioToggler(child: const GameApp()),
    ),
  );
}

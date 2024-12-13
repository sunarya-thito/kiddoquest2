import 'dart:math';

import 'package:face_api_web/face_api_web.dart';
import 'package:flutter/foundation.dart';
import 'package:kiddoquest2/assets/asset_manager.dart';
import 'package:kiddoquest2/assets/audios.dart';
import 'package:kiddoquest2/game_config.dart';
import 'package:kiddoquest2/pdf_generator.dart';
import 'package:kiddoquest2/ui/music_scene.dart';

final List<Character> characters = [
  Character('Putri Pelangi', audioNamePutriPelangi, audioAnnouncePutriPelangi,
      Gender.female),
  Character(
      'Kucing Ninja', audioNameKucingNinja, audioAnnounceKucingNinja, null),
  Character('Pahlawan Super', audioNamePahlawanSuper,
      audioAnnouncePahlawanSuper, null),
  Character('Ratu Kebaikan', audioNameRatuKebaikan, audioAnnounceRatuKebaikan,
      Gender.female),
  Character(
      'Kapten Lautan', audioNameKaptenLautan, audioAnnounceKaptenLautan, null),
  Character(
      'Peri Embun', audioNamePeriEmbun, audioAnnouncePeriEmbun, Gender.female),
  Character(
      'Putri Awan', audioNamePutriAwan, audioAnnouncePutriAwan, Gender.female),
  Character(
      'Singa Ceria', audioNameSingaCeria, audioAnnounceSingaCeria, Gender.male),
  Character('Ratu Es', audioNameRatuEs, audioAnnounceRatuEs, Gender.female),
  Character('Panda Ajaib', audioNamePandaAjaib, audioAnnouncePandaAjaib, null),
  Character(
      'Gajah Terbang', audioNameGajahTerbang, audioAnnounceGajahTerbang, null),
  Character('Naga Berkilau', audioNameNagaBerkilau, audioAnnounceNagaBerkilau,
      Gender.male),
  Character('Raksasa Hutan', audioNameRaksasaHutan, audioAnnounceRaksasaHutan,
      Gender.male),
  Character('Raja Buah', audioNameRajaBuah, audioAnnounceRajaBuah, Gender.male),
  Character('Raja Madu', audioNameRajaMadu, audioAnnounceRajaMadu, Gender.male),
  Character('Pangeran Bulan', audioNamePangeranBulan,
      audioAnnouncePangeranBulan, Gender.male),
];

const gameMinPlayers = 1;

class Candidate {
  final Uint8List image;
  final FaceScore score;
  final Gender? gender;

  Candidate(this.image, this.score, this.gender);

  bool canAcceptGender(Gender? gender) {
    return this.gender == null || gender == null || this.gender == gender;
  }
}

abstract class Game {
  final String name;
  final Duration defaultRoundDuration;
  final ValueNotifier<List<Player>> players = ValueNotifier([]);
  List<GameRound> rounds = [];

  Game(this.name, this.defaultRoundDuration);

  Player createPlayer(Candidate candidate) {
    final player = Player(
      face: candidate.score,
      faceImage: candidate.image,
    );
    players.value = [...players.value, player];
    return player;
  }

  void downloadReport() {
    downloadPDF(this);
  }
}

class CompetitiveGame extends Game {
  CompetitiveGame(super.name, super.defaultRoundDuration);

  @override
  final ValueNotifier<List<CompetitivePlayer>> players = ValueNotifier([]);

  @override
  Player createPlayer(Candidate candidate) {
    final player = CompetitivePlayer(
      face: candidate.score,
      faceImage: candidate.image,
    );
    print('Creating player with face score: ${player.face}');
    players.value = [...players.value, player];
    return player;
  }
}

class CompetitivePlayer extends Player {
  final ValueNotifier<int> score = ValueNotifier(0);
  final ValueNotifier<Duration> currentRoundDurationCorrect =
      ValueNotifier(Duration.zero);
  final ValueNotifier<bool> currentRoundCorrect = ValueNotifier(false);
  final ValueNotifier<int> currentRoundScore = ValueNotifier(0);

  CompetitivePlayer({required super.faceImage, required super.face});
}

class CooperativeGame extends Game {
  final ValueNotifier<int> score = ValueNotifier(0);

  CooperativeGame(super.name, super.defaultRoundDuration);
}

class GameRound {
  final String question;
  final GameRoundAnswer wrongAnswer;
  final GameRoundAnswer correctAnswer;
  final Duration? duration;
  final ValueNotifier<Duration> countdown = ValueNotifier(Duration.zero);

  GameRound(this.question, this.wrongAnswer, this.correctAnswer, this.duration);

  Future<void> playRoundTTS() async {
    Random random = Random();
    if (random.nextBool()) {
      await playTTS(
          '$question... ${correctAnswer.content.textContent} atau ${wrongAnswer.content.textContent}');
    } else {
      await playTTS(
          '$question... ${wrongAnswer.content.textContent} atau ${correctAnswer.content.textContent}');
    }
  }

  Future<void> playCorrectTTS() async {
    await playTTS(correctAnswer.content.textContent!);
  }
}

class GameRoundAnswer {
  AnswerContent content;

  GameRoundAnswer(this.content);
}

class SelectedPlayer {
  final Player player;
  final DateTime selectedAt;

  SelectedPlayer(this.player, this.selectedAt);
}

class AnswerContent {
  final String? textContent;
  final String? imageContent;

  AnswerContent(this.textContent, this.imageContent);
}

class PlayerReport {
  final GameRound round;
  final int score;
  final GameRoundAnswer chosenAnswer;

  PlayerReport(this.round, this.score, this.chosenAnswer);
}

class Player {
  final ValueNotifier<Character?> character = ValueNotifier(null);
  final Uint8List faceImage;
  final FaceScore face;
  final List<PlayerReport> reports = [];

  Player({required this.faceImage, required this.face});
}

class Character {
  final String name;
  final AudioAsset nameSound;
  final AudioAsset nameAnnounceSound;
  final Gender? gender;
  Character(this.name, this.nameSound, this.nameAnnounceSound, this.gender);
}

Game createGameFromConfig(GameConfig config) {
  Game game;
  switch (config.type) {
    case GameType.competitive:
      game = CompetitiveGame(config.name, config.defaultRoundDuration);
      break;
    case GameType.cooperative:
      game = CooperativeGame(config.name, config.defaultRoundDuration);
      break;
  }
  for (final round in config.rounds) {
    game.rounds.add(GameRound(
      round.question,
      GameRoundAnswer(
          AnswerContent(round.wrongAnswer.text, round.wrongAnswer.image)),
      GameRoundAnswer(
          AnswerContent(round.correctAnswer.text, round.correctAnswer.image)),
      round.duration,
    ));
  }
  return game;
}

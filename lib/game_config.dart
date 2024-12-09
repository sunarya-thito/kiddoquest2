enum GameType {
  competitive,
  cooperative;

  static GameType fromString(String type) {
    switch (type) {
      case 'competitive':
        return GameType.competitive;
      case 'cooperative':
        return GameType.cooperative;
      default:
        throw Exception('Invalid GameType: $type');
    }
  }
}

class GameConfig {
  final GameType type;
  final String name;
  final List<GameRoundConfig> rounds;
  final Duration defaultRoundDuration;

  const GameConfig(
      this.type, this.name, this.rounds, this.defaultRoundDuration);
  GameConfig.fromJSON(Map<String, dynamic> json)
      : type = GameType.fromString(json['type']),
        name = json['name'],
        rounds = (json['rounds'] as List)
            .map((round) => GameRoundConfig.fromJSON(round))
            .toList(),
        defaultRoundDuration = Duration(seconds: json['defaultRoundDuration']);
}

class GameRoundConfig {
  final String question;
  final GameRoundAnswerConfig correctAnswer;
  final GameRoundAnswerConfig wrongAnswer;
  final Duration? duration;

  const GameRoundConfig(
      this.question, this.correctAnswer, this.wrongAnswer, this.duration);
  GameRoundConfig.fromJSON(Map<String, dynamic> json)
      : question = json['question'],
        correctAnswer = GameRoundAnswerConfig.fromJSON(json['correctAnswer']),
        wrongAnswer = GameRoundAnswerConfig.fromJSON(json['wrongAnswer']),
        duration = json['duration'] != null
            ? Duration(seconds: json['duration'])
            : null;
}

class GameRoundAnswerConfig {
  final String? text;
  final String? image;

  const GameRoundAnswerConfig(this.text, this.image);

  GameRoundAnswerConfig.fromJSON(Map<String, dynamic> json)
      : text = json['text'],
        image = json['image'];
}

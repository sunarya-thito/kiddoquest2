// execute js htmlToPdf(text)

import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';

import 'game.dart';

@JS()
external void htmlToPdf(String text);

void downloadPDF(Game game) {
  String buffer = '<h1>Hasil Pembelajaran</h1>';
  buffer += '<p>Game: ${game.name}</p>';
  for (Player player in game.players.value) {
    buffer += '<h2>${player.character.value!.name}</h2>';
    String base64Image = imgToBase64(player.faceImage);
    buffer += '<img src="$base64Image" width="100" height="100" />';
    int totalScore = 0;
    buffer +=
        '<table><tr><th><td>Pertanyaan</td><td>Jawaban</td><td>Skor</td></th>';
    for (PlayerReport report in player.reports) {
      String content = '';
      if (report.chosenAnswer.content.imageContent != null) {
        content =
            '<img src="${report.chosenAnswer.content.imageContent!}" width="100" height="100" /><br>';
      }
      if (report.chosenAnswer.content.textContent != null) {
        content = report.chosenAnswer.content.textContent!;
      }
      buffer +=
          '<tr><td>${report.round.question}</td><td>$content</td><td>${report.score}</td></tr>';
      totalScore += report.score;
    }
    buffer += '</table>';
    buffer += '<p>Total Skor: $totalScore</p>';
  }
  htmlToPdf(buffer);
}

String imgToBase64(Uint8List img) {
  return 'data:image/png;base64,${base64Encode(img)}';
}

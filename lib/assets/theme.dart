import 'dart:ui';

Color fromHex(String hex) {
  final buffer = StringBuffer();
  if (hex.length == 6 || hex.length == 7) {
    buffer.write('ff');
  }
  buffer.write(hex.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

final Color colorPurple = fromHex('#a352cd');
final Color colorYellow = fromHex('#ffe36e');
final Color colorYellowDark = fromHex('#ffc107');
final Color colorBronze = fromHex('#ff8c40');
final Color colorSilver = fromHex('#d4d8d9');
final Color colorPink = fromHex('#f6a9bd');
final Color colorTeal = fromHex('#86dbd5');
final Color colorOrange = fromHex('#ff8c40');
final Color colorStrongYellow = fromHex('#ffd400');
final Color colorSkyBlue = fromHex('#95c9e1');

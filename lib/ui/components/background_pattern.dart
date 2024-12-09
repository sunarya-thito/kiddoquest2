import 'dart:math';

import 'package:animation_toolkit/animation_toolkit.dart';
import 'package:flutter/widgets.dart';
import 'package:kiddoquest2/assets/asset_manager.dart';

class BackgroundPattern extends StatelessWidget {
  final ImageAsset imageAsset;
  final Color color;
  final Size patternSize;
  final Offset patternOffset;
  final Offset animationOffset;
  final Offset gap;
  final double rotation;
  final bool animateRotation;

  const BackgroundPattern({
    super.key,
    required this.imageAsset,
    required this.color,
    this.patternSize = const Size(150, 150),
    this.patternOffset = const Offset(250 / 2, 0),
    this.animationOffset = const Offset(1, 1),
    this.gap = const Offset(150, 150),
    this.rotation = 45,
    this.animateRotation = false,
  });

  @override
  Widget build(BuildContext context) {
    return RepeatedAnimationBuilder(
      start: 0.0,
      end: 1.0,
      duration: const Duration(seconds: 5),
      builder: (context, value, child) {
        return RepeatedAnimationBuilder(
            start: rotation,
            end: rotation + 360,
            play: animateRotation,
            duration: const Duration(seconds: 25),
            builder: (context, rotationValue, child) {
              return CustomPaint(
                painter: _BackgroundPainter(
                  image: imageAsset,
                  color: color,
                  value: value,
                  patternSize: patternSize,
                  patternOffset: patternOffset,
                  animationOffset: animationOffset,
                  gap: gap,
                  rotation: rotationValue,
                ),
              );
            });
      },
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  final ImageAsset image;
  final Color color;
  final double value;
  final Size patternSize;
  final Offset patternOffset;
  final Offset animationOffset;
  final Offset gap;
  final double rotation;

  _BackgroundPainter({
    required this.image,
    required this.color,
    required this.value,
    required this.patternSize,
    required this.patternOffset,
    required this.animationOffset,
    required this.gap,
    this.rotation = 45,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);
    double totalWidth = patternSize.width + gap.dx;
    double totalHeight = patternSize.height + gap.dy;
    final img = image.image;
    final imageRect =
        Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble());
    int totalRows = (size.height / totalHeight).ceil();
    int totalColumns = (size.width / totalWidth).ceil();
    double totalPatternOffsetX = patternOffset.dx * totalRows;
    double totalPatternOffsetY = patternOffset.dy * totalColumns;
    totalRows += 5;
    totalColumns += 5;
    for (int row = 0; row < totalRows; row++) {
      var offsetY = row * totalHeight;
      for (int column = 0; column < totalColumns; column++) {
        var offsetX = column * totalWidth;
        double patternOffsetX = patternOffset.dx * row;
        double patternOffsetY = patternOffset.dy * column;
        double animatedOffsetX = offsetX +
            value * animationOffset.dx * (totalWidth + patternOffset.dx) +
            patternOffsetX -
            totalPatternOffsetX -
            totalWidth;
        double animatedOffsetY = offsetY +
            value * animationOffset.dy * (totalHeight + patternOffset.dy) +
            patternOffsetY -
            totalPatternOffsetY -
            totalHeight;
        canvas.save();
        Matrix4 matrix = Matrix4.identity()
          ..translate(animatedOffsetX, animatedOffsetY)
          ..translate(patternSize.width / 2, patternSize.height / 2)
          ..rotateZ(rotation * pi / 180)
          ..translate(-patternSize.width / 2, -patternSize.height / 2);
        canvas.transform(matrix.storage);
        canvas.drawImageRect(img, imageRect,
            Rect.fromLTWH(0, 0, patternSize.width, patternSize.height), paint);
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

import 'package:flutter/material.dart';

class OutlinedText extends StatelessWidget {
  final double strokeWidth;
  final Color strokeColor;
  final Widget child;

  const OutlinedText({
    super.key,
    this.strokeWidth = 10.0,
    this.strokeColor = Colors.black,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DefaultTextStyle.merge(
          style: TextStyle(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor,
          ),
          child: child,
        ),
        child,
      ],
    );
  }
}

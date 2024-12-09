import 'package:animation_toolkit/animation_toolkit.dart';
import 'package:flutter/material.dart';

class CurlyCircle extends StatelessWidget {
  final Widget? child;
  final Color color;
  final bool shadow;
  final bool animate;
  final double points;
  final double rounding;
  final double radius;

  const CurlyCircle({
    Key? key,
    this.child,
    this.color = Colors.white,
    this.shadow = true,
    this.animate = true,
    this.points = 9,
    this.rounding = 0.5,
    this.radius = 0.8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepeatedAnimationBuilder(
        play: animate,
        duration: const Duration(seconds: 50),
        start: 0.0,
        end: 1.0,
        builder: (context, value, child) {
          return DecoratedBox(
            decoration: ShapeDecoration(
                shape: StarBorder(
                  pointRounding: 1 - rounding,
                  valleyRounding: rounding,
                  innerRadiusRatio: radius,
                  points: points,
                  rotation: -value * 360,
                ),
                shadows: shadow
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 3,
                          offset: Offset.zero,
                        )
                      ]
                    : null,
                color: color),
            child: this.child,
          );
        });
  }
}

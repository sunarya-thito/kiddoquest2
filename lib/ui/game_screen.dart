import 'dart:async';

import 'package:data_widget/data_widget.dart';
import 'package:flutter/material.dart';
import 'package:kiddoquest2/ui/loading_scene.dart';

class GameScreen extends StatefulWidget {
  final Widget loadingChild;
  final FutureOr<Widget> child;
  final Duration duration;
  final Duration reverseDuration;
  final Duration delay;

  const GameScreen({
    super.key,
    this.loadingChild = const LoadingScene(),
    this.duration = const Duration(milliseconds: 1000),
    this.reverseDuration = const Duration(milliseconds: 1000),
    this.delay = const Duration(milliseconds: 300),
    required this.child,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GlobalKey _loadingSceneKey = GlobalKey();

  late FutureOr<Widget> child;
  Widget? oldChild;

  @override
  void initState() {
    super.initState();
    child = widget.child;
  }

  @override
  void didUpdateWidget(covariant GameScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      FutureOr<Widget> futureOr = child;
      if (futureOr is Future<Widget>) {
        child = futureOr.then(
          (value) {
            oldChild = value;
          },
        ).then((_) async {
          await Future.delayed(
              widget.delay + widget.duration + widget.reverseDuration);
          return await widget.child;
        });
      } else {
        oldChild = futureOr;
        child = Future.delayed(
          widget.delay + widget.duration + widget.reverseDuration,
          () => widget.child,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var futureOr = child;
    if (futureOr is Future<Widget>) {
      return FutureBuilder(
        future: futureOr.catchError((err, trace) {
          print(err);
          print(trace);
        }),
        builder: (context, snapshot) {
          return GameTransitioner(
            key: _loadingSceneKey,
            loadingChild: widget.loadingChild,
            showLoading: snapshot.connectionState != ConnectionState.done,
            duration: widget.duration,
            reverseDuration: widget.reverseDuration,
            delay: widget.delay,
            child: snapshot.data ?? oldChild ?? Container(color: Colors.black),
          );
        },
      );
    }
    return GameTransitioner(
      key: _loadingSceneKey,
      duration: widget.duration,
      reverseDuration: widget.reverseDuration,
      delay: widget.delay,
      loadingChild: const LoadingScene(),
      showLoading: false,
      child: futureOr,
    );
  }
}

class GameScreenInfo {
  final bool visible;
  final double progress;
  final bool showLoading;

  const GameScreenInfo({
    this.visible = true,
    this.progress = 1,
    this.showLoading = false,
  });

  GameScreenInfo copyWith({
    bool? visible,
    double? progress,
    bool? showLoading,
  }) {
    return GameScreenInfo(
      visible: visible ?? this.visible,
      progress: progress ?? this.progress,
      showLoading: showLoading ?? this.showLoading,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GameScreenInfo &&
        other.visible == visible &&
        other.progress == progress &&
        other.showLoading == showLoading;
  }

  @override
  int get hashCode => Object.hash(visible, progress, showLoading);
}

class GameTransitioner extends StatefulWidget {
  final Widget child;
  final Widget loadingChild;
  final bool showLoading;
  final Duration duration;
  final Duration reverseDuration;
  final Duration delay;

  const GameTransitioner({
    Key? key,
    required this.child,
    required this.loadingChild,
    required this.showLoading,
    this.duration = const Duration(seconds: 1),
    this.reverseDuration = const Duration(seconds: 1),
    this.delay = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  State<GameTransitioner> createState() => _GameTransitionerState();
}

class _GameTransitionerState extends State<GameTransitioner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final duration = widget.duration;
    final delay = widget.delay;
    _controller = AnimationController(
      vsync: this,
      duration: widget.showLoading ? duration + delay : duration,
      value: widget.showLoading ? 1 : 0,
    );
  }

  @override
  void didUpdateWidget(covariant GameTransitioner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.showLoading != widget.showLoading) {
      if (widget.showLoading) {
        _controller.duration = widget.duration + widget.delay;
        _controller.forward();
      } else {
        _controller.duration = widget.reverseDuration;
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final duration =
        widget.showLoading ? widget.duration : widget.reverseDuration;
    final delay = widget.delay;
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          double value = _controller.value;
          if (widget.showLoading) {
            double delayValue = delay.inMilliseconds / duration.inMilliseconds;
            value = (value - delayValue) / (1 - delayValue);
            value = value.clamp(0, 1);
          }
          var gameScreenInfo = GameScreenInfo(
            visible: (widget.showLoading && _controller.value >= 0.75) ||
                (!widget.showLoading && _controller.value <= 0.1),
            progress: value,
            showLoading: widget.showLoading,
          );
          return Data.inherit(
            data: gameScreenInfo,
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                widget.child,
                if (value > 0)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        color: Colors.black.withOpacity(value),
                      ),
                    ),
                  ),
                if (value > 0)
                  Positioned.fill(
                    child: widget.loadingChild,
                  ),
              ],
            ),
          );
        });
  }
}

class ClipOvalClipper extends CustomClipper<Rect> {
  final double progress;

  ClipOvalClipper(this.progress);

  @override
  Rect getClip(Size size) {
    double biggestRadius = size.width / 2 + size.height / 2;
    double radius = biggestRadius * progress;
    return Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: radius,
    );
  }

  @override
  bool shouldReclip(covariant ClipOvalClipper oldClipper) {
    return progress != oldClipper.progress;
  }
}

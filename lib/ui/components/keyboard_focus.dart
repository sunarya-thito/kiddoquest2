import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class KeyboardFocus extends StatelessWidget {
  final VoidCallback? onProceed;
  final VoidCallback? onCancel;
  final Widget child;
  const KeyboardFocus(
      {super.key, this.onProceed, this.onCancel, required this.child});

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.enter ||
            event.logicalKey == LogicalKeyboardKey.space) {
          onProceed?.call();
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.escape ||
            event.logicalKey == LogicalKeyboardKey.backspace) {
          onCancel?.call();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: child,
    );
  }
}

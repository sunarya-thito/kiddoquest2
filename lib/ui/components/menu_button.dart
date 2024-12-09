import 'package:flutter/material.dart';
import 'package:kiddoquest2/assets/theme.dart';

enum MenuButtonType {
  right(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20),
        topLeft: Radius.circular(90),
      ),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 80)),
  center(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        bottomLeft: Radius.circular(90),
        topRight: Radius.circular(90),
        bottomRight: Radius.circular(20),
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 80)),
  left(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(90),
        bottomRight: Radius.circular(20),
      ),
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 80)),
  ;

  final BorderRadius borderRadius;
  final Alignment alignment;
  final EdgeInsets padding;

  const MenuButtonType({
    required this.borderRadius,
    required this.alignment,
    required this.padding,
  });
}

class MenuButton extends StatefulWidget {
  final Widget label;
  final Widget? icon;
  final VoidCallback? onPressed;
  final double hoverWidthExpand;
  final double width;
  final double height;
  final double fontSize;
  final MenuButtonType type;

  const MenuButton({
    Key? key,
    required this.label,
    this.icon,
    this.onPressed,
    this.hoverWidthExpand = 100,
    this.height = 120,
    this.fontSize = 50,
    required this.width,
    required this.type,
  }) : super(key: key);

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  bool _hovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          _hovering = true;
        });
      },
      onExit: (_) {
        setState(() {
          _hovering = false;
        });
      },
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          height: widget.height,
          width: widget.width + (_hovering ? widget.hoverWidthExpand : 0),
          decoration: BoxDecoration(
              color: colorStrongYellow,
              borderRadius: widget.type.borderRadius,
              border: Border.all(
                color: Colors.black,
                width: 5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(0, 10),
                  blurRadius: 0,
                ),
              ]),
          alignment: widget.type.alignment,
          padding: widget.type.padding,
          child: DefaultTextStyle(
            style: TextStyle(
              fontFamily: 'MoreSugar',
              fontSize: widget.fontSize,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null)
                  Transform.scale(
                    scale: 1.75,
                    alignment: Alignment.bottomRight,
                    child: Transform.translate(
                      offset: const Offset(0, 9),
                      child: widget.icon!,
                    ),
                  ),
                if (widget.icon != null) SizedBox(width: 50),
                widget.label,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MenuIconButton extends StatefulWidget {
  final Widget icon;
  final VoidCallback onPressed;

  const MenuIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<MenuIconButton> createState() => _MenuIconButtonState();
}

class _MenuIconButtonState extends State<MenuIconButton> {
  bool _hovering = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() {
            _hovering = true;
          });
        },
        onExit: (_) {
          setState(() {
            _hovering = false;
          });
        },
        child: Transform.scale(
          scale: _hovering ? 1.1 : 1,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorStrongYellow,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black,
                width: 5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(0, 10),
                  blurRadius: 0,
                ),
              ],
            ),
            child: IconTheme(
              data: IconThemeData(
                size: 70,
                color: Colors.black,
              ),
              child: widget.icon,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class OnHoverButton extends StatefulWidget {
  final Widget child;
  final Function onHover;

  const OnHoverButton({super.key, required this.child, required this.onHover});

  @override
  State<OnHoverButton> createState() => OnHoverButtonState();
}

class OnHoverButtonState extends State<OnHoverButton> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onEnter: (event) {
          setState(() {
            widget.onHover(true);
          });
        },
        onExit: (event) {
          setState(() {
            widget.onHover(false);
          });
        },
        cursor: SystemMouseCursors.click,
        child: widget.child);
  }
}

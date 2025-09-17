import 'package:flutter/material.dart';

import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/widgets/home/octagonborder.dart';

class TagButton extends StatelessWidget {
  const TagButton({
    super.key,
    required this.text,
    this.globalTagId,
    this.onPressed,
    this.arguments,
    this.width = 150,
    this.height = 35,
    this.tooltipThreshold = 17,
    this.textStyle,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  });

  final String text;
  final Object? globalTagId;
  final VoidCallback? onPressed;
  final Object? arguments;
  final double? width;
  final double? height;
  final int tooltipThreshold;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    final bool shouldShowTooltip =
        tooltipThreshold >= 0 && text.length > tooltipThreshold;

    Widget button = Material(
      shape: const OctagonBorder(),
      color: AppColor.tagcolor,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        customBorder: const OctagonBorder(),
        onTap: _hasTapHandler ? () => _handleTap(context) : null,
        hoverColor: Colors.blue,
        child: Container(
          padding: contentPadding,
          alignment: Alignment.center,
          constraints: BoxConstraints.tightFor(
            width: width,
            height: height,
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: textStyle ?? const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );

    if (shouldShowTooltip) {
      button = Tooltip(
        message: text,
        child: button,
      );
    }

    return button;
  }

  bool get _hasTapHandler => onPressed != null || globalTagId != null;

  void _handleTap(BuildContext context) {
    if (onPressed != null) {
      onPressed!();
      return;
    }

    if (globalTagId != null) {
      final String routeId = globalTagId.toString();
      Navigator.pushNamed(
        context,
        '/globaltag/$routeId',
        arguments: arguments ?? {'text': text, 'globaltagid': globalTagId},
      );
    }
  }
}

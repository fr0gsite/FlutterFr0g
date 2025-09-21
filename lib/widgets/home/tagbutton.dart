import 'package:flutter/material.dart';

import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/widgets/home/octagonborder.dart';

class TagButton extends StatelessWidget {
  const TagButton({
    super.key,
    required this.text,
    required this.globaltagid,
    this.heroTag,
    this.onPressed,
    this.width,
    this.height = 35,
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
    this.tooltipThreshold = 17,
  });

  final String text;
  final BigInt globaltagid;
  final Object? heroTag;
  final VoidCallback? onPressed;
  final double? width;
  final double height;
  final EdgeInsetsGeometry padding;
  final int tooltipThreshold;

  @override
  Widget build(BuildContext context) {
    Widget button = MaterialButton(
      onPressed: onPressed ?? () => _navigateToTag(context),
      shape: const OctagonBorder(),
      color: AppColor.tagcolor,
      hoverColor: Colors.blue,
      padding: EdgeInsets.zero,
      child: SizedBox(
        width: width,
        height: height,
        child: Center(
          child: Padding(
            padding: padding,
            child: Text(
              text,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    if (heroTag != null) {
      button = Hero(
        tag: heroTag!,
        child: Material(
          type: MaterialType.transparency,
          child: button,
        ),
      );
    }

    return Tooltip(
      message: text.length > tooltipThreshold ? text : '',
      child: button,
    );
  }

  void _navigateToTag(BuildContext context) {
    debugPrint('Show Globaltag $text ');
    Navigator.pushNamed(context, '/globaltag/$globaltagid',
        arguments: {'text': text, 'globaltagid': globaltagid});
  }
}

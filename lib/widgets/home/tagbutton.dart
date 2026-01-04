import 'package:flutter/material.dart';

import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/widgets/home/octagonborder.dart';

class TagButton extends StatefulWidget {
  const TagButton({
    super.key,
    required this.text,
    required this.globaltagid,
    this.heroTag,
  });

  final String text;
  final BigInt globaltagid;
  final Object? heroTag;

  @override
  State<TagButton> createState() => TagButtonState();
}

class TagButtonState extends State<TagButton> {
  double tagwidth = 150;

  @override
  Widget build(BuildContext context) {
    Widget button = MaterialButton(
      onPressed: () {
        debugPrint('Show Globaltag ${widget.text} ');
        Navigator.pushNamed(context, '/${AppConfig.globaltagurlpath}/${widget.globaltagid}',
            arguments: {'text': widget.text, 'globaltagid': widget.globaltagid});
      },
      shape: const OctagonBorder(),
      color: AppColor.tagcolor,
      hoverColor: Colors.blue,
      child: SizedBox(
        width: tagwidth,
        height: 35,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );

    if (widget.heroTag != null) {
      button = Hero(
        tag: widget.heroTag!,
        child: Material(
          type: MaterialType.transparency,
          child: button,
        ),
      );
    }

    return Tooltip(
      message: widget.text.length > 17 ? widget.text : '',
      child: button,
    );
  }
}

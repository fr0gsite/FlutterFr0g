import 'package:flutter/material.dart';

import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/widgets/home/octagonborder.dart';

class TagButton extends StatefulWidget {
  const TagButton({super.key, required this.text, required this.globaltagid});

  final String text;
  final BigInt globaltagid;

  @override
  State<TagButton> createState() => TagButtonState();
}

class TagButtonState extends State<TagButton> {
  double tagwidth = 150;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        debugPrint('Show Globaltag ${widget.text} ');
        Navigator.pushNamed(context, '/globaltag/${widget.globaltagid}',
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
  }
}
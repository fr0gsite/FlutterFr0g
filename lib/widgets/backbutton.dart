import 'package:flutter/material.dart';
import 'package:fr0gsite/config.dart';

Widget backButton(context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.nicegrey,
          borderRadius: BorderRadius.circular(50),
        ),
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.backspace_rounded,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () {
            if (Navigator.canPop(context)) {
              //Provider.of<PostviewerStatus>(context, listen: false).pause();
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
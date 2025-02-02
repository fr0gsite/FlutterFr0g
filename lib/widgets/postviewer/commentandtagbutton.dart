import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

Widget commentandtagbutton(String id, IconData icon, String tooltip, function,
    bool isliked, int likecount, Color primary, Color secondary) {
  return Tooltip(
    message: tooltip,
    child: LikeButton(
        mainAxisAlignment: MainAxisAlignment.start,
        size: 25,
        circleColor: CircleColor(start: primary, end: primary),
        bubblesColor: BubblesColor(
          dotPrimaryColor: primary,
          dotSecondaryColor: secondary,
        ),
        isLiked: isliked,
        likeBuilder: (bool isLiked) {
          return Icon(
            icon,
            color: isLiked ? primary : Colors.white,
            size: 25,
          );
        },
        onTap: (isliked) async {
          bool result = await function(id);
          return result;
        }),
  );
}

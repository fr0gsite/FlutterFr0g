import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/widgets/games/gametitle.dart';
import 'package:flutter/material.dart';

class Games extends StatefulWidget {
  const Games({super.key});

  @override
  State<Games> createState() => _GamesState();
}

class _GamesState extends State<Games> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        color: AppColor.nicegrey,
        child: GridView.count(
          crossAxisCount: 2,
          children: List.generate(GameConfig().gamelist.length, (index) {
            return Center(
              child: GameTitle(index: index),
            );
          }),
        ),
      );
    });
  }
}

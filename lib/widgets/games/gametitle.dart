import 'package:auto_size_text/auto_size_text.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GameTitle extends StatefulWidget {
  final int index;
  const GameTitle({super.key, required this.index});

  @override
  State<GameTitle> createState() => _GameTitleState();
}

class _GameTitleState extends State<GameTitle> {
  List<Game> gamelist = GameConfig().gamelist;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          InkWell(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(gamelist.elementAt(widget.index).imagepath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          !gamelist.elementAt(widget.index).active
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                  ),
                  child: Center(
                    child: AutoSizeText(
                      AppLocalizations.of(context)!
                          .thisfeatureisnotavailableyet,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                  ))
              : Container(),
        ],
      ),
    );
  }
}

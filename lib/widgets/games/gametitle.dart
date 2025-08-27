import 'package:auto_size_text/auto_size_text.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/game.dart';
import 'package:flutter/material.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';
import 'package:fr0gsite/widgets/games/slot_machine.dart';

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
            onTap: () {
              final game = gamelist.elementAt(widget.index);
              if (!game.active) {
                return;
              }
              if (game.name == 'How Lucky') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SlotMachine()),
                );
              }
            },
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
                    color: Colors.black.withAlpha((0.8 * 255).toInt()),
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

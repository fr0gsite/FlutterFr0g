import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/widgets/ageverification/quiz.dart';
import 'package:fr0gsite/widgets/ageverification/quizcard.dart';
import 'package:fr0gsite/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchButton extends StatefulWidget {
  const SearchButton({super.key});

  @override
  State<SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<SearchButton> {
  @override
  Widget build(BuildContext context) {
    if (Provider.of<GlobalStatus>(context).isLoggedin) {
      return IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: ((context) {
                return Quiz();
              }));

          //showGeneralDialog(
          //  context: context,
          //  pageBuilder: (context, anim1, anim2) => const Search(),
          //  barrierDismissible: true,
          //  barrierLabel: "Search",
          //  transitionDuration: const Duration(milliseconds: 300),
          //  transitionBuilder: (context, anim1, anim2, child) => FadeTransition(
          //    opacity: anim1,
          //    child: child,
          //  ),
          //);
        },
        icon: const Icon(
          Icons.search,
          color: Colors.white,
        ),
      );
    } else {
      return Container();
    }
  }
}

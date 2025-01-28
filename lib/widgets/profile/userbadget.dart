import 'package:fr0gsite/datatypes/userconfig.dart';
import 'package:flutter/material.dart';

class Userbadget extends StatelessWidget {
  final UserConfig userconfig;
  const Userbadget({super.key, required this.userconfig});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withAlpha((0.4 * 255).toInt()),
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: const BoxConstraints(
        maxWidth: 800,
      ),
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 60,
                height: 60,
                child: Image.asset(
                  "assets/images/badge/comments50.png",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 60,
                height: 60,
                child: Image.asset(
                  "assets/images/badge/firstuser.png",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

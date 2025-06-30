import 'package:auto_size_text/auto_size_text.dart';
import 'package:fr0gsite/datatypes/uploadstatus.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';

class UploadScreen1 extends StatelessWidget {
  const UploadScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  "assets/lottie/upload.json",
                  height: 125,
                  width: 125,
                ),
                Text(
                  AppLocalizations.of(context)!.upload,
                  style: const TextStyle(fontSize: 40, color: Colors.white),
                ),
              ],
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.red.withAlpha((0.5 * 255).toInt()),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info,
                    size: 50,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AutoSizeText(
                      AppLocalizations.of(context)!.uploadipfscarateristicsinfo,
                      maxFontSize: 20,
                      minFontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LikeButton(
                  size: 50,
                  circleColor: const CircleColor(
                    start: Colors.green,
                    end: Colors.green,
                  ),
                  isLiked: Provider.of<Uploadstatus>(context, listen: false)
                      .acceptedfirst,
                  bubblesColor: const BubblesColor(
                    dotPrimaryColor: Colors.green,
                    dotSecondaryColor: Colors.green,
                  ),
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      Icons.check_box,
                      color: isLiked ? Colors.green : Colors.grey,
                      size: 50,
                    );
                  },
                  onTap: (bool isLiked) async {
                    debugPrint(isLiked.toString());
                    Provider.of<Uploadstatus>(context, listen: false)
                        .changeonacceptedfirst(!isLiked);
                    return !isLiked;
                  },
                ),
                Text(AppLocalizations.of(context)!.okiunderstood),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

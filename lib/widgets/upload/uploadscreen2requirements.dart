import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/uploadstatus.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UploadScreen2requirements extends StatelessWidget {
  const UploadScreen2requirements({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> requirements = [
      AppLocalizations.of(context)!.max15MBfilesize,
      AppLocalizations.of(context)!.uploadresolution,
      AppLocalizations.of(context)!.thumbresolution,
    ];

    double textsize = 16;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                "assets/lottie/checklist.json",
                height: 125,
                width: 125,
                repeat: false,
              ),
              Text(
                AppLocalizations.of(context)!.checkRequirements,
                style: const TextStyle(fontSize: 25, color: Colors.white),
              ),
            ],
          ),
          Column(
            children: requirements.map<Widget>((text) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.check, color: Colors.green),
                    ),
                    Text(text,
                        style:
                            TextStyle(fontSize: textsize, color: Colors.white)),
                  ],
                ),
              );
            }).toList()
              ..add(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.rule,
                          color: Colors.green,
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            launchUrl(Uri.parse(Documentation.rules));
                          },
                          child: Text(
                              AppLocalizations.of(context)!
                                  .alinewithRuleswithlink,
                              style: TextStyle(
                                  color: Colors.orange,
                                  decoration: TextDecoration.underline,
                                  fontSize: textsize)))
                    ],
                  ),
                ),
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
                    .acceptedsecond,
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
                      .changeonacceptedsecond(!isLiked);
                  return !isLiked;
                },
              ),
              Text(AppLocalizations.of(context)!.okiunderstood),
            ],
          ),
        ],
      ),
    );
  }
}

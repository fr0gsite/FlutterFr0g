import 'package:auto_size_text/auto_size_text.dart';
import 'package:fr0gsite/datatypes/ipfsnode.dart';
import 'package:fr0gsite/datatypes/networkstatus.dart';
import 'package:fr0gsite/datatypes/uploadstatus.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';

class Uploadconfirm extends StatelessWidget {
  const Uploadconfirm({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Uploadstatus>(builder: (context, uploadstatus, child) {
      //Show all collected information
      return Column(
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
                "${AppLocalizations.of(context)?.confirm}",
                style: const TextStyle(fontSize: 25, color: Colors.white),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  uploadstatus.acceptedfirst
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  color: uploadstatus.acceptedfirst ? Colors.green : Colors.red,
                ),
              ),
              AutoSizeText(
                "${AppLocalizations.of(context)?.unserstoodIPFScharacteristics}",
                minFontSize: 15,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  uploadstatus.acceptedsecond
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  color:
                      uploadstatus.acceptedsecond ? Colors.green : Colors.red,
                ),
              ),
              AutoSizeText(
                "${AppLocalizations.of(context)?.agreeUploadRequirements}",
                minFontSize: 15,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            color: uploadstatus.testedipfshash & uploadstatus.testedipfsthumb
                ? null
                : Colors.orange.withAlpha((0.2 * 255).toInt()),
            child: Column(
              children: [
                Text("${AppLocalizations.of(context)?.pleasetestipfs}:"),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        uploadstatus.testedipfshash
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: uploadstatus.testedipfshash
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    Text(uploadstatus.textfieldipfshash.text == ""
                        ? "${AppLocalizations.of(context)?.noinformationyet}"
                        : truncateMiddle(
                            uploadstatus.textfieldipfshash.text, 30)),
                    TextButton(
                        onPressed: () {
                          if (uploadstatus.textfieldipfshash.text != "") {
                            IPFSNode ipfsnodefortest =
                                Provider.of<NetworkStatus>(context,
                                        listen: false)
                                    .currentipfsnode;
                            launchUrl(Uri.parse(
                                "${ipfsnodefortest.fullurl}${uploadstatus.textfieldipfshash.text}"));
                            uploadstatus.testedipfshashfunction();
                          }
                        },
                        child: Container(
                            color: uploadstatus.testedipfshash
                                ? Colors.green
                                : Colors.red,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                uploadstatus.testedipfshash
                                    ? "${AppLocalizations.of(context)?.tested}"
                                    : "${AppLocalizations.of(context)?.testhere}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            )))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        uploadstatus.testedipfsthumb
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: uploadstatus.testedipfsthumb
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    Text(uploadstatus.textfieldipfsthumb.text == ""
                        ? "${AppLocalizations.of(context)?.noinformationyet}"
                        : truncateMiddle(
                            uploadstatus.textfieldipfsthumb.text, 30)),
                    TextButton(
                        onPressed: () {
                          if (uploadstatus.textfieldipfsthumb.text != "") {
                            IPFSNode ipfsnodefortest =
                                Provider.of<NetworkStatus>(context,
                                        listen: false)
                                    .currentipfsnode;
                            launchUrl(Uri.parse(
                                "${ipfsnodefortest.fullurl}${uploadstatus.textfieldipfsthumb.text}"));
                            uploadstatus.testedipfsthumbfunction();
                          }
                        },
                        child: Container(
                            color: uploadstatus.testedipfsthumb
                                ? Colors.green
                                : Colors.red,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                uploadstatus.testedipfsthumb
                                    ? "${AppLocalizations.of(context)?.tested}"
                                    : "${AppLocalizations.of(context)?.testhere}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ))),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                    uploadstatus.selecteduploadfiletype != ""
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: uploadstatus.selecteduploadfiletype != ""
                        ? Colors.green
                        : Colors.red),
              ),
              Text(
                  "${AppLocalizations.of(context)?.selecteduploadfiletype}: ${uploadstatus.selecteduploadfiletype}"),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                    uploadstatus.selectedthumbfiletype != ""
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: uploadstatus.selectedthumbfiletype != ""
                        ? Colors.green
                        : Colors.red),
              ),
              Text(
                  "${AppLocalizations.of(context)?.selectedthumbfiletype}: ${uploadstatus.selectedthumbfiletype}"),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                    uploadstatus.selectedlanguage != ""
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: uploadstatus.selectedlanguage != ""
                        ? Colors.green
                        : Colors.red),
              ),
              Text(
                  "${AppLocalizations.of(context)?.selectedlanguage}: ${uploadstatus.selectedlanguage}"),
            ],
          )
        ],
      );
    });
  }

  String truncateMiddle(String text, int length) {
    if (text.length <= length) return text;

    int halfLength = length ~/ 2;
    return '${text.substring(0, halfLength)}...${text.substring(text.length - halfLength)}';
  }
}

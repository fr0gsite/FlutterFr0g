import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fr0gsite/datatypes/uploadfeedback.dart';
import 'package:fr0gsite/datatypes/uploadstatus.dart';
import 'package:fr0gsite/widgets/upload/uploadcommunitynode/uploadscreencommunitynode.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Uploadscreen3provider extends StatefulWidget {
  const Uploadscreen3provider({super.key});

  @override
  State<Uploadscreen3provider> createState() => _Uploadscreen3providerState();
}

class _Uploadscreen3providerState extends State<Uploadscreen3provider> {
  void feedback(bool success, UploadFeedback uploadfeedback) {
    if (success) {
      Provider.of<Uploadstatus>(context, listen: false).textfieldipfshash.text =
          uploadfeedback.uploadipfshash;
      Provider.of<Uploadstatus>(context, listen: false)
          .textfieldipfsthumb
          .text = uploadfeedback.thumbipfshash;
      Provider.of<Uploadstatus>(context, listen: false).selecteduploadfiletype =
          uploadfeedback.uploadipfshashfiletyp;
      Provider.of<Uploadstatus>(context, listen: false).selectedthumbfiletype =
          uploadfeedback.thumbipfshashfiletyp;
      Provider.of<Uploadstatus>(context, listen: false).nextStep(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<List<dynamic>> providerList = [
      [
        '${AppLocalizations.of(context)?.byyourself}',
        Icons.home_outlined,
        "https://docs.ipfs.tech/install/ipfs-desktop/",
        "${AppLocalizations.of(context)?.provideryourselftext}"
      ],
      [
        '${AppLocalizations.of(context)?.withpinata}',
        Icons.supervisor_account_outlined,
        "https://www.pinata.cloud/pricing",
        "${AppLocalizations.of(context)?.providerpinatatext}"
      ],
      [
        '${AppLocalizations.of(context)?.withfilebase}',
        Icons.supervisor_account_outlined,
        "https://filebase.com/",
        "${AppLocalizations.of(context)?.providerfilebasetext}"
      ],
      [
        '${AppLocalizations.of(context)?.withfilecoin}',
        Icons.now_widgets_sharp,
        "https://web3.storage/",
        "${AppLocalizations.of(context)?.providerfilecointext}"
      ],
      [
        '${AppLocalizations.of(context)?.withCloudProvider}',
        Icons.cloud_outlined,
        "https://github.com/yeasy/docker-ipfs",
        "${AppLocalizations.of(context)?.providercloudtext}"
      ],
    ];

    return Wrap(
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
              "${AppLocalizations.of(context)?.provider}",
              style: const TextStyle(fontSize: 25, color: Colors.white),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: AutoSizeText(
            "${AppLocalizations.of(context)?.selectprovider}",
            style: const TextStyle(color: Colors.white),
          ),
        ),
        ListTile(
            leading: const Icon(
              Icons.cloud_outlined,
              color: Colors.white,
            ),
            title: Row(
              children: [
                const Text(
                  "Coummunity Nodes",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      "Reccomended",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            subtitle: const Text(
              "Use the community nodes to store your data",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => UploadScreencommunitynode(
                        feedback: feedback,
                      ));
            }),
        for (int i = 0; i < providerList.length; i++)
          ListTile(
              leading: Icon(
                providerList[i][1] as IconData?,
                color: Colors.white,
              ),
              title: AutoSizeText(
                providerList[i][0] as String,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: AutoSizeText(
                providerList[i][3] as String,
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () {
                launchUrl(Uri.parse(providerList[i][2] as String));
              }),
      ],
    );
  }
}

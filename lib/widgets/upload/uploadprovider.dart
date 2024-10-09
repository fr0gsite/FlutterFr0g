import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Uploadprovider extends StatefulWidget {
  const Uploadprovider({super.key});

  @override
  State<Uploadprovider> createState() => _UploadproviderState();
}

class _UploadproviderState extends State<Uploadprovider> {
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

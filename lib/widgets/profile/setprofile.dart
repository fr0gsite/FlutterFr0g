import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/locationandlanguage.dart';
import 'package:fr0gsite/datatypes/userconfig.dart';
import 'package:provider/provider.dart';

class SetProfile extends StatefulWidget {
  const SetProfile({super.key});

  @override
  State<SetProfile> createState() => _SetProfileState();
}

class _SetProfileState extends State<SetProfile> {
  final TextEditingController ipfstextcontroller = TextEditingController();
  final TextEditingController biotextcontroller = TextEditingController();
  String languageDropdownValue = "en"; // Default value for the dropdown

  UserConfig userconfig = UserConfig.dummy();

  @override
  void initState() {
    super.initState();
    loadcurrentprofile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editprofile),
      ),
      backgroundColor: AppColor.niceblack,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //IPFS
            TextField(
              controller: ipfstextcontroller,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.profileimageipfs,
                labelStyle: const TextStyle(color: Colors.white),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 3),
                ),
                filled: true,
                fillColor: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 16),
            //Bio
            TextField(
              controller: biotextcontroller,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.profilebio,
                  labelStyle: const TextStyle(color: Colors.white),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 3),
                  ),
                  filled: true,
                  fillColor: Colors.blueGrey),
              onSubmitted: (value) {},
              onChanged: (value) {},
              maxLength: 256,
              maxLines: 3,
            ),
            // Language Dropdown
            DropdownButton<String>(
              dropdownColor: AppColor.niceblack,
              value: languageDropdownValue,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              items: AppConfig.applanguage.map((language) {
                return DropdownMenuItem<String>(
                  value: language.countrycode, // Convert to String if necessary
                  child: Row(
                    children: [
                      CountryFlag.fromCountryCode(language.countrycode), // Display the country code
                      const SizedBox(height: 4),
                      Text(language.languagename), // Display the language name
                    ],
                  ), // Adjust display text
                );
              }).toList().cast<DropdownMenuItem<String>>(), // Ensure correct type
              onChanged: (String? newValue) {
                // Handle language selection
                setState(() {
                  languageDropdownValue = newValue!;
                });
                Provider.of<LocationandLanguage>(context, listen: false)
                    .setLocale(Locale.fromSubtags(
                  languageCode: newValue!,
                  countryCode: newValue,
                ));
              },
              hint: Text(AppLocalizations.of(context)!.language),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Check if ipfs link is valid and not exceeds the limit
                Chainactions tempchainactions = Chainactions();
                String username = Provider.of<GlobalStatus>(context, listen: false).username;
                String permission = Provider.of<GlobalStatus>(context, listen: false).permission;
                tempchainactions.setusernameandpermission(username, permission);
                tempchainactions.setuserprofile(
                  username,
                  biotextcontroller.text,
                  userconfig.profileimageipfs,
                  userconfig.profileimagefiletyp,
                  languageDropdownValue,
                  userconfig.otherconfigsasjson,
                );
              },
              child: Text(AppLocalizations.of(context)!.save),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadcurrentprofile() async {
    // Load current profile data if available and set it to the text field
    // get current user
    final currentuser = Provider.of<GlobalStatus>(context, listen: false).username;
    Chainactions().getuserconfig(currentuser).then((value) {
      setState(() {
        userconfig = value;
        biotextcontroller.text = userconfig.profilebio;
        ipfstextcontroller.text = userconfig.profileimageipfs;
        languageDropdownValue = userconfig.language;
      });
        }).catchError((error) {
      // Handle any errors that occur during the fetch
      debugPrint("Error fetching user config: $error");
    });

  }
}

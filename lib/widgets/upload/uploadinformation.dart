import 'package:auto_size_text/auto_size_text.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/uploadstatus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Uploadinformation extends StatefulWidget {
  const Uploadinformation({super.key});

  @override
  State<Uploadinformation> createState() => _UploadinformationState();
}

// Enter Uploadinformation
//* ipfs hash
//* ipfs filetype
//* ipfs thumbnail
//* uploadtext
//* language
//* flag

class _UploadinformationState extends State<Uploadinformation> {
  @override
  Widget build(BuildContext context) {
    List<String> translatedcontentflag = [
      AppLocalizations.of(context)!.safeforwork,
      AppLocalizations.of(context)!.erotic,
      AppLocalizations.of(context)!.brutal,
    ];

    return Consumer<Uploadstatus>(builder: (context, uploadstatus, child) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.upload_file, size: 50, color: Colors.white),
                  AutoSizeText(
                    "${AppLocalizations.of(context)?.detailsabouttheupload}",
                    minFontSize: 20,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 4,
                    child: TextField(
                      controller: uploadstatus.textfieldipfshash,
                      onSubmitted: (value) {
                        uploadstatus.textfieldipfshash.text = value;
                      },
                      style: const TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText:
                              '${AppLocalizations.of(context)?.ipfsHashofMedia}',
                          labelStyle: const TextStyle(color: Colors.white),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 3),
                          ),
                          filled: true,
                          fillColor: Colors.blueGrey),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.blueGrey,
                        ),
                        child: DropdownButton(
                          borderRadius: BorderRadius.circular(5),
                          dropdownColor: Colors.blueGrey,
                          alignment: Alignment.center,
                          hint: Text(
                            "${AppLocalizations.of(context)?.filetype}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          value: uploadstatus.selecteduploadfiletype == ""
                              ? null
                              : uploadstatus.selecteduploadfiletype,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          items: AppConfig.alloweduploadfiletypes.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              uploadstatus.selecteduploadfiletype =
                                  value.toString();
                            });
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: TextField(
                      controller: uploadstatus.textfieldipfsthumb,
                      onSubmitted: (value) {
                        uploadstatus.textfieldipfsthumb.text = value;
                      },
                      style: const TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText:
                              '${AppLocalizations.of(context)?.ipfsHashofThumb}',
                          labelStyle: const TextStyle(color: Colors.white),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 3),
                          ),
                          filled: true,
                          fillColor: Colors.blueGrey),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.blueGrey,
                        ),
                        child: DropdownButton(
                          dropdownColor: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(5),
                          alignment: Alignment.center,
                          hint: Text(
                            "${AppLocalizations.of(context)?.filetype}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          value: uploadstatus.selectedthumbfiletype == ""
                              ? null
                              : uploadstatus.selectedthumbfiletype,
                          style: const TextStyle(color: Colors.white),
                          items: AppConfig.allowedthumbfiletypes.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              uploadstatus.selectedthumbfiletype =
                                  value.toString();
                            });
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.blueGrey,
                    ),
                    child: DropdownButton(
                      borderRadius: BorderRadius.circular(5),
                      alignment: Alignment.center,
                      value: uploadstatus.selectedlanguage == ""
                          ? null
                          : uploadstatus.selectedlanguage,
                      dropdownColor: Colors.blueGrey,
                      hint: Text(
                        "${AppLocalizations.of(context)?.thelanguage}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.white),
                      items: AppConfig.applanguage.map((e) {
                        return DropdownMenuItem(
                          value: e.languagename,
                          child: Text(e.languagename),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          uploadstatus.selectedlanguage = value.toString();
                        });
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.blueGrey,
                    ),
                    child: DropdownButton(
                      borderRadius: BorderRadius.circular(5),
                      alignment: Alignment.center,
                      value: uploadstatus.selectedflag == ContentFlag.none
                          ? null
                          : translatedcontentflag[
                              uploadstatus.selectedflag.index],
                      dropdownColor: Colors.blueGrey,
                      hint: Text(
                        "${AppLocalizations.of(context)?.flag}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.white),
                      items: translatedcontentflag.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          uploadstatus.selectedflag = ContentFlag.values[
                              translatedcontentflag.indexOf(value.toString())];
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            TextField(
              maxLines: 5,
              controller: uploadstatus.textfielduploadtext,
              onSubmitted: (value) {
                uploadstatus.textfielduploadtext.text = value;
              },
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)!.uploadtextoptional,
                  labelStyle: const TextStyle(color: Colors.white),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 3),
                  ),
                  filled: true,
                  fillColor: Colors.blueGrey),
            ),
          ],
        ),
      );
    });
  }
}

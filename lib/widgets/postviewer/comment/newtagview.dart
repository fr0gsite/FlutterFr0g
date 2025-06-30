import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/postviewerstatus.dart';
import 'package:fr0gsite/widgets/infoscreens/cbcircularprogressindicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';

class NewTagView extends StatefulWidget {
  const NewTagView({super.key, required this.callback});
  final void Function(bool value, String newtag) callback;
  @override
  State<NewTagView> createState() => _NewTagViewState();
}

class _NewTagViewState extends State<NewTagView> {
  bool isLoading = false;
  TextEditingController textcontroller = TextEditingController();
  int textlength = 0;
  int maxtextlength = AppConfig.maxTagLength;

  @override
  void initState() {
    super.initState();
    textcontroller.addListener(() {
      setState(() {
        textlength = textcontroller.text.length;
        if (textcontroller.text.length > maxtextlength) {
          textcontroller.text = textcontroller.text.substring(0, maxtextlength);
          textlength = textcontroller.text.length;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: SingleChildScrollView(
        child: SizedBox(
          width: 500,
          child: Material(
            color: AppColor.nicegrey,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                side: BorderSide(
                  color: Colors.blue,
                  width: 6,
                )),
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: textcontroller,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Tag',
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '$textlength/$maxtextlength',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FloatingActionButton.extended(
                      heroTag: null,
                      onPressed: () async {
                        String uploadid = Provider.of<PostviewerStatus>(context,
                                listen: false)
                            .currentupload
                            .uploadid
                            .toString();
                        setState(() {
                          isLoading = true;
                        });

                        bool response =
                            await addtag(uploadid, textcontroller.text);

                        setState(() {
                          isLoading = false;
                        });

                        if (response) {
                          widget.callback(true, textcontroller.text);
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        } else {
                          widget.callback(false, "");
                        }
                      },
                      hoverColor: Colors.blue,
                      backgroundColor: Colors.blue.withAlpha((0.8 * 255).toInt()),
                      label: isLoading
                          ? const CBCircularProgressIndicator()
                          : Text(AppLocalizations.of(context)!.addtag,
                              style: const TextStyle(color: Colors.white)),
                      icon: const Icon(Icons.reply, color: Colors.white),
                      shape: ShapeBorder.lerp(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          0.5),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> addtag(String uploadid, String tagtext) async {
    String username =
        Provider.of<GlobalStatus>(context, listen: false).username;
    String permission =
        Provider.of<GlobalStatus>(context, listen: false).permission;
    Chainactions tempChainactions = Chainactions();
    tempChainactions.setusernameandpermission(username, permission);
    bool result = await tempChainactions.addtag(uploadid, tagtext);
    return result;
  }
}

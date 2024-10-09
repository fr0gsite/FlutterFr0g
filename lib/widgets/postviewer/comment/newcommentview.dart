import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/postviewerstatus.dart';
import 'package:fr0gsite/widgets/infoscreens/cbcircularprogressindicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class NewCommentView extends StatefulWidget {
  const NewCommentView({super.key, required this.callback});
  final void Function(bool value, String newcomment) callback;

  @override
  State<NewCommentView> createState() => _NewCommentViewState();
}

class _NewCommentViewState extends State<NewCommentView> {
  bool isLoading = false;
  TextEditingController textcontroller = TextEditingController();
  int textlength = 0;
  int maxtextlength = AppConfig.maxCommentLength;

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
          width: MediaQuery.of(context).size.width * 0.8,
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
                      cursorColor: Colors.white,
                      cursorRadius: const Radius.circular(10),
                      maxLines: 10,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 3)),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 3),
                        ),
                        labelText: AppLocalizations.of(context)!.yourcomment,
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Text(
                            "$textlength/$maxtextlength",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FloatingActionButton.extended(
                      heroTag: null,
                      onPressed: () {
                        performNetworkRequest(context);
                      },
                      hoverColor: Colors.blue,
                      backgroundColor: Colors.blue.withOpacity(0.8),
                      label: isLoading
                          ? const CBCircularProgressIndicator()
                          : Text(AppLocalizations.of(context)!.reply,
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

  @override
  void dispose() {
    textcontroller.dispose();
    super.dispose();
  }

  Future<void> performNetworkRequest(thecontext) async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    String username =
        Provider.of<GlobalStatus>(thecontext, listen: false).username;
    String permission =
        Provider.of<GlobalStatus>(thecontext, listen: false).permission;
    String uploadid = Provider.of<PostviewerStatus>(thecontext, listen: false)
        .currentupload
        .uploadid
        .toString();

    Chainactions tempChainactions = Chainactions();
    tempChainactions.setusernameandpermission(username, permission);

    bool response = await tempChainactions.addcomment(
        username, textcontroller.text, uploadid, "de");

    if (mounted) {
      if (response) {
        widget.callback(true, textcontroller.text);
        Navigator.pop(thecontext);
      } else {
        widget.callback(false, "");
      }

      setState(() {
        isLoading = false;
      });
    }
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fr0gsite/chainactions/uploadactions.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/postviewerstatus.dart';
import 'package:fr0gsite/datatypes/tag.dart';
import 'package:fr0gsite/widgets/login/login.dart';
import 'package:fr0gsite/widgets/postviewer/comment/newtagview.dart';
import 'package:fr0gsite/widgets/postviewer/tagelemente.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Taglist extends StatefulWidget {
  const Taglist({super.key, required this.uploadid});
  final int uploadid;

  @override
  State<Taglist> createState() => _TaglistState();
}

class _TaglistState extends State<Taglist> {
  List<Tag> taglist = [];
  Future loadtags = Future.value(false);
  int lastuploadid = 0;

  void callback(bool value, String newtag) {
    if (value) {
      debugPrint("New Tag callback with: $newtag");
    }
  }

  @override
  Widget build(BuildContext context) {
    //if (lastuploadid != widget.uploadid) {
    //  loadtags = gettags(widget.uploadid.toString());
    //  lastuploadid = widget.uploadid;
    //}

    return Consumer<PostviewerStatus>(builder: (context, userstatus, child) {
      if (userstatus.currentupload.taglist.isEmpty ||
          userstatus.currentupload.lasttagrequest
              .isBefore(DateTime.now().subtract(const Duration(minutes: 5)))) {
        loadtags = gettags(userstatus.currentupload.uploadid.toString());
      } else {
        taglist = userstatus.currentupload.taglist;
        loadtags = Future.value(true);
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FloatingActionButton.extended(
            heroTag: null,
            onPressed: () {
              if (Provider.of<GlobalStatus>(context, listen: false)
                  .isLoggedin) {
                showDialog(
                    context: context,
                    builder: (context) => NewTagView(callback: callback));
              } else {
                showDialog(
                    context: context,
                    builder: ((context) {
                      return const Login();
                    }));
              }
            },
            hoverColor: Colors.blue,
            backgroundColor: Colors.blue.withAlpha((0.3 * 255).toInt()),
            label: AutoSizeText(
              AppLocalizations.of(context)!.addtag,
              style: const TextStyle(color: Colors.white),
            ),
            icon: Column(
              children: [
                const Icon(Icons.tag, color: Colors.white),
                Text("${taglist.length}",
                    style: const TextStyle(color: Colors.white)),
              ],
            ),
            shape: ShapeBorder.lerp(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                0.5),
          ),
          Expanded(
            child: FutureBuilder(
              future: loadtags,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: taglist.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Tagelement(
                            globuptagid: taglist[index].globuptagid,
                            globaltagid: taglist[index].globaltagid,
                            tagtext: taglist[index].text,
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      );
    });
  }

  Future<bool> gettags(String uploadid) async {
    List<Tag> response = await UploadActions().fetchTags(uploadid);
    debugPrint("Upload $uploadid has ${response.length} tags");

    response.sort((a, b) => b.token.compareTo(a.token));
    if (mounted) {
      Provider.of<PostviewerStatus>(context, listen: false)
          .currentupload
          .taglist = response;
      Provider.of<PostviewerStatus>(context, listen: false)
          .currentupload
          .lasttagrequest = DateTime.now();
    }

    setState(() {
      taglist = response;
    });

    return true;
  }
}

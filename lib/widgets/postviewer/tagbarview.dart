import 'package:auto_size_text/auto_size_text.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/postviewerstatus.dart';
import 'package:fr0gsite/datatypes/tag.dart';
import 'package:fr0gsite/widgets/login/login.dart';
import 'package:fr0gsite/widgets/postviewer/comment/newtagview.dart';
import 'package:fr0gsite/widgets/postviewer/tagelemente.dart';
import 'package:flutter/material.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class TagBarView extends StatefulWidget {
  const TagBarView({super.key});

  @override
  State<TagBarView> createState() => _TagBarViewState();
}

class _TagBarViewState extends State<TagBarView> {
  List<Tag> taglist = [];
  Future loadtags = Future.value(false);

  @override
  Widget build(BuildContext context) {
    return Consumer<PostviewerStatus>(
      builder: (context, userstatus, child) {
        if (userstatus.currentupload.taglist.isEmpty ||
            userstatus.currentupload.lasttagrequest.isBefore(
                DateTime.now().subtract(const Duration(minutes: 5)))) {
          loadtags = gettags(userstatus.currentupload.uploadid.toString());
        } else {
          taglist = userstatus.currentupload.taglist;
          loadtags = Future.value(true);
        }
        return Container(
          color: AppColor.niceblack,
          child: FutureBuilder(
            future: loadtags,
            builder: (context, snapshotmetadata) {
              return Row(children: [
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
                  backgroundColor: AppColor.tagcolor,
                  label: MediaQuery.of(context).size.width > AppConfig.thresholdValueForMobileLayout
                      ? AutoSizeText(
                          AppLocalizations.of(context)!.addtag,
                          style: const TextStyle(color: Colors.white),
                        )
                      : const Icon(Icons.add, color: Colors.white),
                  shape: ShapeBorder.lerp(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      0.5),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: taglist.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Tagelement(
                          globaltagid: taglist[index].globaltagid,
                          globuptagid: taglist[index].globuptagid,
                          tagtext: taglist[index].text,
                        ),
                      );
                    },
                  ),
                ),
              ]);
            },
          ),
        );
      },
    );
  }

  void callback(bool value, String newtag) {
    if (value) {
      debugPrint("New Tag callback with: $newtag");
    }
  }

  Future<bool> gettags(String uploadid) async {
    List<Tag> response = await Chainactions().fetchTags(uploadid);
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

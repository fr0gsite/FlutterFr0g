import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/gridstatus.dart';
import 'package:fr0gsite/datatypes/uploadordertemplate.dart';
import 'package:fr0gsite/serachmodes/searchuseruploads.dart';
import 'package:fr0gsite/widgets/grid/creategrid.dart';
import 'package:fr0gsite/widgets/grid/gridfilderbutton.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserUploadView extends StatefulWidget {
  final String username;
  const UserUploadView({super.key, required this.username});

  @override
  State<UserUploadView> createState() => _UserUploadViewState();
}

class _UserUploadViewState extends State<UserUploadView> {
  Future<bool>? futuregetuploads;
  String lastsearch = "";

  late UploadOrderTemplate uploadorder;

  bool showpicture = true;
  bool showvideo = true;

  @override
  void initState() {
    super.initState();
    uploadorder = SearchUserUploads(widget.username);
    lastsearch = widget.username;
    futuregetuploads = getUploads();
  }

  @override
  Widget build(BuildContext context) {
    if (lastsearch != widget.username) {
      setState(() {
        uploadorder = SearchUserUploads(widget.username);
        futuregetuploads = getUploads();
      });
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GridStatus>(create: (context) => GridStatus()),
      ],
      builder: (context, child) {
        Provider.of<GridStatus>(context, listen: false).setSearch(uploadorder);

        showpicture =
            Provider.of<GridStatus>(context, listen: true).showpicture;
        showvideo = Provider.of<GridStatus>(context, listen: true).showvideo;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridFilterButton(uploadorder)),
            Expanded(
              child: FutureBuilder(
                future: futuregetuploads,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (uploadorder.currentviewuploadlist.isEmpty) {
                      return Column(
                        children: [
                          Center(
                            child: Text(AppLocalizations.of(context)!.nouploadsfound,
                                style: const TextStyle(color: AppColor.nicewhite)),
                          ),
                        ],
                      );
                    }
                    return CreateGrid(
                      uploadlist: uploadorder.currentviewuploadlist,
                      loadmorecallback: loadmorecallback,
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 15,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool> loadmorecallback() async {
    await uploadorder.searchnext();
    setState(() {});
    return true;
  }

  Future<bool> getUploads() async {
    await uploadorder.initsearch();
    return true;
  }
}

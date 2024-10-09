import 'package:fr0gsite/datatypes/gridstatus.dart';
import 'package:fr0gsite/datatypes/uploadordertemplate.dart';
import 'package:fr0gsite/datatypes/useruploads.dart';
import 'package:fr0gsite/serachmodes/searchgroup.dart';
import 'package:fr0gsite/widgets/grid/creategrid.dart';
import 'package:fr0gsite/widgets/grid/gridfilderbutton.dart';
import 'package:fr0gsite/widgets/infoscreens/loadingpleasewaitscreen.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FollowCubeList extends StatefulWidget {
  const FollowCubeList({super.key, required this.userlist});
  final List<String> userlist;

  @override
  State<FollowCubeList> createState() => _FollowCubeListState();
}

class _FollowCubeListState extends State<FollowCubeList> {
  late UploadOrderTemplate uploadorder;
  late Future<bool> futureuploadorder;
  List<UserUploads> uploadList = [];

  // Need for the filter buttons
  bool showpicture = true;
  bool showvideo = true;

  @override
  void initState() {
    super.initState();
    for (String username in widget.userlist) {
      uploadList.add(UserUploads(username: username, uploads: []));
    }
    uploadorder = SearchGroup(uploadList);
    futureuploadorder = inituploadorder();
  }

  @override
  Widget build(BuildContext context) {
    if (uploadList.length != widget.userlist.length) {
      uploadList = [];
      for (String username in widget.userlist) {
        uploadList.add(UserUploads(username: username, uploads: []));
      }
      uploadorder = SearchGroup(uploadList);
      futureuploadorder = inituploadorder();
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GridStatus>(create: (context) => GridStatus()),
      ],
      builder: (context, child) {
        Provider.of<GridStatus>(context, listen: false).setSearch(uploadorder);

        // Need for the filter buttons
        showpicture =
            Provider.of<GridStatus>(context, listen: true).showpicture;
        showvideo = Provider.of<GridStatus>(context, listen: true).showvideo;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridFilterButton(uploadorder)),
              Expanded(
                child: FutureBuilder(
                  future: futureuploadorder,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: CreateGrid(
                            uploadlist: uploadorder.currentviewuploadlist,
                            loadmorecallback: loadmorecallback,
                          ));
                    } else {
                      return const Loadingpleasewaitscreen();
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> loadmorecallback() async {
    debugPrint("loadmorecallback");
    List<Upload> temp = await uploadorder.searchnext();
    if (temp.isEmpty) {
      debugPrint("loadmorecallback: empty");
      return false;
    } else {
      debugPrint("loadmorecallback: have elements");
      setState(() {});
      return true;
    }
  }

  Future<bool> inituploadorder() async {
    await uploadorder.initsearch();
    setState(() {});
    return true;
  }
}

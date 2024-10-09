import 'package:fr0gsite/datatypes/gridstatus.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:fr0gsite/datatypes/uploadordertemplate.dart';
import 'package:fr0gsite/serachmodes/searchtag.dart';
import 'package:fr0gsite/widgets/grid/creategrid.dart';
import 'package:fr0gsite/widgets/grid/gridfilderbutton.dart';
import 'package:fr0gsite/widgets/infoscreens/loadingpleasewaitscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GlobalTagCubeList extends StatefulWidget {
  const GlobalTagCubeList({super.key, required this.globaltagid});
  final String globaltagid;

  @override
  State<GlobalTagCubeList> createState() => _GlobalTagCubeListState();
}

class _GlobalTagCubeListState extends State<GlobalTagCubeList> {
  late UploadOrderTemplate uploadorder;
  late Future<bool> futureuploadorder;

  // Need for the filter buttons
  bool showpicture = true;
  bool showvideo = true;

  @override
  void initState() {
    super.initState();
    uploadorder = SearchTag(widget.globaltagid.toString());
    futureuploadorder = inituploadorder();
  }

  @override
  Widget build(BuildContext context) {
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

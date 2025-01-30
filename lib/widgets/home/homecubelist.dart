import 'package:fr0gsite/datatypes/gridstatus.dart';
import 'package:fr0gsite/datatypes/uploadordertemplate.dart';
import 'package:fr0gsite/serachmodes/searchpopularuploads.dart';
import 'package:fr0gsite/serachmodes/serachmixeduploads.dart';
import 'package:fr0gsite/serachmodes/serachtrendinguploads.dart';
import 'package:fr0gsite/widgets/grid/creategrid.dart';
import 'package:fr0gsite/widgets/grid/gridfilderbutton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fr0gsite/serachmodes/searchnew.dart';

class HomeCubeList extends StatefulWidget {
  final int currenttabindex;
  const HomeCubeList({super.key, required this.currenttabindex});

  @override
  State<HomeCubeList> createState() => _HomeCubeListState();
}

class _HomeCubeListState extends State<HomeCubeList> {
  late UploadOrderTemplate uploadorder;
  Future? getuploads;
  int? lasttabindex;

  // Need for the filter buttons
  bool showpicture = true;
  bool showvideo = true;

  @override
  void initState() {
    super.initState();
    getuploads = getdata();
    lasttabindex = widget.currenttabindex;
  }

  Future<bool> getdata() async {
    if (widget.currenttabindex == 0) {
      uploadorder = SearchMixedUploads();
    }
    if (widget.currenttabindex == 1) {
      uploadorder = SearchPopularUploads();
    }
    if (widget.currenttabindex == 2) {
      uploadorder = SearchTrendingUploads();
    }
    if (widget.currenttabindex == 3) {
      uploadorder = SearchNew();
    }
    await uploadorder.initsearch();

    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (lasttabindex != widget.currenttabindex) {
      getuploads = getdata();
      lasttabindex = widget.currenttabindex;
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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridFilterButton(uploadorder)),
            Expanded(
              child: FutureBuilder(
                  future: getuploads,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return CreateGrid(
                        uploadlist: uploadorder.currentviewuploadlist,
                        loadmorecallback: loadmorecallback,
                      );
                    } else {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 15,
                      ));
                    }
                  }),
            ),
          ],
        );
      },
    );
  }

  Future<bool> loadmorecallback() async {
    debugPrint("loadmorecallback");
    await uploadorder.searchnext();
    setState(() {});
    return true;
  }
}

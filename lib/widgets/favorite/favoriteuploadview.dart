import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/gridstatus.dart';
import 'package:fr0gsite/datatypes/uploadordertemplate.dart';
import 'package:fr0gsite/serachmodes/searchuserfavorites.dart';
import 'package:fr0gsite/widgets/grid/creategrid.dart';
import 'package:fr0gsite/widgets/grid/gridfilderbutton.dart';
import 'package:fr0gsite/widgets/infoscreens/pleaselogin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteUploadView extends StatefulWidget {
  const FavoriteUploadView({super.key});

  @override
  State<FavoriteUploadView> createState() => _FavoriteUploadViewState();
}

class _FavoriteUploadViewState extends State<FavoriteUploadView> {
  late UploadOrderTemplate uploadorder;
  Future? getuploads;
  int? lasttabindex;

  // Need for the filter buttons
  bool showpicture = true;
  bool showvideo = true;

  @override
  void initState() {
    super.initState();
    bool isLoggedin = Provider.of<GlobalStatus>(context, listen: false).isLoggedin;
    if (isLoggedin) {
      String username = Provider.of<GlobalStatus>(context, listen: false).username;
      uploadorder = SearchUserFavorites(username);
      getuploads = uploadorder.initsearch();
    }
  }

  @override
  Widget build(BuildContext context) { 
    return Consumer<GlobalStatus>(builder: (context, userstatus, child) {
      if (userstatus.isLoggedin) {
        return MultiProvider(
      providers: [
        ChangeNotifierProvider<GridStatus>(create: (context) => GridStatus()),
      ],
      builder: (context, child) {
      Provider.of<GridStatus>(context, listen: false).setSearch(uploadorder);

        // Need for the filter buttons
        showpicture = Provider.of<GridStatus>(context, listen: true).showpicture;
        showvideo   = Provider.of<GridStatus>(context, listen: true).showvideo;

        return SizedBox(
          height: 1000,
          child: Container(
            color: AppColor.nicegrey,
            child: Column(
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
            ),
          ),
        );
      },
    );
      } else {
        return const Stack(
          children: [
            Pleaselogin(),
          ],
        );
      }
    });
  }

  Future<bool> loadmorecallback() async {
    debugPrint("loadmorecallback");
    await uploadorder.searchnext();
    setState(() {});
    return true;
  }

}

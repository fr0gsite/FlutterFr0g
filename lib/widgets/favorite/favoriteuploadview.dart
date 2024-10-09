import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/favoriteupload.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:fr0gsite/datatypes/uploadordertemplate.dart';
import 'package:fr0gsite/widgets/cube/cube.dart';
import 'package:fr0gsite/widgets/infoscreens/pleaselogin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteUploadView extends StatefulWidget {
  const FavoriteUploadView({super.key});

  @override
  State<FavoriteUploadView> createState() => _FavoriteUploadViewState();
}

class _FavoriteUploadViewState extends State<FavoriteUploadView> {
  List<FavoriteUpload> favoriteuploads = [];
  List<Upload> uploadList = [];
  List<Widget> items = [];
  final ScrollController _scrollController = ScrollController();
  Future? getfavorites;
  late UploadOrderTemplate uploadOrder;

  @override
  void initState() {
    super.initState();
    if (Provider.of<GlobalStatus>(context, listen: false).isLoggedin) {
      debugPrint("Logged in. Getting favorites");
      getfavorites = getfavoritesofuser();
    } else {
      debugPrint("Not logged in. No favorites to show");
      getfavorites = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalStatus>(builder: (context, userstatus, child) {
      if (userstatus.isLoggedin) {
        return showfavorites();
      } else {
        return const Stack(
          children: [
            Pleaselogin(),
          ],
        );
      }
    });
  }

  Widget showfavorites() {
    return FutureBuilder(
      future: getfavorites,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return getgridview();
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  GridView getgridview() {
    var corssAxisCount = resize();
    var grid = GridView.builder(
      itemCount: items.length,
      scrollDirection: Axis.vertical,
      controller: _scrollController,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: corssAxisCount),
      itemBuilder: (context, index) {
        return items[index];
      },
    );
    return grid;
  }

  int resize() {
    return (MediaQuery.of(context).size.width / 200).floor();
  }

  Future<bool> getfavoritesofuser() async {
    var response = await Provider.of<GlobalStatus>(context, listen: false)
        .getfavoriteuploads();
    for (var item in response) {
      favoriteuploads.add(item);
    }
    List<Future> futures = [];
    for (int i = 0; i < favoriteuploads.length; i++) {
      String uploadid = favoriteuploads.elementAt(i).uploadid.toString();
      var future = Chainactions().getupload(uploadid).then((value) {
        uploadList.add(value);
      });
      futures.add(future);
    }
    await Future.wait(futures);
    debugPrint("Received all Upload Metadata");

    for (var index = 0; index < uploadList.length; index++) {
      items.add(
        Cube(
            informationaboutupload: uploadList.elementAt(index).toJson(),
            mode: "userfavorite"),
      );
    }

    return true;
  }
}

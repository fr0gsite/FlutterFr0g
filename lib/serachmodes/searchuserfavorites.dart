import 'package:flutter/material.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/favoriteupload.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:fr0gsite/datatypes/uploadordertemplate.dart';

class SearchUserFavorites extends UploadOrderTemplate {
  Chainactions chainactions = Chainactions();
  late String username;
  int lastlowerid = 0;

  SearchUserFavorites(this.username);


  @override
  Future<List<Upload>> initsearch() async{
    //TODO: Use cached from GlobalStatus
     try {
      List<FavoriteUpload> favoriteuploads = await chainactions.getfavoriteuploadsofuser(username);
      List<Upload> uploadList = [];
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


      adduploadlist(uploadList);
      sortcurrentview();
      removeduplicates();

      lastlowerid = completeuploadlist.last.uploadid;
      return uploadList;

    } catch (e) {
        debugPrint("initsearch error: $e");
      return [];
    }
  }

  @override
  Future<List<Upload>> searchnext() {
    // TODO: implement searchnext
    debugPrint("Search next");
    return Future.value([]);
  }

  @override
  void sortcurrentview() {
    // Order by time
    completeuploadlist.sort((a, b) => b.creationtime.compareTo(a.creationtime));
  }
}

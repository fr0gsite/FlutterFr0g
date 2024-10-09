import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:fr0gsite/datatypes/uploadordertemplate.dart';
import 'package:fr0gsite/datatypes/useruploads.dart';
import 'package:flutter/material.dart';

class SearchGroup extends UploadOrderTemplate {
  List<UserUploads> userlist = [];
  SearchGroup(this.userlist);

  @override
  Future<List<Upload>> initsearch() async {
    try {
      List<Future> futures = [];
      List<Upload> tempuploadlist = [];
      for (UserUploads user in userlist) {
        futures.add(Chainactions().getuploadsfromuser(user.username, 60));
      }
      await Future.wait(futures).then((value) {
        for (var item in value) {
          tempuploadlist.addAll(item);
        }
      });
      adduploadlist(tempuploadlist);
      sortcurrentview();
      return tempuploadlist;
    } catch (e) {
      debugPrint("initsearch error: $e");
      return [];
    }
  }

  @override
  Future<List<Upload>> searchnext() {
    debugPrint("SearchGroup searchnext");
    return Future.value([]);
  }

  @override
  void sortcurrentview() {
    debugPrint("SearchGroup sortcurrentview");
    currentviewuploadlist.sort((a, b) => b.uploadid.compareTo(a.uploadid));
  }
}

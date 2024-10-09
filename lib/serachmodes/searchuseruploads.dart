import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:fr0gsite/datatypes/uploadordertemplate.dart';
import 'package:flutter/foundation.dart';

class SearchUserUploads extends UploadOrderTemplate {
  Chainactions chainactions = Chainactions();
  late String username;
  int lastlowerid = 0;

  SearchUserUploads(this.username);

  @override
  Future<List<Upload>> initsearch() async {
    try {
      List<Upload> response =
          await chainactions.getuploadsfromuser(username, 60);
      adduploadlist(response);
      sortcurrentview();
      removeduplicates();
      lastlowerid = completeuploadlist.last.uploadid;
      return response;
    } catch (e) {
      debugPrint("initsearch error: $e");
      return [];
    }
  }

  @override
  Future<List<Upload>> searchnext() async {
    try {
      List<Upload> response = await chainactions.getuploadsfromuserupperthan(
          username, 60, lastlowerid.toString());
      adduploadlist(response);
      sortcurrentview();
      removeduplicates();
      lastlowerid = completeuploadlist.last.uploadid;
      return response;
    } catch (e) {
      debugPrint("searchnext error: $e");
      return [];
    }
  }

  @override
  void sortcurrentview() {
    completeuploadlist.sort((a, b) => b.uploadid.compareTo(a.uploadid));
    currentviewuploadlist.sort((a, b) => b.uploadid.compareTo(a.uploadid));
  }
}

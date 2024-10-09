import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:fr0gsite/datatypes/uploadordertemplate.dart';
import 'package:flutter/foundation.dart';

class SearchTrendingUploads extends UploadOrderTemplate {
  Chainactions chainactions = Chainactions();

  int lasttrendid = 0;

  @override
  Future<List<Upload>> initsearch() async {
    try {
      List<Upload> response =
          await chainactions.gettrendinguploads().then((value) {
        lasttrendid = value.last.token;
        return value;
      });
      adduploadlist(response);
      return response;
    } catch (e) {
      debugPrint("initsearch error: $e");
      return [];
    }
  }

  @override
  Future<List<Upload>> searchnext() async {
    if (dosearchnext(lasttrendid.toString())) {
      try {
        List<Upload> response = await chainactions
            .gettrendinguploadsupperthan(lasttrendid.toString());
        //remove duplicates
        adduploadlist(response);
        removeduplicates();
        return response;
      } catch (e) {
        debugPrint("searchnext error: $e");
      }
    }
    return [];
  }

  @override
  void sortcurrentview() {
    // Sort by token
    currentviewuploadlist.sort((a, b) => b.token.compareTo(a.token));
  }
}

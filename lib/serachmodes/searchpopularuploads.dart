import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:fr0gsite/datatypes/uploadordertemplate.dart';
import 'package:flutter/foundation.dart';

class SearchPopularUploads extends UploadOrderTemplate {
  Chainactions chainactions = Chainactions();

  int lastpopularid = 0;

  @override
  Future<List<Upload>> initsearch() async {
    try {
      List<Upload> response =
          await chainactions.getpopularuploads().then((value) {
        lastpopularid = value.last.popularid;
        return value;
      });
      adduploadlist(response);
      removeduplicates();
      return response;
    } catch (e) {
      debugPrint("initsearch error: $e");
      return [];
    }
  }

  @override
  Future<List<Upload>> searchnext() async {
    if (dosearchnext(lastpopularid.toString())) {
      try {
        List<Upload> response = await chainactions
            .getpopularuploadsupperthan(lastpopularid.toString());
        adduploadlist(response);
        return response;
      } catch (e) {
        debugPrint("searchnext error: $e");
      }
    }
    debugPrint("skipping searchnext");
    return [];
  }

  @override
  void sortcurrentview() {
    // Sort by popularid
    currentviewuploadlist.sort((a, b) => b.popularid.compareTo(a.popularid));
  }
}

import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:fr0gsite/datatypes/uploadordertemplate.dart';
import 'package:flutter/material.dart';

class SearchTag extends UploadOrderTemplate {
  Chainactions chainactions = Chainactions();
  late String globaluploadid;
  int lastlowerid = 0;

  SearchTag(this.globaluploadid);

  @override
  Future<List<Upload>> initsearch() async {
    try {
      List<Upload> response =
          await chainactions.getuploadsforglobaltag(globaluploadid, 60);
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
    if (dosearchnext(lastlowerid.toString())) {
      try {
        List<Upload> response =
            await chainactions.getuploadsforglobaltagupperthan(
                globaluploadid, 60, lastlowerid.toString());
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
    debugPrint("skipping searchnext");
    return [];
  }

  @override
  void sortcurrentview() {
    // Sort by uploadid
    currentviewuploadlist.sort((a, b) => b.uploadid.compareTo(a.uploadid));
    completeuploadlist.sort((a, b) => b.uploadid.compareTo(a.uploadid));
  }
}

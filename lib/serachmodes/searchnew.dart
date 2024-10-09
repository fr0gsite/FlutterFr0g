import 'dart:async';

import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:fr0gsite/datatypes/uploadordertemplate.dart';
import 'package:flutter/material.dart';

class SearchNew extends UploadOrderTemplate {
  Chainactions chainactions = Chainactions();
  int lastnewid = 0;

  @override
  Future<List<Upload>> initsearch() async {
    debugPrint("SearchNew initsearch");
    try {
      List<Upload> response = await chainactions.getnewuploads().then((value) {
        lastnewid = value.last.uploadid;
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
    if (dosearchnext(lastnewid.toString())) {
      try {
        List<Upload> response =
            await chainactions.getnewuploadsupperthan(lastnewid.toString());
        lastnewid = response.last.uploadid;
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
    // Sort by uploadid
    currentviewuploadlist.sort((a, b) => b.uploadid.compareTo(a.uploadid));
  }
}

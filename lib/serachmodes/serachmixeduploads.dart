import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:fr0gsite/datatypes/uploadordertemplate.dart';
import 'package:flutter/foundation.dart';

class SearchMixedUploads extends UploadOrderTemplate {
  Chainactions chainactions = Chainactions();

  int lasttrendid = 0;
  int lastpopularid = 0;
  int lastnewid = 0;

  @override
  Future<List<Upload>> initsearch() async {
    try {
      List<Future> futures = [];

      List<Upload> trendinguploads = [];
      List<Upload> popularuploads = [];
      List<Upload> newuploads = [];

      futures.add(chainactions.gettrendinguploads());
      futures.add(chainactions.getpopularuploads());
      futures.add(chainactions.getnewuploads());
      await Future.wait(futures).then((value) {
        trendinguploads = value[0];
        popularuploads = value[1];
        newuploads = value[2];
      });

      lasttrendid = trendinguploads.last.token;
      lastpopularid = popularuploads.last.popularid;
      lastnewid = newuploads.last.uploadid;
      debugPrint(
          "lasttrendid: $lasttrendid lastpopularid: $lastpopularid lastnewid: $lastnewid");

      List<Upload> uploads = [];
      uploads.addAll(trendinguploads);
      uploads.addAll(popularuploads);
      uploads.addAll(newuploads);
      uploads.shuffle();
      adduploadlist(uploads);

      return uploads;
    } catch (e) {
      debugPrint("initsearch error: $e");
      return [];
    }
  }

  @override
  Future<List<Upload>> searchnext() async {
    try {
      List<Future> futures = [];

      List<Upload> trendinguploads = [];
      List<Upload> popularuploads = [];
      List<Upload> newuploads = [];

      bool searchpopular = lastpopularid > 1;

      futures.add(
          chainactions.gettrendinguploadsupperthan(lasttrendid.toString()));
      futures.add(chainactions.getnewuploadsupperthan(lastnewid.toString()));
      if (searchpopular) {
        futures.add(
            chainactions.getpopularuploadsupperthan(lastpopularid.toString()));
      }

      await Future.wait(futures).then((value) {
        trendinguploads = value[0];
        newuploads = value[1];
        if (searchpopular) {
          popularuploads = value[2];
        }
      });

      lasttrendid = trendinguploads.last.token;
      lastnewid = newuploads.last.uploadid;
      if (searchpopular) {
        lastpopularid = popularuploads.last.popularid;
      }
      debugPrint(
          "lasttrendid: $lasttrendid lastpopularid: $lastpopularid lastnewid: $lastnewid");

      List<Upload> uploads = [];
      uploads.addAll(trendinguploads);
      uploads.addAll(popularuploads);
      uploads.addAll(newuploads);

      uploads.shuffle();
      adduploadlist(uploads);
      removeduplicates();
      return uploads;
    } catch (e) {
      debugPrint("searchnext error: $e");
    }

    return [];
  }

  @override
  void sortcurrentview() {
    // Sort by uploadid and shuffle
    currentviewuploadlist.sort((a, b) => b.uploadid.compareTo(a.uploadid));
    currentviewuploadlist.shuffle();
  }
}

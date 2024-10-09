import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:flutter/foundation.dart';

abstract class UploadOrderTemplate {
  List<Upload> completeuploadlist = [];
  List<Upload> currentviewuploadlist = [];
  int currentuploadid = 0;
  int lastsearcheduploadid = 0;
  DateTime lastrequest = DateTime.now();

  Future<List<Upload>> initsearch();
  Future<List<Upload>> searchnext();
  void sortcurrentview();

  bool showpicture = true;
  bool showvideo = true;

  void addupload(Upload upload) {
    completeuploadlist.add(upload);
    if (showpicture && showvideo) {
      currentviewuploadlist.add(upload);
    } else {
      if (showpicture) {
        if (AppConfig.imagefiletypes.contains(upload.uploadipfshashfiletyp)) {
          currentviewuploadlist.add(upload);
        }
      }
      if (showvideo) {
        if (AppConfig.videofiletypes.contains(upload.uploadipfshashfiletyp)) {
          currentviewuploadlist.add(upload);
        }
      }
    }
  }

  void adduploadlist(List<Upload> uploadlist) {
    completeuploadlist.addAll(uploadlist);
    if (showpicture && showvideo) {
      currentviewuploadlist.addAll(uploadlist);
    } else {
      if (showpicture) {
        List<Upload> pictureuploads = uploadlist
            .where((element) => AppConfig.imagefiletypes
                .contains(element.uploadipfshashfiletyp))
            .toList();
        currentviewuploadlist.addAll(pictureuploads);
      }
      if (showvideo) {
        List<Upload> videouploads = uploadlist
            .where((element) => AppConfig.videofiletypes
                .contains(element.uploadipfshashfiletyp))
            .toList();
        currentviewuploadlist.addAll(videouploads);
      }
    }
    removeduplicates();
  }

  bool dosearchnext(String id) {
    if (id == lastsearcheduploadid.toString()) {
      if (DateTime.now().difference(lastrequest).inSeconds < 5) {
        return false;
      }
      lastrequest = DateTime.now();
      return true;
    } else {
      lastsearcheduploadid = int.parse(id);
      lastrequest = DateTime.now();
      return true;
    }
  }

  void setcurrentuploadid(int id) {
    currentuploadid = id;
  }

  int getcurrentuploadid() {
    return currentuploadid;
  }

  showpictures(bool value) {
    showpicture = value;
    if (value) {
      debugPrint("showpictures");
      List<Upload> addtouploadlist = [];
      List<Upload> pictureuploads = completeuploadlist
          .where((element) =>
              AppConfig.imagefiletypes.contains(element.uploadipfshashfiletyp))
          .toList();
      for (var i = 0; i < pictureuploads.length; i++) {
        bool found = false;
        for (var j = 0; j < currentviewuploadlist.length; j++) {
          if (pictureuploads[i].uploadid == currentviewuploadlist[j].uploadid) {
            found = true;
            break;
          }
        }
        if (!found) {
          addtouploadlist.add(pictureuploads[i]);
        }
      }
      currentviewuploadlist.addAll(addtouploadlist);
      sortcurrentview();
      removeduplicates();
    } else {
      debugPrint("dont showpictures");
      currentviewuploadlist.removeWhere((element) =>
          AppConfig.imagefiletypes.contains(element.uploadipfshashfiletyp));
    }
  }

  showvideos(bool value) {
    showvideo = value;
    if (value) {
      debugPrint("showvideos");
      List<Upload> addtouploadlist = [];
      List<Upload> videouploads = completeuploadlist
          .where((element) =>
              AppConfig.videofiletypes.contains(element.uploadipfshashfiletyp))
          .toList();
      for (var i = 0; i < videouploads.length; i++) {
        bool found = false;
        for (var j = 0; j < currentviewuploadlist.length; j++) {
          if (videouploads[i].uploadid == currentviewuploadlist[j].uploadid) {
            found = true;
            break;
          }
        }
        if (!found) {
          addtouploadlist.add(videouploads[i]);
        }
      }
      currentviewuploadlist.addAll(addtouploadlist);
      sortcurrentview();
      removeduplicates();
    } else {
      debugPrint("dont showvideos");
      currentviewuploadlist.removeWhere((element) =>
          AppConfig.videofiletypes.contains(element.uploadipfshashfiletyp));
    }
  }

  removeduplicates() {
    List<int> uploadids = [];
    currentviewuploadlist.removeWhere((element) {
      if (uploadids.contains(element.uploadid)) {
        return true;
      } else {
        uploadids.add(element.uploadid);
        return false;
      }
    });
  }
}

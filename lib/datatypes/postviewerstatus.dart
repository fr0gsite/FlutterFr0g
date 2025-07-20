import 'package:fr0gsite/datatypes/comment.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class PostviewerStatus extends ChangeNotifier {
  Upload currentupload = Upload.demo();
  List<Upload> uploadlist = [];
  bool showpostviewerfirsttime = true;
  bool showcomments = true;
  double soundvolume = 0.0;
  List<Comment> commentlist = [];
  bool updatecommentbar = false;
  
  bool _isPlaying = true;
  bool get isPlaying => _isPlaying;
  void pause() {
    _isPlaying = false;
    notifyListeners();
  } 
  void resume() {
    _isPlaying = true;
    //notifyListeners();
  }

  void showedpostviewerfirsttime() {
    showpostviewerfirsttime = false;
    //notifyListeners();
  }

  void setsoundvolume(double volume) {
    soundvolume = volume;
    //notifyListeners();
  }

  void setcurrentupload(Upload upload) {
    currentupload =
        uploadlist.firstWhere((element) => element.uploadid == upload.uploadid);
    if (WidgetsBinding.instance.schedulerPhase == SchedulerPhase.persistentCallbacks ||
        WidgetsBinding.instance.schedulerPhase == SchedulerPhase.transientCallbacks) {
      WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
    } else {
      notifyListeners();
    }
  }

  Upload getcurrentupload() {
    return currentupload;
  }

  void setdata(Uint8List data, int uploadid) {
    uploadlist
        .firstWhere((element) => element.uploadid == uploadid)
        .setdata(data);

    notifyListeners();
  }

  void addupload(Upload upload) {
    uploadlist.add(upload);
    removeDuplicates();
    sortUploadList();
    notifyListeners();
  }

  void adduploads(List<Upload> uploads) {
    uploadlist.addAll(uploads);
    //removeDuplicates();
    //sortUploadList();
    //notifyListeners();
  }

  void clearuploadlist() {
    uploadlist.clear();
  }

  void sortUploadList() {
    //Sorted id from low to high
    uploadlist.sort((a, b) => a.uploadid.compareTo(b.uploadid));
    //delete duplicates if there are any
  }

  void removeDuplicates() {
    final ids = <int>{};
    List<Upload> temp = [];
    for (var upload in uploadlist) {
      if (!ids.contains(upload.uploadid)) {
        ids.add(upload.uploadid);
        temp.add(upload);
      }
    }
    uploadlist = temp;
  }

  void doupdatecommentlist() {
    updatecommentbar = true;
    notifyListeners();
    updatecommentbar = false;
  }

  void setcommentlist(List<Comment> commentlist) {
    this.commentlist = commentlist;
  }

  void updatecommentlist(List<Comment> commentlist) {
    this.commentlist = commentlist;
    notifyListeners();
  }

  List<Comment> getcommentlist() {
    return commentlist;
  }


}

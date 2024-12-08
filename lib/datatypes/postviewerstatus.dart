import 'dart:math';

import 'package:fr0gsite/datatypes/comment.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:flutter/foundation.dart';

class PostviewerStatus extends ChangeNotifier {
  Upload currentupload = Upload.demo();
  List<Upload> uploadlist = [];
  bool showpostviewerfirsttime = true;
  bool showcomments = true;
  double soundvolume = 0.0;
  List<Comment> commentlist = [];
  bool updatecommentbar = false;
  bool commentFold = true;
  bool isLoading = true;

  bool _isPlaying = true;

  bool get isPlaying => _isPlaying;

  void pause() {
    _isPlaying = false;
    notifyListeners();
  }

  void resume() {
    _isPlaying = true;
    notifyListeners();
  }

  void showedpostviewerfirsttime() {
    showpostviewerfirsttime = false;
    notifyListeners();
  }

  void setsoundvolume(double volume) {
    soundvolume = volume;
    //notifyListeners();
  }

  void setcurrentupload(Upload upload) {
    currentupload =
        uploadlist.firstWhere((element) => element.uploadid == upload.uploadid);
    notifyListeners();
  }

  Upload getcurrentupload() {
    return currentupload;
  }

  List<Upload> fetchnextuploads(int uploadid) {
    List<Upload> tofetchuploads = [];
    for (var i = 0; i < uploadlist.length; i++) {
      if (uploadlist[i].uploadid == uploadid) {
        if (i + 1 < uploadlist.length) {
          tofetchuploads.add(uploadlist[i + 1]);
        }
        if (i + 2 < uploadlist.length) {
          tofetchuploads.add(uploadlist[i + 2]);
        }
        if (i + 3 < uploadlist.length) {
          tofetchuploads.add(uploadlist[i + 3]);
        }
        break;
      }
    }
    return tofetchuploads;
  }

  void setdata(Uint8List data, int uploadid) {
    uploadlist
        .firstWhere((element) => element.uploadid == uploadid)
        .setdata(data);

    // uploadlist
    //     .firstWhere((element) => element.uploadid == uploadid)
    //     .setVideoControllerData(data);

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

  removeDuplicates() {
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

  void addcomment(int parentcommentId, String comment) {
    commentlist.add(Comment(
        commentId: Random().nextInt(1000000),
        parentCommentId: parentcommentId,
        author: "test",
        commentText: comment,
        creationTime: DateTime.now(),
        down: 0,
        up: 0,
        language: "de",
        token: 0));
    notifyListeners();
  }

  void toggleCommentFold() {
    commentFold = !commentFold;
    notifyListeners();
  }
}

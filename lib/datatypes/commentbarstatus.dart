import 'package:flutter/material.dart';

class CommentBarStatus extends ChangeNotifier {
  bool updatecommentbar = false;
  bool commentFold = true;

  void toggleCommentFold() {
    debugPrint("toggleCommentFold");
    updatecommentbar = !updatecommentbar;
    notifyListeners();
  }

  void setcommentfold(bool value) {
    debugPrint("setcommentfold");
    commentFold = value;
    notifyListeners();
  }
}

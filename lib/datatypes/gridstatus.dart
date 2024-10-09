import 'package:fr0gsite/datatypes/uploadordertemplate.dart';
import 'package:flutter/foundation.dart';

class GridStatus extends ChangeNotifier {
  bool showpicture = true;
  bool showvideo = true;
  bool showinfowithouthover = true;

  late UploadOrderTemplate search;

  void setshowpicture(bool value) {
    showpicture = value;
    notifyListeners();
  }

  void togglepicture() {
    showpicture = !showpicture;
    debugPrint("GridStatus: togglepicture: $showpicture");
    notifyListeners();
  }

  void setshowvideo(bool value) {
    showvideo = value;
    notifyListeners();
  }

  void togglevideo() {
    showvideo = !showvideo;
    debugPrint("GridStatus: togglevideo: $showvideo");
    notifyListeners();
  }

  void setshowinfowithouthover(bool value) {
    showinfowithouthover = value;
    notifyListeners();
  }

  void toggleinfowithouthover() {
    showinfowithouthover = !showinfowithouthover;
    debugPrint("GridStatus: toggleinfowithouthover: $showinfowithouthover");
    notifyListeners();
  }

  void setSearch(UploadOrderTemplate value) {
    search = value;
  }

  UploadOrderTemplate getSerach() {
    return search;
  }
}

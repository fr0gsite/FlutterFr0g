import 'package:flutter/material.dart';

class FollowStatus extends ChangeNotifier {
  bool expandedfollowlist = false;
  bool pressanimation = true;
  List<Widget> listitems = [];

  void toggleexpandedfollowlist() {
    expandedfollowlist = !expandedfollowlist;
    notifyListeners();
  }

  void switchoffpressanimation() {
    pressanimation = false;
    notifyListeners();
  }

  void addlistitem(Widget item) {
    listitems.add(item);
    notifyListeners();
  }

  bool deleteitem(Widget item) {
    if (listitems.contains(item)) {
      listitems.remove(item);
      notifyListeners();
      return true;
    }
    return false;
  }
}

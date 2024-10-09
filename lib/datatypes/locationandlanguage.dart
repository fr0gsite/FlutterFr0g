import 'package:fr0gsite/l10n/l10n.dart';
import 'package:flutter/material.dart';

class LocationandLanguage with ChangeNotifier {
  Locale? _locale;
  Locale? get locale => _locale;
  void setLocale(Locale loc) {
    if (!L10n.all.contains(loc)) return;
    _locale = loc;
    notifyListeners();
  }

  void clearLocale() {
    _locale = null;
    notifyListeners();
  }
}

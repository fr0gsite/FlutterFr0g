import 'package:flutter/material.dart';

class ReportStatus extends ChangeNotifier {
  int currentStep = 0;
  int selectedprovider = -1;
  int contentid = 0;

  int reporttype = 0; // type of the report, 1 = upload, 2 = comment, 3 = tag
  int selectedrule = -1;
  
  String reporttext = "";
  bool initmessagegenerated = false;
  String selectedusername = "";

  ReportStatus(this.reporttype, this.contentid);

  void stepreached(int index) {
    if (currentStep == 0) {
      if (selectedrule != -1) {
        currentStep = index;
        notifyListeners();
      }
    } else if (currentStep == 1) {
      if (selectedprovider != -1) {
        currentStep = index;
        notifyListeners();
      }
    } else if (currentStep == 2) {}
  }

  void previousStep() {
    if (currentStep > 0) {
      currentStep--;
      notifyListeners();
    }
  }

  void nextStep() {
    if (currentStep < 3) {
      if (currentStep == 0) {
        if (selectedrule != -1) {
          currentStep++;
          notifyListeners();
        }
      } else if (currentStep == 1) {
        if (selectedprovider != -1) {
          currentStep++;
          notifyListeners();
        }
      }
    }
  }

  void setRule(int index) {
    selectedrule = index;
    initmessagegenerated = false;
    notifyListeners();
  }

  void setProvider(int index) {
    selectedprovider = index;
    initmessagegenerated = false;
    notifyListeners();
  }
}

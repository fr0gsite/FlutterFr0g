import 'package:fr0gsite/datatypes/rule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReportStatus extends ChangeNotifier {
  int currentStep = 0;
  int selectedrule = -1;
  int selectedprovider = -1;
  List<Rule> rules = [];

  String reporttext = "";
  bool initmessagegenerated = false;

  String uploadid = "";
  String selectedusername = "";

  void setrules(List<Rule> rules) {
    this.rules = rules;
    notifyListeners();
  }

  List<Rule> getrules(context) {
    if (rules.isEmpty) {
      rules.add(Rule(1, AppLocalizations.of(context)!.rule1,
          AppLocalizations.of(context)!.permanentexclusion));
      rules.add(Rule(2, AppLocalizations.of(context)!.rule2,
          AppLocalizations.of(context)!.permanentexclusion));
      rules.add(Rule(3, AppLocalizations.of(context)!.rule3,
          AppLocalizations.of(context)!.permanentexclusion));
      rules.add(Rule(4, AppLocalizations.of(context)!.rule4,
          AppLocalizations.of(context)!.permanentexclusion));
      rules.add(Rule(5, AppLocalizations.of(context)!.rule5,
          AppLocalizations.of(context)!.sanctionandban));
      rules.add(Rule(6, AppLocalizations.of(context)!.rule6,
          AppLocalizations.of(context)!.sanctionandban));
      rules.add(Rule(7, AppLocalizations.of(context)!.rule7,
          AppLocalizations.of(context)!.sanctionandban));
      rules.add(Rule(8, AppLocalizations.of(context)!.rule8,
          AppLocalizations.of(context)!.sanctionandban));
      rules.add(Rule(9, AppLocalizations.of(context)!.rule9,
          AppLocalizations.of(context)!.sanctionandban));
      rules.add(Rule(10, AppLocalizations.of(context)!.rule10,
          AppLocalizations.of(context)!.sanctionandban));
      rules.add(Rule(11, AppLocalizations.of(context)!.rule11,
          AppLocalizations.of(context)!.sanctionandban));
    }
    return rules;
  }

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

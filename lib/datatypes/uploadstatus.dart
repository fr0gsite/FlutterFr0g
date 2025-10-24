import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/globalnotifications.dart';
import 'package:fr0gsite/widgets/infoscreens/successupload.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';

class Uploadstatus extends ChangeNotifier {
  int _currentStep = 0;

  bool acceptedfirst = false;
  bool acceptedsecond = false;
  bool selectedprovider = false;

  int get currentStep => _currentStep;

  //Uploadinformatoin
  String selecteduploadfiletype = "";
  String selectedthumbfiletype = "";
  String selectedlanguage = "";
  ContentFlag selectedflag = ContentFlag.none;

  TextEditingController textfieldipfshash = TextEditingController();
  TextEditingController textfieldipfsthumb = TextEditingController();
  TextEditingController textfielduploadtext = TextEditingController();

  bool testedipfshash = false;
  bool testedipfsthumb = false;

  void nextStep(BuildContext context) {
    if (_currentStep <= 4) {
      switch (_currentStep) {
        case 0:
          if (acceptedfirst) {
            _currentStep++;
          }
          break;
        case 1:
          if (acceptedsecond) {
            _currentStep++;
          }
          break;
        case 2:
          if (selectedprovider) {
            _currentStep++;
          }
          break;
        case 3:
          _currentStep++;
          break;
        case 4:
          initAddUpload(context);
        default:
      }

      notifyListeners();
    }
  }

  void previousStep() {
    _currentStep--;
    notifyListeners();
  }

  void reset() {
    _currentStep = 0;
    notifyListeners();
  }

  void newStep(int index) {
    _currentStep = index;
    notifyListeners();
  }

  void changeonacceptedfirst(bool? value) {
    acceptedfirst = value!;
    notifyListeners();
  }

  void changeonacceptedsecond(bool bool) {
    acceptedsecond = bool;
    notifyListeners();
  }

  void changeonselectedprovider(bool bool) {
    selectedprovider = bool;
    notifyListeners();
  }

  void testedipfshashfunction() {
    testedipfshash = true;
    notifyListeners();
  }

  void testedipfsthumbfunction() {
    testedipfsthumb = true;
    notifyListeners();
  }

  Future<void> initAddUpload(BuildContext context) async {
    if (selecteduploadfiletype != "" &&
        selectedthumbfiletype != "" &&
        selectedlanguage != "" &&
        selectedflag != ContentFlag.none &&
        textfieldipfshash.text != "" &&
        textfieldipfsthumb.text != "" &&
        testedipfshash &&
        testedipfsthumb &&
        acceptedfirst &&
        acceptedsecond) {
      String username =Provider.of<GlobalStatus>(context, listen: false).username;
      String permission =Provider.of<GlobalStatus>(context, listen: false).permission;

      ContentFlag flag = selectedflag;
      String languageiso639 = getlanguage(selectedlanguage);

      final navigator = Navigator.of(context);
      final scaffoldContext = context;

      Chainactions chain = Chainactions()..setusernameandpermission(username, permission);

      final value = await chain.adduploadaction(
        username,
        textfieldipfshash.text,
        textfieldipfsthumb.text,
        textfielduploadtext.text,
        languageiso639,
        selecteduploadfiletype,
        selectedthumbfiletype,
        flag,
      );

      if (!navigator.mounted) return;

      if (value) {
        navigator.pop();
        //Show success Dialog
        showDialog(
            context: scaffoldContext,
            builder: ((context) {
              return const SuccessUpload();
            }));
      }
    } else {
      debugPrint("not all fields are filled");

      Globalnotifications.shownotification(
          context,
          AppLocalizations.of(context)!.noteverythingiscompleted,
          AppLocalizations.of(context)!.pleasecheckyourinput,
          "Info");
    }
  }

  static String getlanguage(String language) {
    String languagelowercase = language.toLowerCase();
    switch (languagelowercase) {
      case "international/none":
        return "ii";
      case "german":
        return "de";
      case "english":
        return "en";
      case "french":
        return "fr";
      case "spanish":
        return "es";
      default:
        return "";
    }
  }
}

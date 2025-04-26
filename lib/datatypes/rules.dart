import 'package:fr0gsite/datatypes/rule.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Rules {

  List<Rule> getUploadRules(context) {
    List<Rule> uploadRules = [];
      uploadRules.add(Rule(1, AppLocalizations.of(context)!.rule1,  AppLocalizations.of(context)!.punishment5));
      uploadRules.add(Rule(2, AppLocalizations.of(context)!.rule2,  AppLocalizations.of(context)!.punishment5));
      uploadRules.add(Rule(3, AppLocalizations.of(context)!.rule3,  AppLocalizations.of(context)!.punishment5));
      uploadRules.add(Rule(4, AppLocalizations.of(context)!.rule4,  AppLocalizations.of(context)!.punishment5));
      uploadRules.add(Rule(5, AppLocalizations.of(context)!.rule5,  AppLocalizations.of(context)!.punishment4));
      uploadRules.add(Rule(6, AppLocalizations.of(context)!.rule6,  AppLocalizations.of(context)!.punishment4));
      uploadRules.add(Rule(7, AppLocalizations.of(context)!.rule7,  AppLocalizations.of(context)!.punishment0));
      uploadRules.add(Rule(8, AppLocalizations.of(context)!.rule8,  AppLocalizations.of(context)!.punishment3));
      uploadRules.add(Rule(9, AppLocalizations.of(context)!.rule9,  AppLocalizations.of(context)!.punishment1));
      uploadRules.add(Rule(10, AppLocalizations.of(context)!.rule10,AppLocalizations.of(context)!.punishment2));
    return uploadRules;
  }

  List<Rule> getCommentRules(context) {
     List<Rule> uploadRules = getUploadRules(context);
    List<Rule> commentRules = [];
    commentRules.add(uploadRules[0]);
    commentRules.add(uploadRules[1]);
    commentRules.add(uploadRules[4]);
    commentRules.add(uploadRules[5]);
    commentRules.add(uploadRules[6]);
    commentRules.add(uploadRules[7]);
    return commentRules;
  }

  List<Rule> getTagRules(context) {
    List<Rule> tagRules = [];
    tagRules.add(Rule(1, "Wenlink to website",  AppLocalizations.of(context)!.punishment3));
    tagRules.add(Rule(2, "Spamming",  AppLocalizations.of(context)!.punishment3));
    tagRules.add(Rule(3, "Not related to the content",  AppLocalizations.of(context)!.punishment3));
    return tagRules;
  }




}
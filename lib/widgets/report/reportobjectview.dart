import 'package:fr0gsite/datatypes/reportstatus.dart';
import 'package:fr0gsite/datatypes/rule.dart';
import 'package:flutter/material.dart';
import 'package:fr0gsite/datatypes/rules.dart';
import 'package:provider/provider.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';

class ReportObjectView extends StatefulWidget {
  const ReportObjectView({super.key});

  @override
  State<ReportObjectView> createState() => _ReportObjectViewState();
}

class _ReportObjectViewState extends State<ReportObjectView> {
  int groupValue = 0;

  @override
  void initState() {
    super.initState();
  }

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    //List<Rule> rules = Provider.of<ReportStatus>(context).getrules(context);
    List<Rule> rules = [];
    switch(Provider.of<ReportStatus>(context).reporttype){
      case 1: rules = Rules().getUploadRules(context); break;
      case 2: rules = Rules().getCommentRules(context); break;
      case 3: rules = Rules().getTagRules(context); break;
      default: rules = []; break;
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DropdownButtonFormField<Rule>(
          decoration: const InputDecoration(
            labelStyle: TextStyle(color: Colors.white),
            prefixIcon: Icon(Icons.rule, color: Colors.white),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
          ),
          dropdownColor: Colors.black,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          iconSize: 24,
          isDense: false,
          initialValue: Provider.of<ReportStatus>(context).selectedrule < 0
              ? null
              : rules.firstWhere(
                  (element) =>
                      element.ruleNr ==
                      Provider.of<ReportStatus>(context).selectedrule),
          hint: Text(AppLocalizations.of(context)!.selectrule,
              style: const TextStyle(color: Colors.white)),
          elevation: 16,
          style: const TextStyle(color: Colors.white),
          onChanged: (Rule? rule) {
            Provider.of<ReportStatus>(context, listen: false)
                .setRule(rule?.ruleNr ?? 0);
          },
          items: rules.map((Rule rule) {
            return DropdownMenuItem<Rule>(
              value: rule,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            "${AppLocalizations.of(context)!.rule} ${rule.ruleNr.toString()}: ${rule.ruleName} \n",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                          text:
                              "${AppLocalizations.of(context)!.punishment}: ${rule.rulePunishment}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent)),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

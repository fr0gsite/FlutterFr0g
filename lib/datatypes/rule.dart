class Rule {
  int ruleNr;
  String ruleName;
  String rulePunishment;
  bool needproof;

  Rule(this.ruleNr, this.ruleName, this.rulePunishment,
      {this.needproof = false});

  String getRuleName() {
    return ruleName;
  }
}

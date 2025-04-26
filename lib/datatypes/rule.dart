class Rule {
  int ruleNr;
  String ruleName;
  String rulePunishment;

  Rule(this.ruleNr, this.ruleName, this.rulePunishment);

  String getRuleName() {
    return ruleName;
  }

  static Rule dummy() {
    return Rule(0, "Dummy", "Dummy punishment");
  }
}

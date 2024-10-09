class RewardCalc {
  // Reward calculation constants based on smart contract
  static double rewardforFAME = 0.4;
  static double rewardforTRUST = 0.4;
  static double rewardforACT = 0.2;

  double totalsupplyFAME = 1;
  double totalsupplyTRUST = 1;
  double totalsupplyACT = 1;

  double usersupplyFAME = 0;
  double usersupplyTRUST = 0;
  double usersupplyACT = 0;

  double cbasedsystemtokens = 0;

  RewardCalc(
      this.totalsupplyFAME,
      this.totalsupplyTRUST,
      this.totalsupplyACT,
      this.usersupplyFAME,
      this.usersupplyTRUST,
      this.usersupplyACT,
      this.cbasedsystemtokens);

  settotalsupplyFAME(double value) {
    totalsupplyFAME = value;
  }

  settotalsupplyTRUST(double value) {
    totalsupplyTRUST = value;
  }

  settotalsupplyACT(double value) {
    totalsupplyACT = value;
  }

  setusersupplyFAME(double value) {
    usersupplyFAME = value;
  }

  setusersupplyTRUST(double value) {
    usersupplyTRUST = value;
  }

  setusersupplyACT(double value) {
    usersupplyACT = value;
  }

  setcbasedsystemtokens(double value) {
    cbasedsystemtokens = value;
  }

  double getrewardFAME() {
    if (totalsupplyFAME > 0) {
      if (cbasedsystemtokens > 0) {
        double systemtokensupplyproportion = rewardforFAME * cbasedsystemtokens;
        double usersupplyproportion = usersupplyFAME / totalsupplyFAME;
        return usersupplyproportion * systemtokensupplyproportion;
      }
    }
    return 0;
  }

  double getrewardTRUST() {
    if (totalsupplyTRUST > 0) {
      if (cbasedsystemtokens > 0) {
        double systemtokensupplyproportion =
            rewardforTRUST * cbasedsystemtokens;
        double usersupplyproportion = usersupplyTRUST / totalsupplyTRUST;
        return usersupplyproportion * systemtokensupplyproportion;
      }
    }
    return 0;
  }

  double getrewardACT() {
    if (totalsupplyACT > 0) {
      if (cbasedsystemtokens > 0) {
        double systemtokensupplyproportion = rewardforACT * cbasedsystemtokens;
        double usersupplyproportion = usersupplyACT / totalsupplyACT;
        return usersupplyproportion * systemtokensupplyproportion;
      }
    }
    return 0;
  }

  double getreward(String tokenname) {
    if (tokenname == "FAME") {
      return getrewardFAME();
    }
    if (tokenname == "TRUST") {
      return getrewardTRUST();
    }
    if (tokenname == "ACT") {
      return getrewardACT();
    }
    return 0;
  }

  double getusersupply(String tokenname) {
    if (tokenname == "FAME") {
      return usersupplyFAME;
    }
    if (tokenname == "TRUST") {
      return usersupplyTRUST;
    }
    if (tokenname == "ACT") {
      return usersupplyACT;
    }
    return 0;
  }
}

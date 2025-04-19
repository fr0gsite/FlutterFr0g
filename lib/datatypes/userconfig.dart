class UserConfig {
  final BigInt configid;
  DateTime creationtime;
  int active;
  int sanction;
  DateTime sanctionuntil;
  DateTime lastactreset;
  int acttoken;
  int acttokenmax = 10000;
  DateTime lastclaimtime;
  bool istruster;
  int numofsubscribtions;
  int numoffollowers;
  int numofuploads;
  int numofcomments;
  int numofuploadvotes;
  int numofcommentvotes;
  int numofaddtags;
  int numoffavorites;
  int numoffavoritetags;
  int numofreports;
  String profilebio;
  String profileimageipfs;
  String profileimagefiletyp;
  String language;
  String otherconfigsasjson;

  UserConfig({
    required this.configid,
    required this.creationtime,
    required this.active,
    required this.sanction,
    required this.sanctionuntil,
    required this.lastactreset,
    required this.acttoken,
    required this.lastclaimtime,
    required this.istruster,
    required this.numofsubscribtions,
    required this.numoffollowers,
    required this.numofuploads,
    required this.numofcomments,
    required this.numofuploadvotes,
    required this.numofcommentvotes,
    required this.numofaddtags,
    required this.numoffavorites,
    required this.numoffavoritetags,
    required this.numofreports,
    required this.profilebio,
    required this.profileimageipfs,
    required this.profileimagefiletyp,
    required this.language,
    required this.otherconfigsasjson,
  });

  static UserConfig fromJson(Map<String, dynamic> json) {
    return UserConfig(
      configid: BigInt.parse(json['configid']),
      creationtime: DateTime.parse(json['creationtime']),
      active: json['active'],
      sanction: json['sanction'],
      sanctionuntil: DateTime.parse(json['sanctionuntil']),
      lastactreset: DateTime.parse(json['last_act_reset']),
      acttoken: json['act_token'],
      lastclaimtime: DateTime.parse(json['last_claim_time']),
      istruster: json['istruster'] == 1 ? true : false,
      numofsubscribtions: json['numofsubscribtions'],
      numoffollowers: json['numoffollowers'],
      numofuploads: json['numofuploads'],
      numofcomments: json['numofcomments'],
      numofuploadvotes: json['numofuploadvotes'],
      numofcommentvotes: json['numofcommentvotes'],
      numofaddtags: json['numofaddtags'],
      numoffavorites: json['numoffavorites'],
      numoffavoritetags: json['numoffavoritetags'],
      numofreports: json['numofreports'],
      profilebio: json['profilebio'],
      profileimageipfs: json['profileimageipfs'],
      profileimagefiletyp: json['profileimagefiletyp'],
      language: json['language'],
      otherconfigsasjson: json['otherconfigsasjson'],
    );
  }

  static UserConfig dummy() {
    return UserConfig(
      configid: BigInt.parse("0"),
      creationtime: DateTime.parse("2000-01-01 00:00:00.000000"),
      active: 0,
      sanction: 0,
      sanctionuntil: DateTime.parse("2000-01-01 00:00:00.000000"),
      lastactreset: DateTime.parse("2000-01-01 00:00:00.000000"),
      acttoken: 0,
      lastclaimtime: DateTime.parse("2000-01-01 00:00:00.000000"),
      istruster: false,
      numofsubscribtions: 0,
      numoffollowers: 0,
      numofuploads: 0,
      numofcomments: 0,
      numofuploadvotes: 0,
      numofcommentvotes: 0,
      numofaddtags: 0,
      numoffavorites: 0,
      numoffavoritetags: 0,
      numofreports: 0,
      profilebio: "",
      profileimageipfs: "",
      profileimagefiletyp: "",
      language: "en",
      otherconfigsasjson: "",
    );
  }
}

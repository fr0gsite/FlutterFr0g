class Report {
  int reportid;
  int status;
  int id;
  int type;
  String reportername;
  int violatedrule;
  String reporttext;
  DateTime reporttime;
  int numberoftrusters;
  int outstandingvotes;
  int voteweight;
  String json;

  Report({
    required this.reportid,
    required this.status,  // 0 = open, 1 = closed
    required this.id, // id of the content (e.g. upload id)
    required this.type, // type of the report, 1 = upload, 2 = comment, 3 = tag
    required this.reportername, // name of the reporter
    required this.violatedrule, 
    required this.reporttext,
    required this.reporttime,
    required this.numberoftrusters, // number of trusters selected for vote
    required this.outstandingvotes, // number of votes that are still open
    required this.voteweight,
    required this.json,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      reportid: json['reportid'],
      status: json['status'],
      id: json['id'],
      type: json['type'],
      reportername: json['reportername'],
      violatedrule: json['violatedrule'],
      reporttext: json['reporttext'],
      reporttime: DateTime.parse(json['reporttime']),
      numberoftrusters: json['numberoftrusters'],
      outstandingvotes: json['outstandingvotes'],
      voteweight: json['vote_weight'],
      json: json['json'],
    );
  }
}

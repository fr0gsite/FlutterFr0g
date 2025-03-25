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
    required this.status,
    required this.id,
    required this.type,
    required this.reportername,
    required this.violatedrule,
    required this.reporttext,
    required this.reporttime,
    required this.numberoftrusters,
    required this.outstandingvotes,
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

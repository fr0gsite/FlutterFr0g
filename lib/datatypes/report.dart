class Report {
  int uploadid;
  String reportername;
  int violatedrule;
  String reporttext;
  DateTime reporttime;
  int numberoftrusters;
  int outstandingvotes;
  int voteweight;

  Report({
    required this.uploadid,
    required this.reportername,
    required this.violatedrule,
    required this.reporttext,
    required this.reporttime,
    required this.numberoftrusters,
    required this.outstandingvotes,
    required this.voteweight,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      uploadid: json['uploadid'],
      reportername: json['reportername'],
      violatedrule: json['violatedrule'],
      reporttext: json['reporttext'],
      reporttime: DateTime.parse(json['reporttime']),
      numberoftrusters: json['numberoftrusters'],
      outstandingvotes: json['outstandingvotes'],
      voteweight: json['vote_weight'],
    );
  }
}

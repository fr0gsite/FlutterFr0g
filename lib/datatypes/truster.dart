
class Truster {
  late final String trustername;
  late int karma;
  late int status;
  late int numofopenreports;
  late int numofclosedreports;
  late DateTime electiondate;
  int vacationdays = 0;
  bool invacation = false;
  String language = "de/en";

  Truster({
    required this.trustername,
    required this.karma,
    required this.status,
    required this.numofopenreports,
    required this.numofclosedreports,
    required this.electiondate,
  });

  Map<String, dynamic> toJson() {
    return {
      'trustername': trustername,
      'karma': karma,
      'status': status,
      'numofopenreports': numofopenreports,
      'numofclosedreports': numofclosedreports,
      'electiondate': electiondate,
    };
  }

  static Truster fromJson(Map<String, dynamic> json) {
    return Truster(
      trustername: json['trustername'].toString(),
      karma: int.parse(json['karma'].toString()),
      status: int.parse(json['status'].toString()),
      numofopenreports: int.parse(json['numofopenreports'].toString()),
      numofclosedreports: int.parse(json['numofclosedreports'].toString()),
      electiondate: DateTime.parse(json['election_date']),
    );
  }
  
  Truster.dummy() {
    trustername = "truster";
    karma = 0;
    status = 0;
    numofopenreports = 0;
    numofclosedreports = 0;
    electiondate = DateTime.now();
  }

}
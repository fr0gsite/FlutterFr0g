
class Truster {
  late final String trustername;
  late int karma;
  late int status;
  late DateTime electiondate;

  Truster({
    required this.trustername,
    required this.karma,
    required this.status,
    required this.electiondate,
  });

  Map<String, dynamic> toJson() {
    return {
      'trustername': trustername,
      'karma': karma,
      'status': status,
      'electiondate': electiondate,
    };
  }

  static Truster fromJson(Map<String, dynamic> json) {
    return Truster(
      trustername: json['trustername'].toString(),
      karma: int.parse(json['karma'].toString()),
      status: int.parse(json['status'].toString()),
      electiondate: DateTime.parse(json['election_date']),
    );
  }
}
class ReportVotes {
  String trustername;
  int vote;

  ReportVotes({
    required this.trustername,
    required this.vote,
  });

  factory ReportVotes.fromJson(Map<String, dynamic> json) {
    return ReportVotes(
      trustername: json['trustername'],
      vote: json['vote'],
    );
  }
}

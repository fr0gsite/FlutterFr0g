import 'package:fr0gsite/nameconverter.dart';

class ReportVotes {
  String trustername;
  int vote;

  ReportVotes({
    required this.trustername,
    required this.vote,
  });

  factory ReportVotes.fromJson(Map<String, dynamic> json) {
    return ReportVotes(
      trustername: NameConverter.uint64ToName(BigInt.parse(json['trustername'])),
      vote: json['vote'],
    );
  }
}

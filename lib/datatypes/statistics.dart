
class Statistics {
  final int id;
  final String text;
  final DateTime time;
  final int int64number;

  Statistics({
    required this.id,
    required this.text,
    required this.time,
    required this.int64number,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'time': time.toIso8601String(),
      'int64number': int64number,
    };
  }

  static Statistics fromJson(Map<String, dynamic> json) {
    return Statistics(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      text: json['text'].toString(),
      time: DateTime.parse(json['time'].toString()),
      int64number: json['int64number'] is String ? int.parse(json['int64number']) : json['int64number'],
    );
  }
}


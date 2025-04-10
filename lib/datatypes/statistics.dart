
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

/*

uint64_t statisticid_last_run = 1;
uint64_t statisticid_numofuploads = 2;
uint64_t statisticid_numofcomments = 3;
uint64_t statisticid_numoftags = 4;
uint64_t statisticid_numoftruster = 5;
//reports
uint64_t statisticid_numofreports = 6;
uint64_t statisticid_numofdeleteduploads = 7;
uint64_t statisticid_numofdeletedcomments = 8;
uint64_t statisticid_numofdeletedtags = 9;
uint64_t statisticid_numofreportsuccessed = 10;
//votes
uint64_t statisticid_numofuploadvotes = 11;
uint64_t statisticid_numofcommentvotes = 12;
uint64_t statisticid_numoftagvotes = 13;
//favorites
uint64_t statisticid_numoffavorites = 14;
uint64_t statisticid_numoffavoritetags = 15;
uint64_t statisticid_numoffavoitecomment = 16;
*/
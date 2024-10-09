
class Tag {
  final String globuptagid;
  final String globaltagid;
  final String text;
  final String autor;
  final int token;

  Tag({
    required this.globuptagid,
    required this.globaltagid,
    required this.text,
    required this.autor,
    required this.token,
  });

  Map<String, dynamic> toJson() {
    return {
      'globuptagid': globuptagid,
      'globaltagid': globaltagid,
      'text': text,
      'autor': autor,
      'token': token,
    };
  }

  static Tag fromJson(Map<String, dynamic> json) {
    return Tag(
      globuptagid: json['globuptagid'].toString(),
      globaltagid: json['globaltagid'].toString(),
      text: json['text'].toString(),
      autor: json['autor'].toString(),
      token: json['token'] is String ? int.parse(json['token']) : json['token'],
    );
  }
}

class GlobalComments {
  final int commentid;
  final int uploadid;

  GlobalComments({
    required this.commentid,
    required this.uploadid,
  });

  static GlobalComments fromJson(Map<String, dynamic> json) {
    return GlobalComments(
      commentid: int.parse(json['commentid'].toString()),
      uploadid: int.parse(json['uploadid'].toString()),
    );
  }

}
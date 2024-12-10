class GlobalComments {
  final String commentid;
  final String uploadid;

  GlobalComments({
    required this.commentid,
    required this.uploadid,
  });

  static GlobalComments fromJson(Map<String, dynamic> json) {
    return GlobalComments(
      commentid: json['commentid'].toString(),
      uploadid: json['uploadid'].toString(),
    );
  }

}
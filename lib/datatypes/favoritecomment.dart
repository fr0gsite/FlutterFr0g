class FavoriteComment {
  final BigInt commentid;
  final DateTime creationtime;
  String commenttext = "";

  FavoriteComment({
    required this.commentid,
    required this.creationtime,
  });

  static FavoriteComment fromJson(Map<String, dynamic> json) {
    return FavoriteComment(
      commentid: BigInt.parse(json['commentid'].toString()),
      creationtime: DateTime.parse(json['creationtime']),
    );
  }

  void setCommentText(String text) {
    commenttext = text;
  }
}

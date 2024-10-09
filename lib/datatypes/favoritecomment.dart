class FavoriteComment {
  final BigInt commentid;
  final DateTime creationtime;

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
}

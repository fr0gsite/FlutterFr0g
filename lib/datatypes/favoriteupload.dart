class FavoriteUpload {
  final BigInt uploadid;
  final DateTime creationtime;

  FavoriteUpload({
    required this.uploadid,
    required this.creationtime,
  });

  static FavoriteUpload fromJson(Map<String, dynamic> json) {
    return FavoriteUpload(
      uploadid: BigInt.parse(json['uploadid'].toString()),
      creationtime: DateTime.parse(json['creationtime']),
    );
  }
}

class FavoriteTag {
  final BigInt globaltagid;

  FavoriteTag({
    required this.globaltagid,
  });

  static FavoriteTag fromJson(Map<String, dynamic> json) {
    return FavoriteTag(
      globaltagid: BigInt.parse(json['globaltagid'].toString()),
    );
  }
}

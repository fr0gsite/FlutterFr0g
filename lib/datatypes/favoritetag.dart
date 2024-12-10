class FavoriteTag {
  final BigInt globaltagid;
  String globaltagname = "";

  FavoriteTag({
    required this.globaltagid,
  });

  static FavoriteTag fromJson(Map<String, dynamic> json) {
    return FavoriteTag(
      globaltagid: BigInt.parse(json['globaltagid'].toString()),
    );
  }

  set setTagName(String globaltagname) {
    this.globaltagname = globaltagname;
  }
}

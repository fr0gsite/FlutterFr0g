class GlobalTags {
  BigInt globaltagid;
  DateTime creationtime;
  BigInt numoffavorites;
  BigInt trend;
  BigInt numofuploads;
  BigInt up;
  BigInt down;
  String text;

  GlobalTags({
    required this.globaltagid,
    required this.creationtime,
    required this.numoffavorites,
    required this.trend,
    required this.numofuploads,
    required this.up,
    required this.down,
    required this.text,
  });

  factory GlobalTags.fromJson(Map<String, dynamic> json) {
    return GlobalTags(
      globaltagid: BigInt.parse(json['globaltagid'].toString()),
      creationtime: DateTime.parse(json['creationtime']),
      numoffavorites: BigInt.parse(json['numoffavorites'].toString()),
      trend: BigInt.parse(json['trend'].toString()),
      numofuploads: BigInt.parse(json['numofuploads'].toString()),
      up: BigInt.parse(json['up'].toString()),
      down: BigInt.parse(json['down'].toString()),
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() => {
        'globaltagid': globaltagid.toString(),
        'creationtime': creationtime.toString(),
        'numoffavorites': numoffavorites.toString(),
        'trend': trend.toString(),
        'numofuploads': numofuploads.toString(),
        'up': up.toString(),
        'down': down.toString(),
        'text': text,
      };

  factory GlobalTags.dummy() {
    return GlobalTags(
      globaltagid: BigInt.from(0),
      creationtime: DateTime.now(),
      numoffavorites: BigInt.from(0),
      trend: BigInt.from(0),
      numofuploads: BigInt.from(0),
      up: BigInt.from(0),
      down: BigInt.from(0),
      text: "Loading...",
    );
  }
}

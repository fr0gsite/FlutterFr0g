class Usersubscription {
  BigInt subscriptionid;
  String username;
  DateTime creationtime;

  Usersubscription({
    required this.subscriptionid,
    required this.username,
    required this.creationtime,
  });

  static Usersubscription fromJson(Map<String, dynamic> json) {
    return Usersubscription(
      subscriptionid: BigInt.parse(json['subscriptionid'].toString()),
      username: json['username'],
      creationtime: DateTime.parse(json['creationtime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subscriptionid': subscriptionid.toString(),
      'username': username,
      'creationtime': creationtime.toIso8601String(),
    };
  }
  
  static Usersubscription dummy() {
    return Usersubscription(
      subscriptionid: BigInt.zero,
      username: '',
      creationtime: DateTime.now(),
    );
  }
}

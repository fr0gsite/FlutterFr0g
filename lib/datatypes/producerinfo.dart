class ProducerInfo {
  String owner;
  double totalVotes;
  String producerKey;
  bool isActive;
  String url;
  int unpaidBlocks;
  DateTime lastClaimTime;
  int location;
  List<dynamic> producerAuthority;
  double uservote = 0;

  bool error = false;
  String errorMessage = '';

  ProducerInfo({
    required this.owner,
    required this.totalVotes,
    required this.producerKey,
    required this.isActive,
    required this.url,
    required this.unpaidBlocks,
    required this.lastClaimTime,
    required this.location,
    required this.producerAuthority,
  });

  factory ProducerInfo.fromJson(Map<String, dynamic> json) {
    return ProducerInfo(
      owner: json['owner'],
      totalVotes: double.parse(json['total_votes'].toString()),
      producerKey: json['producer_key'],
      isActive: json['is_active'] == json['is_active'],
      url: json['url'] ?? '',
      unpaidBlocks: json['unpaid_blocks'],
      lastClaimTime: DateTime.parse(json['last_claim_time']),
      location: json['location'],
      producerAuthority: json['producer_authority'],
    );
  }

  Map<String, dynamic> toJson() => {
        'owner': owner,
        'total_votes': totalVotes.toString(),
        'producer_key': producerKey,
        'is_active': isActive ? 1 : 0,
        'url': url,
        'unpaid_blocks': unpaidBlocks,
        'last_claim_time': lastClaimTime.toIso8601String(),
        'location': location,
        'producer_authority': producerAuthority,
      };

  factory ProducerInfo.dummy() {
    return ProducerInfo(
      owner: 'owner',
      totalVotes: 0,
      producerKey: 'producerKey',
      isActive: true,
      url: 'url',
      unpaidBlocks: 0,
      lastClaimTime: DateTime.now(),
      location: 0,
      producerAuthority: [],
    );
  }

  ProducerInfo setError(String message) {
    error = true;
    errorMessage = message;
    return this;
  }
}

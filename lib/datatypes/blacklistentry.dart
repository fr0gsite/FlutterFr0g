class BlacklistEntry {
  final String ipfshash;
  final String reason;

  BlacklistEntry({required this.ipfshash, required this.reason});

  factory BlacklistEntry.fromJson(Map<String, dynamic> json) {
    return BlacklistEntry(
      ipfshash: json['ipfshash'].toString(),
      reason: json['reason']?.toString() ?? '',
    );
  }
}

class CbasedToken {
  final String issuer;
  final Asset maximumSupply;
  final Asset supply;

  CbasedToken({
    required this.issuer,
    required this.maximumSupply,
    required this.supply,
  });

  static CbasedToken fromJson(Map<String, dynamic> json) {
    return CbasedToken(
      issuer: json['issuer'],
      maximumSupply: Asset.fromString(json['max_supply']),
      supply: Asset.fromString(json['supply']),
    );
  }
}

class Asset {
  final double amount;
  final String symbol;

  Asset({
    required this.amount,
    required this.symbol,
  });

  static Asset fromJson(Map<String, dynamic> json) {
    return Asset(
      amount: json['amount'],
      symbol: json['symbol'],
    );
  }

  static Asset fromString(String assetString) {
    var parts = assetString.split(' ');
    var amount = double.tryParse(parts[0]);
    var symbol = parts[1];

    if (amount == null) {
      throw const FormatException('Invalid format for asset amount');
    }

    return Asset(
      amount: amount,
      symbol: symbol,
    );
  }

  // Zusätzliche Methoden oder Logik für Asset...
}

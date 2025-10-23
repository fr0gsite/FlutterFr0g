class AppLanguage {
  final int id;
  final String languagename;
  final String countrycode;

  AppLanguage(this.id, this.languagename, this.countrycode);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'languagename': languagename,
      'countrycode': countrycode,
    };
  }

  factory AppLanguage.fromJson(Map<String, dynamic> json) {
    return AppLanguage(
      json['id'],
      json['languagename'],
      json['countrycode'],
    );
  }
}
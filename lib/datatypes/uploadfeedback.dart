class UploadFeedback {
  bool success;
  final String uploadipfshash;
  final String uploadipfshashfiletyp;
  final String thumbipfshash;
  final String thumbipfshashfiletyp;

  UploadFeedback(this.success, this.uploadipfshash, this.uploadipfshashfiletyp,
      this.thumbipfshash, this.thumbipfshashfiletyp);

  UploadFeedback.fromJson(Map<String, dynamic> json)
      : success = json['success'],
        uploadipfshash = json['uploadipfshash'],
        uploadipfshashfiletyp = json['uploadipfshashfiletyp'],
        thumbipfshash = json['thumbipfshash'],
        thumbipfshashfiletyp = json['thumbipfshashfiletyp'];

  Map<String, dynamic> toJson() => {
        'success': success,
        'uploadipfshash': uploadipfshash,
        'uploadipfshashfiletyp': uploadipfshashfiletyp,
        'thumbipfshash': thumbipfshash,
        'thumbipfshashfiletyp': thumbipfshashfiletyp,
      };
}

class UserUpload {
  int id;
  int uploadid;

  UserUpload({
    required this.id,
    required this.uploadid,
  });

  static UserUpload fromJson(Map<String, dynamic> json) {
    return UserUpload(
      id: json['id'],
      uploadid: json['uploadid'],
    );
  }
}

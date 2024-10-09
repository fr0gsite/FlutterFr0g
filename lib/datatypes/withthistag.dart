class WiththisTag {
  int uploadid;

  WiththisTag({required this.uploadid});

  factory WiththisTag.fromJson(Map<String, dynamic> json) {
    return WiththisTag(
      uploadid: json['uploadid'],
    );
  }

  Map<String, dynamic> toJson() => {
        'uploadid': uploadid,
      };
}

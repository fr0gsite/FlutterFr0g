class Comment {
  final int commentId;
  final int parentCommentId;
  final String author;
  final DateTime creationTime;
  final String language;
  final String commentText;
  final int token;
  final int up;
  final int down;

  Comment({
    required this.commentId,
    required this.parentCommentId,
    required this.author,
    required this.creationTime,
    required this.language,
    required this.commentText,
    required this.token,
    required this.up,
    required this.down,
  });

  static Comment fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['commentid'],
      parentCommentId: json['parentcommentid'],
      author: json['autor'],
      creationTime: DateTime.parse(json['creationtime']),
      language: json['language'],
      commentText: json['commenttext'],
      token: json['token'],
      up: json['up'],
      down: json['down'],
    );
  }
}

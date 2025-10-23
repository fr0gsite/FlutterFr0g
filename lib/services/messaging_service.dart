import 'package:fr0gsite/services/chainactions_base.dart';
import 'package:fr0gsite/datatypes/comment.dart';
import 'package:fr0gsite/datatypes/favoritecomment.dart';
import 'package:flutter/foundation.dart';

/// Service for messaging system operations corresponding to messaging_system.cpp
class MessagingService extends ChainActionsBase {

  /// Add comment to an upload
  Future<bool> addcomment(
      String autor,
      String commenttext,
      String uploadid) async {
    
    // Note: Implementation would use action helpers from actionlist.dart
    debugPrint("Adding comment by $autor on upload $uploadid: $commenttext");
    return false; // Placeholder
  }

  /// Add reply to a comment
  Future<bool> addcommentreply(String autor, String commenttext,
      String commentid, String uploadid) async {
    
    // Note: Implementation would use action helpers from actionlist.dart
    debugPrint("Adding comment reply by $autor to comment $commentid: $commenttext");
    return false; // Placeholder
  }

  /// Fetch all comments for a specific upload
  Future<List<Comment>> fetchComments(String uploadid) async {
    try {
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest",
        scope: "fr0gsitetest",
        table: "comments",
        indexPosition: "2",
        keyType: "i64",
        lowerBound: uploadid,
        upperBound: uploadid,
        limit: 200,
        reverse: true,
      );

      List<Comment> comments = [];
      int uploadIdInt = int.tryParse(uploadid) ?? 0;
      for (var row in rows) {
        try {
          Comment comment = Comment.fromJson(row, uploadIdInt);
          comments.add(comment);
        } catch (e) {
          debugPrint("Error parsing comment: $e");
          continue; // Skip malformed comments
        }
      }

      return comments;
    } catch (error) {
      debugPrint("Error fetching comments: $error");
      return <Comment>[];
    }
  }

  /// Get comment by global ID
  Future<Comment> getcommentbyglobalid(String commentid) async {
    try {
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest",
        scope: "fr0gsitetest",
        table: "comments",
        lowerBound: commentid,
        upperBound: commentid,
        limit: 1,
      );

      if (rows.isNotEmpty) {
        // Parse uploadid from the comment data
        int uploadIdFromData = rows[0]['uploadid'] ?? 0;
        return Comment.fromJson(rows[0], uploadIdFromData);
      } else {
        // Return a default comment
        return Comment(
          commentId: 0,
          parentCommentId: 0,
          author: "",
          creationTime: DateTime.now(),
          language: "en",
          commentText: "",
          token: 0,
          up: 0,
          down: 0,
          uploadid: 0,
        );
      }
    } catch (error) {
      debugPrint("Error getting comment by global ID: $error");
      // Return a default comment
      return Comment(
        commentId: 0,
        parentCommentId: 0,
        author: "",
        creationTime: DateTime.now(),
        language: "en",
        commentText: "",
        token: 0,
        up: 0,
        down: 0,
        uploadid: 0,
      );
    }
  }

  /// Get favorite comments of user
  Future<List<Comment>> getfavoritecommentsofuser(String username) async {
    try {
      // First get the favorite comment IDs
      List<dynamic> favoriteRows = await queryTable(
        contract: "fr0gsitetest",
        scope: username,
        table: "favoritecomm",
        limit: 100,
        reverse: true,
      );

      List<FavoriteComment> favoriteList = favoriteRows
          .map((row) => FavoriteComment.fromJson(row))
          .toList();

      // Then fetch each comment by ID concurrently
      List<Future<Comment>> commentFutures = [];
      for (var favorite in favoriteList) {
        Future<Comment> future = getcommentbyglobalid(favorite.commentid.toString());
        commentFutures.add(future);
      }

      List<Comment> comments = await Future.wait(commentFutures);
      return comments;
    } catch (error) {
      debugPrint("Error getting favorite comments: $error");
      return <Comment>[];
    }
  }

  /// Add comment to favorites
  Future<bool> addfavoritecomment(String commentid) async {
    // Note: Implementation would use action helpers from actionlist.dart
    debugPrint("Adding comment to favorites: $commentid");
    return false; // Placeholder
  }

  /// Remove comment from favorites
  Future<bool> deletefavoritecomment(String commentid) async {
    // Note: Implementation would use action helpers from actionlist.dart
    debugPrint("Removing comment from favorites: $commentid");
    return false; // Placeholder
  }
}
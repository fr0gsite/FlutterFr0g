import 'package:fr0gsite/services/chainactions_base.dart';
import 'package:fr0gsite/datatypes/globaltags.dart';
import 'package:fr0gsite/datatypes/tag.dart';
import 'package:fr0gsite/datatypes/favoritetag.dart';
import 'package:flutter/foundation.dart';

/// Service for tag system operations
class TagService extends ChainActionsBase {

  /// Add tag to an upload
  Future<bool> addtag(String uploadid, String tagtext) async {
    // Note: Implementation would use action helpers from actionlist.dart
    debugPrint("Adding tag '$tagtext' to upload $uploadid");
    return false; // Placeholder
  }

  /// Get mixed tags (combination of different tag categories)
  Future<List<GlobalTags>> getmixedtags() async {
    try {
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest",
        scope: "fr0gsitetest",
        table: "globaltags",
        limit: fetchlimittags,
        reverse: true,
      );

      return rows.map((row) => GlobalTags.fromJson(row)).toList();
    } catch (error) {
      debugPrint("Error getting mixed tags: $error");
      return <GlobalTags>[];
    }
  }

  /// Get popular global tags
  Future<List<GlobalTags>> getpopularglobaltags() async {
    try {
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest",
        scope: "fr0gsitetest", 
        table: "populartags",
        limit: fetchlimittags,
        reverse: true,
      );

      List<GlobalTags> tags = [];
      for (var row in rows) {
        try {
          String globaltagid = row['globaltagid'].toString();
          GlobalTags tag = await getglobaltagbyid(globaltagid);
          tags.add(tag);
        } catch (e) {
          debugPrint("Error processing popular tag: $e");
          continue;
        }
      }

      return tags;
    } catch (error) {
      debugPrint("Error getting popular global tags: $error");
      return <GlobalTags>[];
    }
  }

  /// Get trending tags
  Future<List<GlobalTags>> gettrendingtags() async {
    try {
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest",
        scope: "fr0gsitetest",
        table: "trendingtags",
        limit: fetchlimittags,
        reverse: true,
      );

      List<GlobalTags> tags = [];
      for (var row in rows) {
        try {
          String globaltagid = row['globaltagid'].toString();
          GlobalTags tag = await getglobaltagbyid(globaltagid);
          tags.add(tag);
        } catch (e) {
          debugPrint("Error processing trending tag: $e");
          continue;
        }
      }

      return tags;
    } catch (error) {
      debugPrint("Error getting trending tags: $error");
      return <GlobalTags>[];
    }
  }

  /// Get new tags
  Future<List<GlobalTags>> getnewtags() async {
    try {
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest",
        scope: "fr0gsitetest",
        table: "globaltags",
        limit: fetchlimittags,
        reverse: true,
      );

      return rows.map((row) => GlobalTags.fromJson(row)).toList();
    } catch (error) {
      debugPrint("Error getting new tags: $error");
      return <GlobalTags>[];
    }
  }

  /// Get global tag by ID
  Future<GlobalTags> getglobaltagbyid(String globaltagid) async {
    try {
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest",
        scope: "fr0gsitetest",
        table: "globaltags",
        lowerBound: globaltagid,
        upperBound: globaltagid,
        limit: 1,
      );

      if (rows.isNotEmpty) {
        return GlobalTags.fromJson(rows[0]);
      } else {
        return GlobalTags.dummy();
      }
    } catch (error) {
      debugPrint("Error getting global tag by ID: $error");
      return GlobalTags.dummy();
    }
  }

  /// Fetch tags for a specific upload
  Future<List<Tag>> fetchTags(String uploadid) async {
    try {
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest",
        scope: "fr0gsitetest",
        table: "tags",
        indexPosition: "2",
        keyType: "i64",
        lowerBound: uploadid,
        upperBound: uploadid,
        limit: 50,
      );

      return rows.map((row) => Tag.fromJson(row)).toList();
    } catch (error) {
      debugPrint("Error fetching tags: $error");
      return <Tag>[];
    }
  }

  /// Get favorite tags of user
  Future<List<FavoriteTag>> getfavoritetagsofuser(String username) async {
    try {
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest",
        scope: username,
        table: "favoritetags",
        limit: 100,
        reverse: true,
      );

      return rows.map((row) => FavoriteTag.fromJson(row)).toList();
    } catch (error) {
      debugPrint("Error getting favorite tags: $error");
      return <FavoriteTag>[];
    }
  }

  /// Check if global tag is favorite for user
  Future<bool> isglobaltagfavorite(String username, String globaltagid) async {
    try {
      List<FavoriteTag> favoriteTags = await getfavoritetagsofuser(username);
      
      for (var favoriteTag in favoriteTags) {
        if (favoriteTag.globaltagid.toString() == globaltagid) {
          return true;
        }
      }
      
      return false;
    } catch (error) {
      debugPrint("Error checking if global tag is favorite: $error");
      return false;
    }
  }

  /// Add tag to favorites
  Future<bool> addfavoritetag(String globaltagid) async {
    // Note: Implementation would use action helpers from actionlist.dart
    debugPrint("Adding tag to favorites: $globaltagid");
    return false; // Placeholder
  }

  /// Remove tag from favorites
  Future<bool> deletefavoritetag(String globaltagid) async {
    // Note: Implementation would use action helpers from actionlist.dart
    debugPrint("Removing tag from favorites: $globaltagid");
    return false; // Placeholder
  }
}
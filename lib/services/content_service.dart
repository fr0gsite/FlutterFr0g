import 'package:fr0gsite/services/chainactions_base.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:fr0gsite/datatypes/favoriteupload.dart';
import 'package:flutter/foundation.dart';

/// Service for content management operations corresponding to content_management.cpp
class ContentService extends ChainActionsBase {
  
  // Upload Cache - static to share across instances
  static final Map<String, Upload> _uploadCache = {};
  static final Map<String, DateTime> _uploadCacheTimestamps = {};
  static const Duration _cacheValidityDuration = Duration(minutes: 30);

  /// Add new upload action to blockchain
  Future<bool> adduploadaction(
      String autor,
      String uploadipfshash,
      String thumbipfshash,
      String uploadtext,
      int uploadtype) async {
    
    // Note: Implementation would use action helpers from actionlist.dart
    debugPrint("Adding upload for $autor: $uploadtext");
    return false; // Placeholder
  }

  /// Get upload by ID
  Future<Upload> getupload(String uploadid) async {
    try {
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest",
        scope: "fr0gsitetest",
        table: "uploads",
        lowerBound: uploadid,
        upperBound: uploadid,
        limit: 1,
      );

      if (rows.isNotEmpty) {
        return Upload.fromJson(rows[0]);
      } else {
        return Upload.demo();
      }
    } catch (error) {
      debugPrint("Error getting upload: $error");
      return Upload.demo();
    }
  }

  /// Get cached upload with automatic cache management
  Future<Upload> cachedgetupload(String uploadid) async {
    // Check cache validity
    DateTime? cacheTime = _uploadCacheTimestamps[uploadid];
    if (cacheTime != null && 
        DateTime.now().difference(cacheTime) < _cacheValidityDuration) {
      Upload? cached = _uploadCache[uploadid];
      if (cached != null) {
        debugPrint("Returning cached upload: $uploadid");
        return cached;
      }
    }

    // Fetch fresh data
    Upload upload = await getupload(uploadid);
    
    // Cache the result
    _uploadCache[uploadid] = upload;
    _uploadCacheTimestamps[uploadid] = DateTime.now();
    
    // Clean old cache entries (keep cache size manageable)
    if (_uploadCache.length > 1000) {
      _cleanOldCacheEntries();
    }
    
    return upload;
  }

  /// Clean old cache entries to prevent memory issues
  void _cleanOldCacheEntries() {
    List<String> keysToRemove = [];
    DateTime cutoff = DateTime.now().subtract(_cacheValidityDuration);
    
    _uploadCacheTimestamps.forEach((key, timestamp) {
      if (timestamp.isBefore(cutoff)) {
        keysToRemove.add(key);
      }
    });
    
    for (String key in keysToRemove) {
      _uploadCache.remove(key);
      _uploadCacheTimestamps.remove(key);
    }
    
    debugPrint("Cleaned ${keysToRemove.length} old cache entries");
  }

  /// Get new uploads
  Future<List<Upload>> getnewuploads() async {
    try {
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest",
        scope: "fr0gsitetest", 
        table: "uploads",
        limit: fetchlimituploads,
        reverse: true,
      );

      return rows.map((row) => Upload.fromJson(row)).toList();
    } catch (error) {
      debugPrint("Error getting new uploads: $error");
      return <Upload>[];
    }
  }

  /// Get popular uploads
  Future<List<Upload>> getpopularuploads() async {
    try {
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest",
        scope: "fr0gsitetest",
        table: "popularupld",
        limit: fetchlimituploads,
        reverse: true,
      );

      List<Upload> uploads = [];
      for (var row in rows) {
        String uploadid = row['uploadid'].toString();
        Upload upload = await cachedgetupload(uploadid);
        uploads.add(upload);
      }
      
      return uploads;
    } catch (error) {
      debugPrint("Error getting popular uploads: $error");
      return <Upload>[];
    }
  }

  /// Get popular uploads lower than specific ID
  Future<List<Upload>> getpopularuploadslowerthan(String popularid) async {
    try {
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest",
        scope: "fr0gsitetest",
        table: "popularupld", 
        upperBound: popularid,
        limit: fetchlimituploads,
        reverse: true,
      );

      List<Upload> uploads = [];
      for (var row in rows) {
        String uploadid = row['uploadid'].toString();
        Upload upload = await cachedgetupload(uploadid);
        uploads.add(upload);
      }
      
      return uploads;
    } catch (error) {
      debugPrint("Error getting popular uploads lower than: $error");
      return <Upload>[];
    }
  }

  /// Get popular uploads upper than specific ID
  Future<List<Upload>> getpopularuploadsupperthan(String popularid) async {
    try {
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest",
        scope: "fr0gsitetest",
        table: "popularupld",
        lowerBound: popularid, 
        limit: fetchlimituploads,
        reverse: false,
      );

      List<Upload> uploads = [];
      for (var row in rows) {
        String uploadid = row['uploadid'].toString();
        Upload upload = await cachedgetupload(uploadid);
        uploads.add(upload);
      }
      
      return uploads;
    } catch (error) {
      debugPrint("Error getting popular uploads upper than: $error");
      return <Upload>[];
    }
  }

  /// Get trending uploads
  Future<List<Upload>> gettrendinguploads() async {
    try {
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest",
        scope: "fr0gsitetest",
        table: "trending",
        limit: fetchlimituploads,
        reverse: true,
      );

      List<Upload> uploads = [];
      for (var row in rows) {
        String uploadid = row['uploadid'].toString();
        Upload upload = await cachedgetupload(uploadid);
        uploads.add(upload);
      }
      
      return uploads;
    } catch (error) {
      debugPrint("Error getting trending uploads: $error");
      return <Upload>[];
    }
  }

  /// Get trending uploads upper than specific ID
  Future<List<Upload>> gettrendinguploadsupperthan(String trendingid) async {
    try {
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest",
        scope: "fr0gsitetest",
        table: "trending",
        lowerBound: trendingid,
        limit: fetchlimituploads,
        reverse: false,
      );

      List<Upload> uploads = [];
      for (var row in rows) {
        String uploadid = row['uploadid'].toString();
        Upload upload = await cachedgetupload(uploadid);
        uploads.add(upload);
      }
      
      return uploads;
    } catch (error) {
      debugPrint("Error getting trending uploads upper than: $error");
      return <Upload>[];
    }
  }

  /// Get new uploads lower than specific ID
  Future<List<Upload>> getnewuploadslowerthan(String uploadid) async {
    try {
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest",
        scope: "fr0gsitetest",
        table: "uploads",
        upperBound: uploadid,
        limit: fetchlimituploads,
        reverse: true,
      );

      return rows.map((row) => Upload.fromJson(row)).toList();
    } catch (error) {
      debugPrint("Error getting new uploads lower than: $error");
      return <Upload>[];
    }
  }

  /// Get new uploads upper than specific ID
  Future<List<Upload>> getnewuploadsupperthan(String uploadid) async {
    try {
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest",
        scope: "fr0gsitetest",
        table: "uploads",
        lowerBound: uploadid,
        limit: fetchlimituploads,
        reverse: false,
      );

      return rows.map((row) => Upload.fromJson(row)).toList();
    } catch (error) {
      debugPrint("Error getting new uploads upper than: $error");
      return <Upload>[];
    }
  }

  /// Get uploads for specific global tag
  Future<List<Upload>> getuploadsforglobaltag(
      String globaltagid, int limit) async {
    try {
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest",
        scope: "fr0gsitetest",
        table: "withthistag",
        indexPosition: "2",
        keyType: "i64",
        lowerBound: globaltagid,
        upperBound: globaltagid,
        limit: limit,
        reverse: true,
      );

      List<Upload> uploads = [];
      for (var row in rows) {
        String uploadid = row['uploadid'].toString();
        Upload upload = await cachedgetupload(uploadid);
        uploads.add(upload);
      }
      
      return uploads;
    } catch (error) {
      debugPrint("Error getting uploads for global tag: $error");
      return <Upload>[];
    }
  }

  /// Get uploads for global tag upper than specific ID
  Future<List<Upload>> getuploadsforglobaltagupperthan(
      String globaltagid, String upperid, int limit) async {
    try {
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest",
        scope: "fr0gsitetest",
        table: "withthistag",
        indexPosition: "2", 
        keyType: "i64",
        lowerBound: globaltagid,
        upperBound: upperid,
        limit: limit,
        reverse: true,
      );

      List<Upload> uploads = [];
      for (var row in rows) {
        String uploadid = row['uploadid'].toString();
        Upload upload = await cachedgetupload(uploadid);
        uploads.add(upload);
      }
      
      return uploads;
    } catch (error) {
      debugPrint("Error getting uploads for global tag upper than: $error");
      return <Upload>[];
    }
  }

  /// Get uploads from specific user
  Future<List<Upload>> getuploadsfromuser(String username, int limit) async {
    try {
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest",
        scope: "fr0gsitetest",
        table: "useruploads",
        indexPosition: "2",
        keyType: "name",
        lowerBound: username,
        upperBound: username,
        limit: limit,
        reverse: true,
      );

      List<Upload> uploads = [];
      for (var row in rows) {
        String uploadidString = row['uploadid'].toString();
        Upload upload = await cachedgetupload(uploadidString);
        uploads.add(upload);
      }
      
      return uploads;
    } catch (error) {
      debugPrint("Error getting uploads from user: $error");
      return <Upload>[];
    }
  }

  /// Get uploads from user lower than specific ID
  Future<List<Upload>> getuploadsfromuserlowerthan(
      String username, String uploadid, int limit) async {
    try {
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest",
        scope: "fr0gsitetest", 
        table: "useruploads",
        indexPosition: "2",
        keyType: "name",
        lowerBound: username,
        upperBound: uploadid,
        limit: limit,
        reverse: true,
      );

      List<Upload> uploads = [];
      for (var row in rows) {
        String uploadidString = row['uploadid'].toString();
        Upload upload = await cachedgetupload(uploadidString);
        uploads.add(upload);
      }
      
      return uploads;
    } catch (error) {
      debugPrint("Error getting uploads from user lower than: $error");
      return <Upload>[];
    }
  }

  /// Get uploads from user upper than specific ID
  Future<List<Upload>> getuploadsfromuserupperthan(
      String username, String uploadid, int limit) async {
    try {
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest",
        scope: "fr0gsitetest",
        table: "useruploads", 
        indexPosition: "2",
        keyType: "name",
        lowerBound: uploadid,
        upperBound: username,
        limit: limit,
        reverse: false,
      );

      List<Upload> uploads = [];
      for (var row in rows) {
        String uploadidString = row['uploadid'].toString();
        Upload upload = await cachedgetupload(uploadidString);
        uploads.add(upload);
      }
      
      return uploads;
    } catch (error) {
      debugPrint("Error getting uploads from user upper than: $error");
      return <Upload>[];
    }
  }

  /// Get favorite uploads of user
  Future<List<FavoriteUpload>> getfavoriteuploadsofuser(String username) async {
    try {
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest",
        scope: username,
        table: "favorites",
        limit: 100,
        reverse: true,
      );

      return rows.map((row) => FavoriteUpload.fromJson(row)).toList();
    } catch (error) {
      debugPrint("Error getting favorite uploads: $error");
      return <FavoriteUpload>[];
    }
  }

  /// Add upload to favorites
  Future<bool> addfavoriteupload(String uploadid) async {
    // Note: Implementation would use action helpers from actionlist.dart
    debugPrint("Adding upload to favorites: $uploadid");
    return false; // Placeholder
  }

  /// Remove upload from favorites
  Future<bool> deletefavoriteupload(String uploadid) async {
    // Note: Implementation would use action helpers from actionlist.dart
    debugPrint("Removing upload from favorites: $uploadid");
    return false; // Placeholder
  }
}
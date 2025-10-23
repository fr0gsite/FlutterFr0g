import 'package:fr0gsite/services/chainactions_base.dart';
import 'package:fr0gsite/datatypes/userconfig.dart';
import 'package:fr0gsite/datatypes/rewardcalc.dart';
import 'package:fr0gsite/datatypes/usersubscription.dart';
import 'package:fr0gsite/datatypes/truster.dart';
import 'package:fr0gsite/datatypes/blockchainnode.dart';
import 'package:eosdart/eosdart.dart';
import 'package:flutter/foundation.dart';

/// Service for user management operations corresponding to user_management.cpp
class UserService extends ChainActionsBase {
  
  /// Check user credentials for authentication
  Future<bool> checkusercredentials(
      String usernamecheck, String keystring, String permission) async {
    try {
      Blockchainnode node = chooseNode();
      EOSClient client = EOSClient(node.getfullurl, node.apiversion);
      
      Account account = await client.getAccount(usernamecheck);
      
      for (var i = 0; i < account.permissions!.length; i++) {
        if (account.permissions![i].permName == permission) {
          for (var j = 0; j < account.permissions![i].requiredAuth!.keys!.length; j++) {
            if (account.permissions![i].requiredAuth!.keys![j].key == keystring) {
              return true;
            }
          }
        }
      }
      return false;
    } catch (error) {
      debugPrint("Error checking user credentials: $error");
      return false;
    }
  }

  /// Get account information from blockchain
  Future<Account> getaccountinfo(String username) async {
    try {
      Blockchainnode node = chooseNode();
      EOSClient client = EOSClient(node.getfullurl, node.apiversion);
      return await client.getAccount(username);
    } catch (error) {
      debugPrint("Error getting account info: $error");
      rethrow;
    }
  }

  /// Get user configuration from blockchain table
  Future<UserConfig> getuserconfig(String username) async {
    try {
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest",
        scope: "fr0gsitetest", 
        table: "userconfigs",
        lowerBound: username,
        upperBound: username,
        limit: 1,
      );

      if (rows.isNotEmpty) {
        return UserConfig.fromJson(rows[0]);
      } else {
        // Return default user config if not found
        return UserConfig.dummy();
      }
    } catch (error) {
      debugPrint("Error getting user config: $error");
      return UserConfig.dummy();
    }
  }

  /// Get reward token information for user
  Future<RewardCalc> getrewardtokeninfo(String username) async {
    try {
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest",
        scope: "fr0gsitetest",
        table: "rewardcalcs", 
        lowerBound: username,
        upperBound: username,
        limit: 1,
      );

      if (rows.isNotEmpty) {
        // Parse RewardCalc from JSON manually since no fromJson method exists
        var data = rows[0];
        return RewardCalc(
          data['totalsupplyFAME'] ?? 1.0,
          data['totalsupplyTRUST'] ?? 1.0, 
          data['totalsupplyACT'] ?? 1.0,
          data['usersupplyFAME'] ?? 0.0,      
          data['usersupplyTRUST'] ?? 0.0,
          data['usersupplyACT'] ?? 0.0,
          data['cbasedsystemtokens'] ?? 0.0,
        );
      } else {
        return RewardCalc(1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0);
      }
    } catch (error) {
      debugPrint("Error getting reward token info: $error");
      return RewardCalc(1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0);
    }
  }

  /// Set user profile information
  Future<bool> setuserprofile(
      String autor,
      String profilepicipfshash,
      String coverpicipfshash,
      String description,
      String displayname,
      String website,
      String location) async {
    
    // Note: Implementation would use action helpers from actionlist.dart
    // This is a placeholder for the actual implementation
    debugPrint("Setting user profile for $autor");
    return false; // Placeholder
  }

  /// Apply for truster role
  Future<bool> applyfortrusterrole(String autor) async {
    // Note: Implementation would use action helpers from actionlist.dart
    debugPrint("Applying for truster role: $autor");
    return false; // Placeholder
  }

  /// Check if user is following another user
  Future<bool> isuserfollowinguser(
      String username, String usernametofollow) async {
    try {
      // Following the original pattern from chainactions.dart
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest", // AppConfig.maincontract
        scope: username,
        table: "usersubscrip",
        limit: 100,
      );

      if (rows.isEmpty) {
        return false;
      } else {
        if (rows[0]['username'] == usernametofollow) {
          return true;
        } else {
          return false;
        }
      }
    } catch (error) {
      debugPrint("Error checking user following: $error");
      return false;
    }
  }

  /// Get user subscriptions (who user is following)
  Future<List<Usersubscription>> getusersubscriptions(String username) async {
    try {
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest", // AppConfig.maincontract
        scope: username,
        table: "usersubscrip",
        limit: 200,
        reverse: true,
      );

      List<Usersubscription> subscriptions = rows
          .map((row) => Usersubscription.fromJson(row))
          .toList();

      return subscriptions;
    } catch (error) {
      debugPrint("Error getting user subscriptions: $error");
      return <Usersubscription>[];
    }
  }

  /// Follow a user
  Future<bool> followuser(String usernametofollow) async {
    // Note: Implementation would use action helpers from actionlist.dart
    debugPrint("Following user: $usernametofollow");
    return false; // Placeholder
  }

  /// Unfollow a user  
  Future<bool> unfollowuser(String usernametounfollow) async {
    // Note: Implementation would use action helpers from actionlist.dart
    debugPrint("Unfollowing user: $usernametounfollow");
    return false; // Placeholder
  }

  /// Get list of trusters
  Future<List<Truster>> gettrusters() async {
    try {
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest",
        scope: "fr0gsitetest",
        table: "trusters",
        limit: 100,
      );

      return rows.map((row) => Truster.fromJson(row)).toList();
    } catch (error) {
      debugPrint("Error getting trusters: $error");
      return <Truster>[];
    }
  }

  /// Get specific truster information
  Future<Truster> gettruster(String trustername) async {
    try {
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest",
        scope: "fr0gsitetest",
        table: "trusters",
        lowerBound: trustername,
        upperBound: trustername,
        limit: 1,
      );

      if (rows.isNotEmpty) {
        return Truster.fromJson(rows[0]);
      } else {
        return Truster.dummy();
      }
    } catch (error) {
      debugPrint("Error getting truster: $error");
      return Truster.dummy();
    }
  }
}
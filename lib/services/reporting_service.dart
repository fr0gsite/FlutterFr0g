import 'package:fr0gsite/services/chainactions_base.dart';
import 'package:fr0gsite/datatypes/report.dart';
import 'package:fr0gsite/datatypes/reportstatus.dart';
import 'package:fr0gsite/datatypes/reportvotes.dart';
import 'package:fr0gsite/datatypes/blacklistentry.dart';
import 'package:flutter/foundation.dart';

/// Service for reporting system operations corresponding to reporting_system.cpp
class ReportingService extends ChainActionsBase {

  /// Add a new report
  Future<bool> addreport(String autor, int typ, int contentid, int violatedrule, String reporttext) async {
    // Note: Implementation would use action helpers from actionlist.dart
    debugPrint("Adding report by $autor for content $contentid: $reporttext");
    return false; // Placeholder
  }

  /// Report upload with community
  Future<bool> reportuploadwithcommunity(ReportStatus report) async {
    // Note: Implementation would use action helpers from actionlist.dart
    debugPrint("Reporting upload with community: ${report.contentid}");
    return false; // Placeholder
  }

  /// Get all reports
  Future<List<Report>> getreports() async {
    try {
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest",
        scope: "fr0gsitetest",
        table: "reports",
        limit: 100,
        reverse: true,
      );

      return rows.map((row) => Report.fromJson(row)).toList();
    } catch (error) {
      debugPrint("Error getting reports: $error");
      return <Report>[];
    }
  }

  /// Get specific report by ID
  Future<Report> getreport(String reportid) async {
    try {
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest",
        scope: "fr0gsitetest",
        table: "reports",
        lowerBound: reportid,
        upperBound: reportid,
        limit: 1,
      );

      if (rows.isNotEmpty) {
        return Report.fromJson(rows[0]);
      } else {
        return Report(
          reportid: 0,
          status: 0,
          id: 0,
          type: 0,
          reportername: "",
          violatedrule: 0,
          reporttext: "",
          reporttime: DateTime.now(),
          numberoftrusters: 0,
          outstandingvotes: 0,
          voteweight: 0,
          json: "",
        );
      }
    } catch (error) {
      debugPrint("Error getting report: $error");
      return Report(
        reportid: 0,
        status: 0,
        id: 0,
        type: 0,
        reportername: "",
        violatedrule: 0,
        reporttext: "",
        reporttime: DateTime.now(),
        numberoftrusters: 0,
        outstandingvotes: 0,
        voteweight: 0,
        json: "",
      );
    }
  }

  /// Get report votes for a specific report
  Future<List<ReportVotes>> getreportvotes(String reportid) async {
    try {
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest",
        scope: "fr0gsitetest",
        table: "reportvotes",
        indexPosition: "2",
        keyType: "i64", 
        lowerBound: reportid,
        upperBound: reportid,
        limit: 100,
      );

      return rows.map((row) => ReportVotes.fromJson(row)).toList();
    } catch (error) {
      debugPrint("Error getting report votes: $error");
      return <ReportVotes>[];
    }
  }

  /// Truster vote on a report
  Future<bool> trustervote(String reportid, int vote) async {
    // Note: Implementation would use action helpers from actionlist.dart
    debugPrint("Truster voting on report $reportid with vote $vote");
    return false; // Placeholder
  }

  /// Get blacklist entries
  Future<List<BlacklistEntry>> getblacklist() async {
    try {
      List<dynamic> rows = await queryTable(
        contract: "fr0gsitetest",
        scope: "fr0gsitetest",
        table: "blacklist",
        limit: 100,
      );

      return rows.map((row) => BlacklistEntry.fromJson(row)).toList();
    } catch (error) {
      debugPrint("Error getting blacklist: $error");
      return <BlacklistEntry>[];
    }
  }
}
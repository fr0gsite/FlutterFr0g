import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/report.dart';

class TrusterStatus with ChangeNotifier {
  List<Report> reports = [];
  DateTime lastReportList = DateTime.now();
  Timer? timer;
  bool _isTimerRunning = false;

  void startTrusterStatus() {
    // Ensure only one timer instance runs (singleton pattern)
    if (_isTimerRunning) {
      //Truster status timer already running, skipping start
      return;
    }

    // Starting truster status refresh timer
    _isTimerRunning = true;
    refreshReports();
    timer = Timer.periodic(const Duration(minutes: 2), (timer) {
      refreshReports();
    });
  }

  void stopTrusterStatus() {
    if (timer != null) {
      timer?.cancel();
      timer = null;
      _isTimerRunning = false;
    }
  }

  bool get isTimerRunning => _isTimerRunning;

  void restartTrusterStatus() {
    stopTrusterStatus();
    startTrusterStatus();
  }

  void addReport(Report report) {
    reports.add(report);
  }

  void removeReport(Report report) {
    reports.remove(report);
  }

  List<Report> getReports() {
    return reports;
  }

  void clearReports() {
    reports.clear();
  }

  Future<List<Report>> getReportsAsync() async {
    Chainactions chainactions = Chainactions();
    reports = await chainactions.getreports().catchError((error) {
      debugPrint("Error fetching reports: $error");
      return <Report>[];
    });
    return reports;
  }

  Future<void> refreshReports() async {
    reports = await getReportsAsync();
    lastReportList = DateTime.now();
  }

  @override
  void dispose() {
    stopTrusterStatus();
    super.dispose();
  }
}

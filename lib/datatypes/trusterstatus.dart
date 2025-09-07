import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/report.dart';

class TrusterStatus with ChangeNotifier {

  List<Report> reports = [];
  DateTime lastReportList = DateTime.now();
  Timer? timer;

  void startTrusterStatus() {
    refreshReports();
    timer = Timer.periodic(const Duration(minutes: 2), (timer) {
      refreshReports();
    });
  }

  void stopTrusterStatus() {
    timer?.cancel();
    timer = null;
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
}
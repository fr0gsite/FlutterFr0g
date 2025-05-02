import 'dart:convert';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/reportstatus.dart';
import 'package:fr0gsite/datatypes/report.dart';
import 'package:fr0gsite/datatypes/reportvotes.dart';
import 'package:fr0gsite/datatypes/truster.dart';
import 'package:fr0gsite/nameconverter.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:eosdart/eosdart.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ReportActions {
  Future<bool> addreport(String autor, int typ, int contentid, int violatedrule, String reporttext) {
    List<Action> actions = [
      Action()
        ..account = AppConfig.maincontract
        ..name = "addreport"
        ..authorization = Chainactions().getauth()
        ..data = {
          "autor": autor,
          "typ": typ,
          "id": contentid,
          "violatedrule": violatedrule,
          "reporttext": reporttext,
        }
    ];
    return Chainactions().transactionHandler(actions);
  }

  Future<bool> reportuploadwithcommunity(ReportStatus report) async {
    var url = Uri.parse(AppConfig.reportnodes.first.getfullurl);
    var requestBody = jsonEncode({
      "rule": report.selectedrule.toString(),
      "type": report.reporttype.toString(),
      "contentid" : report.contentid.toString(),
      "text": report.reporttext.toString(),
    });

    try {
      var response = await http.post(url, body: requestBody, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<List<Truster>> gettrusters() async {
    var response = await Chainactions().geteosclient().getTableRows(
        AppConfig.maincontract, AppConfig.maincontract, 'trusters',
        limit: AppConfig.maxtrusterlist, reverse: true, json: true);
    List<Truster> trusterlist = [];
    for (var index = 0; index < response.length; index++) {
      trusterlist.add(Truster.fromJson(response[index]));
    }
    return trusterlist;
  }

  Future<Truster> gettruster(String trustername) async {
    var response = await Chainactions().geteosclient().getTableRows(
        AppConfig.maincontract, AppConfig.maincontract, 'trusters',
        limit: 1, json: true, lower: NameConverter.nameToUint64(trustername).toString(), upper: NameConverter.nameToUint64(trustername).toString());
    if (response.isEmpty) {
      return Truster.dummy();
    }
    return Truster.fromJson(response[0]);
  }

  Future<List<Report>> getreports() async {
    var response = await Chainactions().geteosclient().getTableRows(
      AppConfig.maincontract, AppConfig.maincontract, 'reports',limit: 10000, reverse: true, json: true);
    List<Report> reportlist = [];
    if (response.isNotEmpty) {
      for (var index = 0; index < response.length; index++) {
        reportlist.add(Report.fromJson(response[index]));
      }
    }
    return reportlist;
  }

  Future<Report> getreport(String reportid) async {
    var response = await Chainactions().geteosclient().getTableRows(
        AppConfig.maincontract, AppConfig.maincontract, 'reports',
        limit: 1, json: true, lower: reportid, upper: reportid);
    if (response.isEmpty) {
      throw "Report not found";
    }
    return Report.fromJson(response[0]);
  }

  Future<List<ReportVotes>> getreportvotes(String reportid) async {
    var response = await Chainactions().geteosclient().getTableRows(
        AppConfig.maincontract, reportid, 'reportvotes',
        limit: 100, reverse: true, json: true);
    List<ReportVotes> reportvoteslist = [];
    for (var index = 0; index < response.length; index++) {
      reportvoteslist.add(ReportVotes.fromJson(response[index]));
    }
    return reportvoteslist;
  }
}

import 'package:flutter/widgets.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/statistics.dart';

class StatisticActions {


    Future<List<Statistics>> getglobalstatistics() async {      
    debugPrint("Requesting global statistics");
    var result = await Chainactions().geteosclient().getTableRows(
        AppConfig.maincontract, "0", 'statistics',
        limit: 100,
        reverse: false,
        json: true,);
    List<Statistics> statistics = [];
    for (var item in result) {
      statistics.add(Statistics.fromJson(item));
    }
    return statistics;
    
  }

  Future<Statistics> getstatisticforday(DateTime day) async {
    debugPrint("Requesting statistics for day: $day");
    // Scope is day since 1970. For exmaple 2025-02-22 -> 20141
    int scope = day.millisecondsSinceEpoch ~/ 86400000;
    var result = await Chainactions().geteosclient().getTableRows(
        AppConfig.maincontract, scope.toString(), 'statistics',
        limit: 100,
        reverse: false,
        json: true,);
    return Statistics.fromJson(result[0]);
  }

}
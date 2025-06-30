import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fr0gsite/chainactions/statisticactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/report.dart';
import 'package:fr0gsite/datatypes/statistics.dart';
import 'dashboard_card.dart';
// Für den einfachen Zugriff auf math Funktionen

class ReportStatusPieChart extends StatefulWidget {
  const ReportStatusPieChart({super.key});

  @override
  State<ReportStatusPieChart> createState() => _ReportStatusPieChartState();
}

class _ReportStatusPieChartState extends State<ReportStatusPieChart>
    with SingleTickerProviderStateMixin {
  List<Report> reportlist = [];
  late Future globalstatistics;

  // AnimationController für die Rotation
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    globalstatistics = loadreportdata();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        children: [
          const Text("Action Pie", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Expanded(
            child: FutureBuilder(
            future: globalstatistics,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data.isNotEmpty) {
                  return AnimatedBuilder(
                        animation: _rotationController,
                        builder: (context, child) {
                          final rotationDegrees = 360 * _rotationController.value;
          
                          return PieChart(
                            PieChartData(
                              startDegreeOffset: rotationDegrees,
                              centerSpaceRadius: 80,
                              sections: [
                                PieChartSectionData(
                                  color: AppColor.uploadcolor,
                                  value: snapshot.data[1].int64number.toDouble(),
                                  title: "${snapshot.data[1].text} \n ${snapshot.data[1].int64number.toString()}",
                                  radius: 50,
                                ),
                                PieChartSectionData(
                                  color: AppColor.commentcolor,
                                  value: snapshot.data[2].int64number.toDouble(),
                                  title: "${snapshot.data[2].text} \n ${snapshot.data[2].int64number.toString()}",
                                  radius: 50,
                                ),
                                PieChartSectionData(
                                  color: AppColor.tagcolor,
                                  value: snapshot.data[3].int64number.toDouble(),
                                  title: "${snapshot.data[3].text} \n ${snapshot.data[3].int64number.toString()}",
                                  radius: 50,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                } else {
                  return const Center(child: Text('No data available'));
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ],
      ));
  }

  Future<List<Statistics>> loadreportdata() async {
    List<Statistics> statistics = await StatisticActions().getglobalstatistics();
    return statistics;
  }
}


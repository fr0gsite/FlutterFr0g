import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/report.dart';

class StatisticReportStatusPieDiagramm extends StatefulWidget {
  const StatisticReportStatusPieDiagramm({super.key});

  @override
  State<StatisticReportStatusPieDiagramm> createState() => _StatisticReportStatusPieDiagrammState();
}

class _StatisticReportStatusPieDiagrammState extends State<StatisticReportStatusPieDiagramm> {
  List<Report> reportlist = [];

  @override
  void initState() {
    super.initState();
    loadreportdata();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: AppColor.niceblack,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(value: 40, title: '40%', color: Colors.blue),
              PieChartSectionData(value: 30, title: '30%', color: Colors.red),
              PieChartSectionData(value: 30, title: '30%', color: Colors.green),
            ],
          ),
        ),
      ),
    );
  }

  void loadreportdata(){
    Chainactions().getreports().then((value) {
      setState(() {
        reportlist = value;
      });
    });
  }
}
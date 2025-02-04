import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/widgets/status/dashboard/views/statisticreportstatuspiediagramm.dart';
import 'package:fr0gsite/widgets/status/dashboard/views/statistictruster.dart';

class DashboardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 600;
          return Container(
            color: AppColor.nicegrey,
            child: Center(
              child: GridView.count(
                crossAxisCount: isWide ? constraints.maxWidth ~/ 600 : 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                padding: const EdgeInsets.all(10),
                children: [
                  const StatisticTrusterList(),
                  const StatisticReportStatusPieDiagramm(),
                  buildBarChartSegment(),
                  buildTableSegment(),
                ],
              ),
            ),
          );
        },
    );
  }


  Widget buildTableSegment() {
    return Card(
      elevation: 4,
      color: AppColor.niceblack,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Wert')),
          ],
          rows: const [
            DataRow(cells: [DataCell(Text('Item 1')), DataCell(Text('10'))]),
            DataRow(cells: [DataCell(Text('Item 2')), DataCell(Text('20'))]),
            DataRow(cells: [DataCell(Text('Item 3')), DataCell(Text('30'))]),
          ],
        ),
      ),
    );
  }

  Widget buildPieChartSegment() {
    return Card(
      elevation: 4,
      color: AppColor.niceblack,
      child: Padding(
        padding: const EdgeInsets.all(10),
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

  Widget buildBarChartSegment() {
    return Card(
      elevation: 4,
      color: AppColor.niceblack,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: BarChart(
          BarChartData(
            barGroups: [
              BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 10, color: Colors.blue)]),
              BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 20, color: Colors.red)]),
              BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 30, color: Colors.green)]),
            ],
          ),
        ),
      ),
    );
  }
}

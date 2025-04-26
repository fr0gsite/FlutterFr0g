import 'package:flutter/material.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/report.dart';
import 'package:fr0gsite/widgets/truster/trustervotereportview.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Angenommen, Report und getreports() sind bereits importiert

class ReportsWidget extends StatelessWidget {
  const ReportsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.reports),
          bottom: TabBar(
            tabs: [
              Tab(text: AppLocalizations.of(context)!.forme),
              Tab(text: AppLocalizations.of(context)!.allreports),
              Tab(text: AppLocalizations.of(context)!.urgentreport),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                // Filterfunktion hier implementieren
              },
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            ReportsTable(mode: "forme"),
            ReportsTable(mode: "all"),
            ReportsTable(mode: "urgent"),
          ],
        ),
      ),
    );
  }
}

class ReportsTable extends StatelessWidget {
  final String mode;

  const ReportsTable({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Report>>(
      future: Chainactions().getreports(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final reports = snapshot.data!;
        String username = Provider.of<GlobalStatus>(context, listen: false).username;
        
        var filteredReports = reports;
        switch (mode) {
          case "forme":
            filteredReports = reports.where((r) => r.reportername == username).toList();
            break;
          case "all":
            filteredReports = reports;
            break;
          case "urgent":
            filteredReports = reports.where((report) => report.reporttime.isBefore(DateTime.now().subtract(Duration(hours: 23)))).toList();
            break;
          default:
            filteredReports = reports;
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              const DataColumn(label: Text('Nr')),
              DataColumn(label: Text(AppLocalizations.of(context)!.rule)),
              DataColumn(label: Text(AppLocalizations.of(context)!.upload)),
              DataColumn(label: Text(AppLocalizations.of(context)!.status)),
            ],
            rows: filteredReports.map((report) {
              return DataRow(
                cells: [
                  DataCell(
                    InkWell(
                      child: Text('${report.reportid}', style: const TextStyle(color: Colors.blue)),
                      onTap: () {
                        // Open TrusterVoteReportView
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TrusterVoteReportView(reportid: report.reportid)));
                      },
                    ),
                  ),
                  DataCell(Text('${report.violatedrule}')),
                  DataCell(Row(
                    children: [
                      const Icon(Icons.insert_drive_file),
                      const SizedBox(width: 4),
                      InkWell(
                        child: Text('${report.id}', style: const TextStyle(color: Colors.blue)),
                        onTap: () {
                          // Link zum Upload
                        },
                      ),
                    ],
                  )),
                  DataCell(Row(
                    children: [
                      Text('${report.status}'),
                      const SizedBox(width: 10),
                      Text('${report.outstandingvotes} / ${report.numberoftrusters }'),
                    ],
                  )),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
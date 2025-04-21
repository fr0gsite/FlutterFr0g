import 'package:flutter/material.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/report.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Angenommen, Report und getreports() sind bereits importiert

class ReportsWidget extends StatelessWidget {
  const ReportsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.reports),
          bottom: TabBar(
            tabs: [
              Tab(text: AppLocalizations.of(context)!.forme),
              Tab(text: AppLocalizations.of(context)!.allreports),
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
            ReportsTable(forMe: true),
            ReportsTable(forMe: false),
          ],
        ),
      ),
    );
  }
}

class ReportsTable extends StatelessWidget {
  final bool forMe;

  const ReportsTable({super.key, required this.forMe});

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
        final filteredReports = forMe
            ? reports.where((r) => r.reportername == username).toList() // ersetzen!
            : reports;

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
                        // Link zu Report-Detail
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
                      Text('${report.numberoftrusters} / ${report.outstandingvotes}'),
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

import 'package:flutter/material.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/report.dart';
import 'package:fr0gsite/ipfsactions.dart';
import 'package:fr0gsite/widgets/truster/trustervotereportview.dart';
import 'package:provider/provider.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';
import 'dart:typed_data';

// Angenommen, Report und getreports() sind bereits importiert

class UploadThumb extends StatefulWidget {
  final int uploadId;
  const UploadThumb({super.key, required this.uploadId});

  @override
  State<UploadThumb> createState() => _UploadThumbState();
}

class _UploadThumbState extends State<UploadThumb> {
  late Future<Uint8List> _thumbFuture;

  @override
  void initState() {
    super.initState();
    _thumbFuture = _loadThumb();
  }

  Future<Uint8List> _loadThumb() async {
    try {
      final upload = await Chainactions().getupload(widget.uploadId.toString());
      return await IPFSActions.fetchipfsdata(context, upload.thumbipfshash);
    } catch (_) {
      return Uint8List(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _thumbFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData &&
            snapshot.data!.isNotEmpty) {
          return Image.memory(
            snapshot.data!,
            width: 24,
            height: 24,
            fit: BoxFit.cover,
          );
        }
        return const Icon(Icons.insert_drive_file);
      },
    );
  }
}

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
            filteredReports = reports.where((report) => report.reporttime.isBefore(DateTime.now().subtract(const Duration(hours: 23)))).toList();
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
              DataColumn(label: Text(AppLocalizations.of(context)!.votes)),
              const DataColumn(label: Text("Time Left")),
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
                  DataCell(Tooltip(
                    message: getrule(report.type, report.violatedrule, context).ruleName,
                    child: Text('${report.violatedrule}'))),
                  DataCell(Row(
                    children: [
                      UploadThumb(uploadId: report.id),
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
                      Text('${report.outstandingvotes} / ${report.numberoftrusters }'),
                    ],
                  )),
                  // Show how much time is left for the report to be voted on
                  
                 DataCell(
                  Builder(
                    builder: (context) {
                      final now = DateTime.now();
                      final deadline = report.reporttime.add(const Duration(hours: 24));
                      final totalDuration = deadline.difference(report.reporttime).inSeconds;
                      final elapsedDuration = now.difference(report.reporttime).inSeconds;
                      final progress = (elapsedDuration / totalDuration).clamp(0.0, 1.0);
                      final timeLeft = deadline.difference(now);

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.green,
                            color: timeLeft <= const Duration(hours: 2) ? Colors.red : Colors.grey,
                            minHeight: 10,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${(elapsedDuration / 3600).round()} / 24 h',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
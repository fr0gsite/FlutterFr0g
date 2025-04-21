import 'package:flutter/material.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';

import 'package:fr0gsite/datatypes/report.dart';

class TrusterVoteReportView extends StatefulWidget {
  final int reportid;

  const TrusterVoteReportView({super.key, required this.reportid});

  @override
  State<TrusterVoteReportView> createState() => _TrusterVoteReportViewState();
}

class _TrusterVoteReportViewState extends State<TrusterVoteReportView> {
  late Future<Report> futureReport;

  @override
  void initState() {
    super.initState();
    futureReport = Chainactions().getreport(widget.reportid.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report Vote')),
      body: FutureBuilder<Report>(
        future: futureReport,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Fehler: ${snapshot.error}'));
          }

          final report = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              children: [
                Row(
                  children: [
                    Text('Nr. ${report.reportid}', style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      color: Colors.grey.shade300,
                      child: Text(statusText(report.status)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey.shade400,
                      child: const Center(child: Text('Thumb')),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Reported by: ${report.reportername}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text('USER: ${report.id}'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: 200,
                  color: Colors.grey.shade200,
                  child: const Center(child: Text('Upload', style: TextStyle(fontSize: 24))),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text('Regel: '),
                    Text(
                      '"${report.violatedrule}"',
                      style: const TextStyle(decoration: TextDecoration.underline, color: Colors.blue),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {},
                      child: const Text('Verstoß'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: () {},
                      child: const Text('In Ordnung'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Voting Übersicht (Demo-Daten):'),
                Table(
                  border: TableBorder.all(),
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(2),
                  },
                  children: [
                    const TableRow(children: [
                      Padding(padding: EdgeInsets.all(8.0), child: Text('Truster Name')),
                      Padding(padding: EdgeInsets.all(8.0), child: Text('Reaction Time')),
                      Padding(padding: EdgeInsets.all(8.0), child: Text('Vote')),
                    ]),
                    const TableRow(children: [
                      Padding(padding: EdgeInsets.all(8.0), child: Text('testuser')),
                      Padding(padding: EdgeInsets.all(8.0), child: Text('outstanding')),
                      Padding(padding: EdgeInsets.all(8.0), child: Text('none')),
                    ]),
                    TableRow(children: [
                      const Padding(padding: EdgeInsets.all(8.0), child: Text('User1')),
                      const Padding(padding: EdgeInsets.all(8.0), child: Text('4h')),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text('Vote'),
                        ),
                      ),
                    ]),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String statusText(int status) {
    switch (status) {
      case 0:
        return 'Offen';
      case 1:
        return 'Geschlossen';
      case 2:
        return 'Dringend';
      default:
        return 'Unbekannt';
    }
  }
}

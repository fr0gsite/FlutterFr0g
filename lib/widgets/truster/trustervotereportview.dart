import 'package:flutter/material.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';

import 'package:fr0gsite/datatypes/report.dart';
import 'package:fr0gsite/datatypes/reportvotes.dart';
import 'package:fr0gsite/datatypes/rule.dart';
import 'package:fr0gsite/datatypes/rules.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:fr0gsite/nameconverter.dart';
import 'package:fr0gsite/widgets/cube/cube.dart';
import 'package:fr0gsite/widgets/postviewer/swipeitem.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';

class TrusterVoteReportView extends StatefulWidget {
  final int reportid;

  const TrusterVoteReportView({super.key, required this.reportid});

  @override
  State<TrusterVoteReportView> createState() => _TrusterVoteReportViewState();
}

class _TrusterVoteReportViewState extends State<TrusterVoteReportView> {
  late Future<Report> futureReport;
  late Future<Upload> futureUpload;
  late Future<List<ReportVotes>> futureReportVotes;

  // Rules
  // Punishment for breaking the rules

  @override
  void initState() {
    super.initState();
    futureReport = Chainactions().getreport(widget.reportid.toString());
    futureReportVotes = Chainactions().getreportvotes(widget.reportid.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.reportvote)),
      body: FutureBuilder<Report>(
        future: futureReport,
        builder: (context, reportSnapshot) {
          if (reportSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (reportSnapshot.hasError) {
            return Center(child: Text('Fehler: ${reportSnapshot.error}'));
          }

          final report = reportSnapshot.data!;
          futureUpload = Chainactions().getupload(report.id.toString());
          return FutureBuilder<Upload>(
            future: futureUpload,
            builder: (context, uploadSnapshot) {
              if (uploadSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (uploadSnapshot.hasError) {
                return Center(child: Text('Fehler: ${uploadSnapshot.error}'));
              }

              final upload = uploadSnapshot.data!;

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
                          color: statusColor(report.status),
                          child: Text(statusText(report.status, context)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: 180,
                            height: 180,
                            color: Colors.grey.shade400,
                            child: Cube(upload: upload),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${AppLocalizations.of(context)!.reportedby} ${NameConverter.uint64ToName(BigInt.parse(report.reportername))}", style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text("${AppLocalizations.of(context)!.uploadedby} ${upload.autor}"),
                                Text('${AppLocalizations.of(context)!.rule}: ${report.violatedrule}: ${getrule(report.type,report.violatedrule, context)}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          onPressed: () {},
                          child: Text(AppLocalizations.of(context)!.violation),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          onPressed: () {},
                          child: Text(AppLocalizations.of(context)!.inlinewiththerules),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(AppLocalizations.of(context)!.votingoverview, style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 12),
                    FutureBuilder<List<ReportVotes>>(
                      future: futureReportVotes,
                      builder: (context, votesSnapshot) {
                        if (votesSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (votesSnapshot.hasError) {
                          return Center(child: Text('${AppLocalizations.of(context)!.error}: ${votesSnapshot.error}'));
                        }

                        final votes = votesSnapshot.data!;

                        return SizedBox(
                          width: double.infinity,
                          child: Table(
                            border: TableBorder.all(),
                            defaultColumnWidth: const FixedColumnWidth(100),
                            children: [
                            TableRow(children: [
                              Padding(padding: const EdgeInsets.all(4.0), child: Text(AppLocalizations.of(context)!.username, style: const TextStyle(fontWeight: FontWeight.bold))),
                              Padding(padding: const EdgeInsets.all(4.0), child: Text(AppLocalizations.of(context)!.vote, style: const TextStyle(fontWeight: FontWeight.bold))),
                            ]),
                            ...votes.map((vote) {
                              return TableRow(children: [
                              Padding(padding: const EdgeInsets.all(4.0), child: Text(NameConverter.uint64ToName(BigInt.parse(vote.trustername)))),
                              Padding(padding: const EdgeInsets.all(4.0), child: Text(votestatus(vote.vote, context))),
                              ]);
                            }),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  String statusText(int status, context) {
    switch (status) {
      case 0:
        return AppLocalizations.of(context)!.open;
      case 1:
        return AppLocalizations.of(context)!.closed;
      case 2:
        return AppLocalizations.of(context)!.urgent;
      default:
        return AppLocalizations.of(context)!.unknown;
    }
  }
  Color statusColor(int status) {
    switch (status) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

  String votestatus(int status, context) {
    switch (status) {
      case 0:
        return AppLocalizations.of(context)!.open;
      case 1:
        return AppLocalizations.of(context)!.inorder;
      case -1:
        return AppLocalizations.of(context)!.violation;
      default:
        return AppLocalizations.of(context)!.unknown;
    }
  }

Rule getrule(int type, violatedrule, context) {
  switch (type) {
    case 1:
      return Rules().getUploadRules(context).firstWhere((element) => element.ruleNr == violatedrule);
    case 2:
      return Rules().getCommentRules(context).firstWhere((element) => element.ruleNr == violatedrule);
    case 3:
      return Rules().getTagRules(context).firstWhere((element) => element.ruleNr == violatedrule);
    default:
      return Rule.dummy();
  }
}

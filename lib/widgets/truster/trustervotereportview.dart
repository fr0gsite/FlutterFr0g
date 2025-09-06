import 'package:flutter/material.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';

import 'package:fr0gsite/datatypes/report.dart';
import 'package:fr0gsite/datatypes/reportvotes.dart';
import 'package:fr0gsite/datatypes/rule.dart';
import 'package:fr0gsite/datatypes/rules.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:fr0gsite/globalnotifications.dart';
import 'package:fr0gsite/nameconverter.dart';
import 'package:fr0gsite/widgets/cube/cube.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class TrusterVoteReportView extends StatefulWidget {
  final int reportid;

  const  TrusterVoteReportView({super.key, required this.reportid});

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

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Row(
                        children: [
                          Text(
                            'Nr. ${report.reportid}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(width: 16),
                          Chip(
                            label: Text(statusText(report.status, context)),
                            backgroundColor: statusColor(report.status),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth > 600;
                          final postViewer = SizedBox(
                            width: 200,
                            height: 200,
                            child: Cube(upload: upload),
                          );
                          final infoColumn = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${AppLocalizations.of(context)!.reportedby} ${NameConverter.uint64ToName(BigInt.parse(report.reportername))}",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text("${AppLocalizations.of(context)!.uploadedby} ${upload.autor}"),
                              const SizedBox(height: 8),
                              Text(
                                '${AppLocalizations.of(context)!.rule}: ${report.violatedrule}: ${getrule(report.type, report.violatedrule, context)}',
                              ),
                            ],
                          );

                          if (isWide) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: Center(child: postViewer)),
                                const SizedBox(width: 24),
                                Expanded(child: infoColumn),
                              ],
                            );
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(child: postViewer),
                                const SizedBox(height: 16),
                                infoColumn,
                              ],
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            onPressed: () {
                            // Implement violation handling
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: AppColor.niceblack,
                                  title: Text(AppLocalizations.of(context)!.confirm),
                                  content: Text("${AppLocalizations.of(context)!.violation}?"),
                                  actions: [
                                    TextButton(
                                      style: TextButton.styleFrom(foregroundColor: Colors.white),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(AppLocalizations.of(context)!.cancel),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(foregroundColor: Colors.white),
                                      onPressed: () {
                                      Chainactions ca = Chainactions();
                                      String username = Provider.of<GlobalStatus>(context, listen: false).username;
                                      String permission = Provider.of<GlobalStatus>(context, listen: false).permission;
                                      ca.setusernameandpermission(username, permission);
                                      debugPrint("Username: $username, Permission: $permission");
                                      ca.trustervote(report.reportid.toString(), 0).then((result) {
                                        if (result) {
                                          Globalnotifications.shownotification(context, "title", "message",  "success");
                                          Navigator.of(context).pop();
                                        }
                                      });
                                    },
                                      child: Text(AppLocalizations.of(context)!.confirm),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(AppLocalizations.of(context)!.violation),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          onPressed: () {
                            showDialog(context: context, builder: (context) {
                              return AlertDialog(
                                backgroundColor: AppColor.niceblack,
                                title: Text(AppLocalizations.of(context)!.confirm),
                                content: Text("${AppLocalizations.of(context)!.inlinewiththerules}?"),
                                actions: [
                                  TextButton(
                                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(AppLocalizations.of(context)!.cancel),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                                    onPressed: () {
                                      Chainactions ca = Chainactions();
                                      String username = Provider.of<GlobalStatus>(context, listen: false).username;
                                      String permission = Provider.of<GlobalStatus>(context, listen: false).permission;
                                      ca.setusernameandpermission(username, permission);
                                      debugPrint("Username: $username, Permission: $permission");
                                      ca.trustervote(report.reportid.toString(), 1).then((result) {
                                        if (result) {
                                          Globalnotifications.shownotification(context, "title", "message",  "success");
                                          Navigator.of(context).pop();
                                        }
                                      });
                                    },
                                    child: Text(AppLocalizations.of(context)!.confirm),
                                  ),
                                ],
                              );
                            });
                          },
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

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: [
                              DataColumn(
                                label: Text(AppLocalizations.of(context)!.username,
                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              DataColumn(
                                label: Text(AppLocalizations.of(context)!.vote,
                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                            rows: votes
                                .map(
                                  (vote) => DataRow(
                                    cells: [
                                      DataCell(Text(NameConverter.uint64ToName(
                                          BigInt.parse(vote.trustername)))),
                                      DataCell(Text(votestatus(vote.vote, context))),
                                    ],
                                  ),
                                )
                                .toList(),
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

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
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColor.niceblack,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withAlpha((0.3 * 255).toInt()), width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha((0.3 * 255).toInt()),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white.withAlpha((0.2 * 255).toInt()), width: 1),
                              ),
                              child: Text(
                                'Nr. ${report.reportid}',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white.withAlpha((0.3 * 255).toInt()), width: 1),
                              ),
                              child: Chip(
                                label: Text(
                                  statusText(report.status, context),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                backgroundColor: statusColor(report.status),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColor.niceblack,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withAlpha((0.3 * 255).toInt()), width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha((0.3 * 255).toInt()),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth > 600;
                            final postViewer = Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white.withAlpha((0.4 * 255).toInt()), width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withAlpha((0.1 * 255).toInt()),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Cube(upload: upload),
                              ),
                            );
                            final infoColumn = Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha((0.05 * 255).toInt()),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white.withAlpha((0.2 * 255).toInt()), width: 1),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withAlpha((0.2 * 255).toInt()),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.blue.withAlpha((0.4 * 255).toInt()), width: 1),
                                    ),
                                    child: Text(
                                      "${AppLocalizations.of(context)!.reportedby} ${NameConverter.uint64ToName(BigInt.parse(report.reportername))}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withAlpha((0.2 * 255).toInt()),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.green.withAlpha((0.4 * 255).toInt()), width: 1),
                                    ),
                                    child: Text(
                                      "${AppLocalizations.of(context)!.uploadedby} ${upload.autor}",
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withAlpha((0.2 * 255).toInt()),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.orange.withAlpha((0.4 * 255).toInt()), width: 1),
                                    ),
                                    child: Text(
                                      '${AppLocalizations.of(context)!.rule} ${report.violatedrule}: ${getrule(report.type, report.violatedrule, context).ruleName} ',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
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
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColor.niceblack,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withAlpha((0.3 * 255).toInt()), width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha((0.3 * 255).toInt()),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.red.withAlpha((0.5 * 255).toInt()), width: 1),
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    elevation: 4,
                                    shadowColor: Colors.red.withAlpha((0.3 * 255).toInt()),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    // Implement violation handling
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: AppColor.niceblack,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                            side: BorderSide(color: Colors.white.withAlpha((0.3 * 255).toInt()), width: 1),
                                          ),
                                          title: Text(
                                            AppLocalizations.of(context)!.confirm,
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                          content: Text(
                                            "${AppLocalizations.of(context)!.violation}?",
                                            style: const TextStyle(color: Colors.white70),
                                          ),
                                          actions: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(color: Colors.white.withAlpha((0.3 * 255).toInt()), width: 1),
                                              ),
                                              child: TextButton(
                                                style: TextButton.styleFrom(foregroundColor: Colors.white),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(AppLocalizations.of(context)!.cancel),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(color: Colors.red.withAlpha((0.5 * 255).toInt()), width: 1),
                                              ),
                                              child: TextButton(
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  backgroundColor: Colors.red.withAlpha((0.2 * 255).toInt()),
                                                ),
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
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Text(AppLocalizations.of(context)!.violation),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(left: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.green.withAlpha((0.5 * 255).toInt()), width: 1),
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    elevation: 4,
                                    shadowColor: Colors.green.withAlpha((0.3 * 255).toInt()),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    showDialog(context: context, builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: AppColor.niceblack,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          side: BorderSide(color: Colors.white.withAlpha((0.3 * 255).toInt()), width: 1),
                                        ),
                                        title: Text(
                                          AppLocalizations.of(context)!.confirm,
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                        content: Text(
                                          "${AppLocalizations.of(context)!.inlinewiththerules}?",
                                          style: const TextStyle(color: Colors.white70),
                                        ),
                                        actions: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Colors.white.withAlpha((0.3 * 255).toInt()), width: 1),
                                            ),
                                            child: TextButton(
                                              style: TextButton.styleFrom(foregroundColor: Colors.white),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(AppLocalizations.of(context)!.cancel),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Colors.green.withAlpha((0.5 * 255).toInt()), width: 1),
                                            ),
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor: Colors.green.withAlpha((0.2 * 255).toInt()),
                                              ),
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
                                          ),
                                        ],
                                      );
                                    });
                                  },
                                  child: Text(AppLocalizations.of(context)!.inlinewiththerules),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColor.niceblack,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withAlpha((0.3 * 255).toInt()), width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha((0.3 * 255).toInt()),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.purple.withAlpha((0.2 * 255).toInt()),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.purple.withAlpha((0.4 * 255).toInt()), width: 1),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.votingoverview,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
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

                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha((0.05 * 255).toInt()),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.white.withAlpha((0.2 * 255).toInt()), width: 1),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      headingRowColor: WidgetStateColor.resolveWith(
                                        (states) => Colors.white.withAlpha((0.1 * 255).toInt()),
                                      ),
                                      border: TableBorder.all(
                                        color: Colors.white.withAlpha((0.2 * 255).toInt()),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      columns: [
                                        DataColumn(
                                          label: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            child: Text(
                                              AppLocalizations.of(context)!.username,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            child: Text(
                                              AppLocalizations.of(context)!.vote,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: votes
                                          .map(
                                            (vote) => DataRow(
                                              color: WidgetStateColor.resolveWith(
                                                (states) => Colors.white.withAlpha((0.02 * 255).toInt()),
                                              ),
                                              cells: [
                                                DataCell(
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: Colors.blue.withAlpha((0.1 * 255).toInt()),
                                                      borderRadius: BorderRadius.circular(4),
                                                      border: Border.all(color: Colors.blue.withAlpha((0.3 * 255).toInt()), width: 1),
                                                    ),
                                                    child: Text(
                                                      NameConverter.uint64ToName(BigInt.parse(vote.trustername)),
                                                      style: const TextStyle(color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                DataCell(
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: vote.vote == 1 
                                                          ? Colors.green.withAlpha((0.1 * 255).toInt())
                                                          : vote.vote == -1 
                                                              ? Colors.red.withAlpha((0.1 * 255).toInt())
                                                              : Colors.grey.withAlpha((0.1 * 255).toInt()),
                                                      borderRadius: BorderRadius.circular(4),
                                                      border: Border.all(
                                                        color: vote.vote == 1 
                                                            ? Colors.green.withAlpha((0.3 * 255).toInt())
                                                            : vote.vote == -1 
                                                                ? Colors.red.withAlpha((0.3 * 255).toInt())
                                                                : Colors.grey.withAlpha((0.3 * 255).toInt()),
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      votestatus(vote.vote, context),
                                                      style: TextStyle(
                                                        color: vote.vote == 1 
                                                            ? Colors.green.shade300
                                                            : vote.vote == -1 
                                                                ? Colors.red.shade300
                                                                : Colors.grey.shade300,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
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

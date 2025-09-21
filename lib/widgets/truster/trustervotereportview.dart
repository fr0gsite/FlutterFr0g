import 'package:flutter/material.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/comment.dart';
import 'package:fr0gsite/datatypes/globaltags.dart';
import 'package:fr0gsite/datatypes/report.dart';
import 'package:fr0gsite/datatypes/reportvotes.dart';
import 'package:fr0gsite/datatypes/rule.dart';
import 'package:fr0gsite/datatypes/rules.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:fr0gsite/globalnotifications.dart';
import 'package:fr0gsite/nameconverter.dart';
import 'package:fr0gsite/widgets/cube/cube.dart';
import 'package:fr0gsite/widgets/home/tagbutton.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class TrusterVoteReportView extends StatefulWidget {
  final Report report;

  const TrusterVoteReportView({super.key, required this.report});

  @override
  State<TrusterVoteReportView> createState() => _TrusterVoteReportViewState();
}

class _TrusterVoteReportViewState extends State<TrusterVoteReportView> {
  Future<Upload>? futureUpload;
  Future<Comment>? futureComment;
  Future<GlobalTags>? futureTag;
  late Future<List<ReportVotes>> futureReportVotes;
  bool _isVoteOverviewExpanded = true;
  bool _uservoted = false;
  bool _userisassignttoreport = false;

  @override
  void initState() {
    super.initState();
    futureReportVotes = Chainactions().getreportvotes(widget.report.reportid.toString());

    // Überprüfe den User-Vote-Status beim Laden
    futureReportVotes.then((votes) {
      if (mounted) {
        String currentUsername = Provider.of<GlobalStatus>(context, listen: false).username;
        setState(() {
          _uservoted = votes.any((vote) => vote.trustername == currentUsername && vote.vote != 0);
          _userisassignttoreport = votes.any((vote) => vote.trustername == currentUsername);
        });
      }
    }).catchError((error) {
      debugPrint("Error loading vote data: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.reportvote)),
      body: Builder(
        builder: (context) {
          final report = widget.report;
          
          // Lade je nach Report-Typ verschiedene Inhalte
          switch (report.type) {
            case 1: // Upload
              futureUpload = Chainactions().getupload(report.id.toString());
              return _buildUploadReport(context, report);
            case 2: // Comment
              futureComment = getcommentbyglobalid(report.id.toString());
              return _buildCommentReport(context, report);
            case 3: // Tag
              futureTag = Chainactions().getglobaltagbyid(report.id.toString());
              return _buildTagReport(context, report);
            default:
              return Center(
                child: Text('Unknown report type: ${report.type}'),
              );
          }
        },
      ),
    );
  }

  /// Builds the UI for upload reports
  Widget _buildUploadReport(BuildContext context, Report report) {
    return FutureBuilder<Upload>(
      future: futureUpload!,
      builder: (context, uploadSnapshot) {
        if (uploadSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }
        if (uploadSnapshot.hasError) {
          return Center(child: Text('Fehler: ${uploadSnapshot.error}'));
        }

        final upload = uploadSnapshot.data!;
        return _buildReportContent(
          context,
          report,
          postViewer: Container(
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
          ),
          contentAuthor: upload.autor,
        );
      },
    );
  }

  /// Builds the UI for comment reports
  Widget _buildCommentReport(BuildContext context, Report report) {
    return FutureBuilder<Comment>(
      future: futureComment!,
      builder: (context, commentSnapshot) {
        if (commentSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }
        if (commentSnapshot.hasError) {
          return Center(child: Text('Fehler: ${commentSnapshot.error}'));
        }

        final comment = commentSnapshot.data!;
        return _buildReportContent(
          context,
          report,
          postViewer: Container(
            width: 400,
            constraints: const BoxConstraints(maxHeight: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.niceblack,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kommentar',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      comment.commentText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          contentAuthor: comment.author,
        );
      },
    );
  }

  /// Builds the UI for tag reports
  Widget _buildTagReport(BuildContext context, Report report) {
    return FutureBuilder<GlobalTags>(
      future: futureTag!,
      builder: (context, tagSnapshot) {
        if (tagSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }
        if (tagSnapshot.hasError) {
          return Center(child: Text('Fehler: ${tagSnapshot.error}'));
        }

        final tag = tagSnapshot.data!;
        return _buildReportContent(
          context,
          report,
          postViewer: Container(
            width: 300,
            height: 150,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.niceblack,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Tag',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TagButton(
                  text: tag.text,
                  globaltagid: tag.globaltagid,
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  heroTag: 'report-tag-${tag.globaltagid}',
                ),
              ],
            ),
          ),
          contentAuthor: 'System', // Tag hat keinen direkten Author
        );
      },
    );
  }

  /// Builds the common report content structure
  Widget _buildReportContent(
    BuildContext context,
    Report report, {
    required Widget postViewer,
    required String contentAuthor,
  }) {
    final now = DateTime.now();
    final deadline = report.reporttime.add(const Duration(hours: 24)).add(now.timeZoneOffset);
    final timeLeft = deadline.difference(now);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Report Header
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
                  const Spacer(),
                  Text(
                    '${AppLocalizations.of(context)!.timeleft}: ${timeLeft.inHours}h ${timeLeft.inMinutes.remainder(60)}m',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Content Section
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
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white.withAlpha((0.3 * 255).toInt()), width: 1),
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
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white.withAlpha((0.3 * 255).toInt()), width: 1),
                          ),
                          child: Text(
                            "${_getContentTypeText(report.type, context)} ${contentAuthor}",
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
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white.withAlpha((0.3 * 255).toInt()), width: 1),
                          ),
                          child: Text(
                            '${AppLocalizations.of(context)!.rule} ${report.violatedrule}: ${getrule(report.type, report.violatedrule, context).ruleName}',
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
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white.withAlpha((0.3 * 255).toInt()), width: 1),
                          ),
                          child: Text(
                            '${AppLocalizations.of(context)!.punishment}: ${getrule(report.type, report.violatedrule, context).rulePunishment}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
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
            
            // Report text
            const SizedBox(height: 16),
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
                  Text(
                    AppLocalizations.of(context)!.reporttext,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    report.reporttext.isEmpty ? AppLocalizations.of(context)!.noreporttext : report.reporttext,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            // Voting Section
            const SizedBox(height: 24),
            _buildVotingSection(context, report),
            
            // Vote Overview
            const SizedBox(height: 20),
            _buildVoteOverview(context),
          ],
        ),
      ),
    );
  }

  /// Builds the voting section
  Widget _buildVotingSection(BuildContext context, Report report) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _uservoted || !_userisassignttoreport ? Colors.black : AppColor.niceblack,
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
      child: !_uservoted ? Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withAlpha(_uservoted ? (0.2 * 255).toInt() : (0.5 * 255).toInt()), width: 1),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _uservoted ? Colors.red.withAlpha((0.3 * 255).toInt()) : Colors.red,
                  foregroundColor: _uservoted ? Colors.white.withAlpha((0.5 * 255).toInt()) : Colors.white,
                  elevation: _uservoted ? 0 : 4,
                  shadowColor: Colors.red.withAlpha((0.3 * 255).toInt()),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _uservoted ? null : () async {
                  await _handleVote(context, report, -1);
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
                border: Border.all(color: Colors.green.withAlpha(_uservoted ? (0.2 * 255).toInt() : (0.5 * 255).toInt()), width: 1),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _uservoted ? Colors.green.withAlpha((0.3 * 255).toInt()) : Colors.green,
                  foregroundColor: _uservoted ? Colors.white.withAlpha((0.5 * 255).toInt()) : Colors.white,
                  elevation: _uservoted ? 0 : 4,
                  shadowColor: Colors.green.withAlpha((0.3 * 255).toInt()),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _uservoted ? null : () async {
                  await _handleVote(context, report, 1);
                },
                child: Text(AppLocalizations.of(context)!.inlinewiththerules),
              ),
            ),
          ),
        ],
      ) : _userisassignttoreport 
          ? Center(child: Text(AppLocalizations.of(context)!.youhavevoted)) 
          : Center(child: Text(AppLocalizations.of(context)!.youarenotassignedtothisreport)),
    );
  }

  /// Builds the vote overview section
  Widget _buildVoteOverview(BuildContext context) {
    return Container(
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
          FutureBuilder<List<ReportVotes>>(
            future: futureReportVotes,
            builder: (context, votesSnapshot) {
              if (votesSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              }
              if (votesSnapshot.hasError) {
                return Center(child: Text('${AppLocalizations.of(context)!.error}: ${votesSnapshot.error}'));
              }

              final votes = votesSnapshot.data!;
              return _buildVoteProgressAndTable(context, votes);
            },
          ),
        ],
      ),
    );
  }

  /// Builds vote progress bar and table
  Widget _buildVoteProgressAndTable(BuildContext context, List<ReportVotes> votes) {
    final violationVotes = votes.where((vote) => vote.vote == -1).length;
    final inOrderVotes = votes.where((vote) => vote.vote == 1).length;
    final pendingVotes = votes.where((vote) => vote.vote == 0).length;
    final totalVotes = violationVotes + inOrderVotes + pendingVotes;

    return Column(
      children: [
        // Expandable Vote Overview Header
        GestureDetector(
          onTap: () {
            setState(() {
              _isVoteOverviewExpanded = !_isVoteOverviewExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha((0.08 * 255).toInt()),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withAlpha((0.2 * 255).toInt()), width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.votingoverview,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  _isVoteOverviewExpanded 
                    ? Icons.keyboard_arrow_up 
                    : Icons.keyboard_arrow_down,
                  color: Colors.white70,
                ),
              ],
            ),
          ),
        ),
        // Expandable Content
        if (_isVoteOverviewExpanded) ...[
          const SizedBox(height: 8),
          _buildProgressBar(context, violationVotes, inOrderVotes, pendingVotes, totalVotes),
          _buildVoteTable(context, votes),
        ],
      ],
    );
  }

  /// Builds the progress bar
  Widget _buildProgressBar(BuildContext context, int violationVotes, int inOrderVotes, int pendingVotes, int totalVotes) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((0.05 * 255).toInt()),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withAlpha((0.2 * 255).toInt()), width: 1),
      ),
      child: totalVotes == 0 
        ? Text(
            AppLocalizations.of(context)!.sorrysomethingwentwrong,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          )
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${AppLocalizations.of(context)!.violation}: $violationVotes",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${AppLocalizations.of(context)!.open}: $pendingVotes",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.inorder}: $inOrderVotes",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.white.withAlpha((0.3 * 255).toInt()), width: 1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Row(
                    children: [
                      if (violationVotes > 0)
                        Expanded(
                          flex: violationVotes,
                          child: Container(color: Colors.red),
                        ),
                      if (pendingVotes > 0)
                        Expanded(
                          flex: pendingVotes,
                          child: Container(color: Colors.grey),
                        ),
                      if (inOrderVotes > 0)
                        Expanded(
                          flex: inOrderVotes,
                          child: Container(color: Colors.green),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${(violationVotes / totalVotes * 100).toStringAsFixed(0)}% ${AppLocalizations.of(context)!.violation} | ${(pendingVotes / totalVotes * 100).toStringAsFixed(0)}% ${AppLocalizations.of(context)!.open} | ${(inOrderVotes / totalVotes * 100).toStringAsFixed(0)}% ${AppLocalizations.of(context)!.inorder}",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
    );
  }

  /// Builds the vote table
  Widget _buildVoteTable(BuildContext context, List<ReportVotes> votes) {
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
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.white.withAlpha((0.3 * 255).toInt()), width: 1),
                        ),
                        child: Text(
                          vote.trustername,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: Colors.white.withAlpha((0.3 * 255).toInt()),
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
                            fontWeight: FontWeight.bold,
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
  }

  /// Handles voting logic
  Future<void> _handleVote(BuildContext context, Report report, int vote) async {
    setState(() {
      _uservoted = true; // Sofortige UI-Aktualisierung
    });
    
    Chainactions ca = Chainactions();
    String username = Provider.of<GlobalStatus>(context, listen: false).username;
    String permission = Provider.of<GlobalStatus>(context, listen: false).permission;
    ca.setusernameandpermission(username, permission);
    debugPrint("Username: $username, Permission: $permission");
    
    try {
      bool result = await ca.trustervote(report.reportid.toString(), vote);
      if (result) {
        Globalnotifications.shownotification(context, "title", "message", "success");
        // Aktualisiere die futureReportVotes für sofortige Progressbar-Aktualisierung
        setState(() {
          futureReportVotes = Chainactions().getreportvotes(widget.report.reportid.toString());
        });
      } else {
        // Bei Fehler _uservoted zurücksetzen
        setState(() {
          _uservoted = false;
        });
      }
    } catch (error) {
      debugPrint("Error voting: $error");
      // Bei Fehler _uservoted zurücksetzen
      setState(() {
        _uservoted = false;
      });
    }
  }

  /// Returns the appropriate content type text based on report type
  String _getContentTypeText(int type, BuildContext context) {
    switch (type) {
      case 1:
        return AppLocalizations.of(context)!.uploadedby;
      case 2:
        return "Kommentar von";
      case 3:
        return "Tag von";
      default:
        return "Inhalt von";
    }
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

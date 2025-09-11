import 'package:flutter/material.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/report.dart';
import 'package:fr0gsite/datatypes/rule.dart';
import 'package:fr0gsite/datatypes/rules.dart';
import 'package:fr0gsite/ipfsactions.dart';
import 'package:fr0gsite/widgets/truster/trustervotereportview.dart';
import 'package:provider/provider.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';
import 'dart:typed_data';

// Global tab indicator for consistent styling
final gloabltabindicator = const UnderlineTabIndicator(
  borderSide: BorderSide(width: 2.0, color: Colors.white),
  insets: EdgeInsets.symmetric(horizontal: 16.0),
);

// Assuming Report and getreports() are already imported

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
      final upload = await Chainactions().cachedgetupload(widget.uploadId.toString());
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

class ReportsWidget extends StatefulWidget {
  const ReportsWidget({super.key});

  @override
  State<ReportsWidget> createState() => _ReportsWidgetState();
}

class _ReportsWidgetState extends State<ReportsWidget> {
  late Future<int> _reportCount;

  Future<int> _loadReportCount() async {
    final reports = await Chainactions().getreports();
    return reports.length;
  }

  @override
  void initState() {
    super.initState();
    _reportCount = _loadReportCount();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _reportCount,
      builder: (context, snapshot) {
        final allReportsText = snapshot.hasData
            ? '${AppLocalizations.of(context)!.allreports} (${snapshot.data})'
            : '${AppLocalizations.of(context)!.allreports} (...)';

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.reports),
              bottom: TabBar(
                labelColor: Colors.white,
                indicator: gloabltabindicator,
                dividerColor: Colors.white,
                indicatorColor: Colors.white,
                indicatorWeight: 2,
                indicatorSize: TabBarIndicatorSize.tab,
                unselectedLabelColor: Colors.white70,
                unselectedLabelStyle: const TextStyle(fontSize: 14),
                labelStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                tabs: [
                  Tab(text: "${AppLocalizations.of(context)!.forme} (${Provider.of<GlobalStatus>(context, listen: false).username})"),
                  Tab(text: allReportsText),
                  Tab(text: AppLocalizations.of(context)!.urgentreport),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                      // Implement filter function here
                  },
                ),
              ],
            ),
            body: const TabBarView(
              children: [
                // Do not translate in AppLocalizations
                ReportsTable(mode: "forme"),
                ReportsTable(mode: "all"),
                ReportsTable(mode: "urgent"),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ReportsTable extends StatefulWidget {
  final String mode;

  const ReportsTable({super.key, required this.mode});

  @override
  State<ReportsTable> createState() => _ReportsTableState();
}

class _ReportsTableState extends State<ReportsTable> {
  // Sortierung
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  
  // Filter
  Set<int> _selectedStatuses = <int>{0, 2}; // 0 = Offen, 2 = Dringend
  
  // Daten-Cache
  List<Report>? _cachedReports;
  Future<List<Report>>? _reportsFuture;
  
  @override
  void initState() {
    super.initState();
    _loadReports();
  }
  
  void _loadReports() {
    _reportsFuture = Chainactions().getreports().then((reports) {
      _cachedReports = reports;
      return reports;
    });
  }
  
  void _refreshReports() {
    setState(() {
      _cachedReports = null;
      _loadReports();
    });
  }

  List<Report> _sortReports(List<Report> reports) {
    reports.sort((a, b) {
      dynamic aValue;
      dynamic bValue;
      
      switch (_sortColumnIndex) {
        case 0: // Nr
          aValue = a.reportid;
          bValue = b.reportid;
          break;
        case 1: // Rule
          aValue = a.violatedrule;
          bValue = b.violatedrule;
          break;
        case 2: // Upload ID
          aValue = a.id;
          bValue = b.id;
          break;
        case 3: // Votes
          aValue = a.outstandingvotes;
          bValue = b.outstandingvotes;
          break;
        case 4: // Time left
          final now = DateTime.now();
          final aDeadline = a.reporttime.add(const Duration(hours: 24));
          final bDeadline = b.reporttime.add(const Duration(hours: 24));
          aValue = aDeadline.difference(now).inHours;
          bValue = bDeadline.difference(now).inHours;
          break;
        case 5: // Status
          aValue = a.status;
          bValue = b.status;
          break;
        default:
          aValue = a.reportid;
          bValue = b.reportid;
      }
      
      final comparison = Comparable.compare(aValue, bValue);
      return _sortAscending ? comparison : -comparison;
    });
    
    return reports;
  }

  List<Report> _filterReports(List<Report> reports) {
    return reports.where((report) {
      // Status Filter - wenn nichts ausgewählt ist, zeige alle
      if (_selectedStatuses.isNotEmpty && !_selectedStatuses.contains(report.status)) {
        return false;
      }
      
      return true;
    }).toList();
  }

  Widget _buildStatusChip(int status, String label, Color color) {
    final isSelected = _selectedStatuses.contains(status);
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontSize: 12,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _selectedStatuses.add(status);
          } else {
            _selectedStatuses.remove(status);
            // Wenn das der letzte ausgewählte Filter war, alle auswählen
            if (_selectedStatuses.isEmpty) {
              _selectedStatuses.addAll({0, 1, 2}); // Alle Status auswählen
            }
          }
        });
      },
      selectedColor: color.withAlpha((0.7 * 255).toInt()),
      backgroundColor: isSelected 
        ? color.withAlpha((0.3 * 255).toInt())
        : Colors.grey.shade800, // Dunklerer Hintergrund für nicht ausgewählte
      checkmarkColor: Colors.white,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Report>>(
      future: _reportsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator(color:Colors.white));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        
        // Verwende gecachte Daten für Filter-Operationen
        final reports = _cachedReports!;
        String username = Provider.of<GlobalStatus>(context, listen: false).username;
        
        
        var filteredReports = reports;
        switch (widget.mode) {
          case "forme":
            filteredReports = reports;
            // TODO: Implement filtering for "forme"
            debugPrint("Filtered reports for $username: ${filteredReports.length}");
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

        // Wende Filter und Sortierung an
        filteredReports = _filterReports(filteredReports);
        filteredReports = _sortReports(filteredReports);

        return Column(
          children: [
            // Filter Controls
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Filter Chips und Refresh Button
                  Row(
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.status}: ',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(width: 8),
                      _buildStatusChip(0, AppLocalizations.of(context)!.open, Colors.green),
                      const SizedBox(width: 8),
                      _buildStatusChip(1, AppLocalizations.of(context)!.closed, Colors.red),
                      const SizedBox(width: 8),
                      _buildStatusChip(2, AppLocalizations.of(context)!.urgent, Colors.orange),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        onPressed: _refreshReports,
                        tooltip: 'Daten aktualisieren',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Tabelle
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      showCheckboxColumn: false,
                      columnSpacing: 24.0, // Reduzierter Abstand zwischen Spalten (Standard: 56.0)
                      sortColumnIndex: _sortColumnIndex,
                      sortAscending: _sortAscending,
                      columns: [
                        DataColumn(
                          label: const Text('Nr'),
                          onSort: (columnIndex, ascending) {
                            setState(() {
                              _sortColumnIndex = columnIndex;
                              _sortAscending = ascending;
                            });
                          },
                        ),
                        DataColumn(
                          label: Text(AppLocalizations.of(context)!.rule),
                          onSort: (columnIndex, ascending) {
                            setState(() {
                              _sortColumnIndex = columnIndex;
                              _sortAscending = ascending;
                            });
                          },
                        ),
                        DataColumn(
                          label: Text(AppLocalizations.of(context)!.upload),
                          onSort: (columnIndex, ascending) {
                            setState(() {
                              _sortColumnIndex = columnIndex;
                              _sortAscending = ascending;
                            });
                          },
                        ),
                        DataColumn(
                          label: Text(AppLocalizations.of(context)!.votes),
                          onSort: (columnIndex, ascending) {
                            setState(() {
                              _sortColumnIndex = columnIndex;
                              _sortAscending = ascending;
                            });
                          },
                        ),
                        DataColumn(
                          label: Text(AppLocalizations.of(context)!.timeleft),
                          onSort: (columnIndex, ascending) {
                            setState(() {
                              _sortColumnIndex = columnIndex;
                              _sortAscending = ascending;
                            });
                          },
                        ),
                        DataColumn(
                          label: Text(AppLocalizations.of(context)!.status),
                          onSort: (columnIndex, ascending) {
                            setState(() {
                              _sortColumnIndex = columnIndex;
                              _sortAscending = ascending;
                            });
                          },
                        ),
                      ],
                      rows: filteredReports.map((report) {
                        return DataRow(
                          cells: [
                            DataCell(
                              InkWell(
                                child: Text('${report.reportid}', style: const TextStyle(color: Colors.blue)),
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => TrusterVoteReportView(report: report)));
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
                                    // Link to the upload
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
                                  final deadline = report.reporttime.add(const Duration(hours: 24)).add(now.timeZoneOffset);
                                  final totalDuration = deadline.difference(report.reporttime).inSeconds;
                                  final elapsedDuration = now.difference(report.reporttime).inSeconds;
                                  final progress = (elapsedDuration / totalDuration).clamp(0.0, 1.0);
                                  final timeLeft = deadline.difference(now);

                                  return Tooltip(
                                    message: '${timeLeft.inHours} h ${timeLeft.inMinutes.remainder(60)} min ',
                                    child: Column(
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
                                          '${(elapsedDuration / 3600).round() - now.timeZoneOffset.inHours} / 24 h',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            DataCell(
                              Tooltip(
                                message: statusText(report.status, context),
                                child: Container(
                                  color: statusColor(report.status),
                                  width: 12,
                                  height: 12,
                                ),
                              ),
                            ),
                          ],
                          onSelectChanged: (selected) {
                            if (selected != null && selected) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TrusterVoteReportView(report: report),
                                ),
                              );
                            }
                          },
                          color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                            return Colors.transparent;
                          }),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Hilfsfunktionen für Status
String statusText(int status, BuildContext context) {
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

// Import hinzufügen für Rules

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
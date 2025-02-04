import 'package:flutter/material.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/truster.dart';
import 'package:fr0gsite/nameconverter.dart';
import 'package:fr0gsite/widgets/postviewer/comment/timedifferencewidget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatisticTrusterList extends StatefulWidget {
  const StatisticTrusterList({super.key});

  @override
  State<StatisticTrusterList> createState() => _StatisticTrusterListState();
}

class _StatisticTrusterListState extends State<StatisticTrusterList> {
  List<Truster> trusterlist = [];
  bool sortAscending = true;
  int sortColumnIndex = 0;

  @override
  void initState() {
    super.initState();
    loadtrusterdata();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: AppColor.niceblack,
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: DataTable(
              sortColumnIndex: sortColumnIndex,
              sortAscending: sortAscending,
              columns: [
                DataColumn(
                  label: Text(AppLocalizations.of(context)!.username),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      sortColumnIndex = columnIndex;
                      sortAscending = ascending;
                      trusterlist.sort((a, b) => compareString(
                          NameConverter.uint64ToName(BigInt.parse(a.trustername)),
                          NameConverter.uint64ToName(BigInt.parse(b.trustername)),
                          ascending));
                    });
                  },
                ),
                DataColumn(
                  label: const Text('Karma'),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      sortColumnIndex = columnIndex;
                      sortAscending = ascending;
                      trusterlist.sort((a, b) => compareInt(a.karma, b.karma, ascending));
                    });
                  },
                ),
                DataColumn(
                  label: const Text('Status'),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      sortColumnIndex = columnIndex;
                      sortAscending = ascending;
                      trusterlist.sort((a, b) => compareInt(a.status, b.status, ascending));
                    });
                  },
                ),
                DataColumn(
                  label: const Text('Wahltag'),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      sortColumnIndex = columnIndex;
                      sortAscending = ascending;
                      trusterlist.sort((a, b) => compareString(a.electiondate.toString(), b.electiondate.toString(), ascending));
                    });
                  },
                ),
              ],
              rows: trusterlist.map((truster) => DataRow(cells: [
                DataCell(Text(NameConverter.uint64ToName(BigInt.parse(truster.trustername)))),
                DataCell(Text(truster.karma.toString())),
                DataCell(Text(truster.status.toString())),
                DataCell(TimeDifferenceWidget(dateTimeString: truster.electiondate.toString())),
              ])).toList()
            ),
          ),
        ),
      ),
    );
  }

  void loadtrusterdata(){
    Chainactions().gettrusters().then((value) {
      setState(() {
        trusterlist = value;
        trusterlist.add(Truster(trustername: "1", karma: 1, status: 1, electiondate: DateTime.now()));
        trusterlist.add(Truster(trustername: "1", karma: 1, status: 1, electiondate: DateTime.now()));
        trusterlist.add(Truster(trustername: "1", karma: 1, status: 1, electiondate: DateTime.now()));
        trusterlist.add(Truster(trustername: "1", karma: 1, status: 1, electiondate: DateTime.now()));
        trusterlist.add(Truster(trustername: "1", karma: 1, status: 1, electiondate: DateTime.now()));
        trusterlist.add(Truster(trustername: "1", karma: 1, status: 1, electiondate: DateTime.now()));
        trusterlist.add(Truster(trustername: "1", karma: 1, status: 1, electiondate: DateTime.now()));
      });
    });
  }

  int compareString(String a, String b, bool ascending) {
    return ascending ? a.compareTo(b) : b.compareTo(a);
  }

  int compareInt(int a, int b, bool ascending) {
    return ascending ? a.compareTo(b) : b.compareTo(a);
  }
}
import 'package:flutter/material.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/truster.dart';
import 'package:fr0gsite/nameconverter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class StatisticTrusterList extends StatefulWidget {
  const StatisticTrusterList({super.key});

  @override
  State<StatisticTrusterList> createState() => _StatisticTrusterListState();
}

class _StatisticTrusterListState extends State<StatisticTrusterList> {
  List<Truster> trusterlist = [];
  List<DataRow> dataRow = [];
  bool sortAscending = true;
  int sortColumnIndex = 0;
  bool loadfinish = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 20; i++) {
      dataRow.add(const DataRow(cells: [
        DataCell(Text("...")),
        DataCell(Text("...")),
        DataCell(Text("...")),
        DataCell(Text("...")),
      ]));
      loadtrusterdata();

    }
  }

  List<DataRow> createDataRow(List<Truster> trusterlist) {
    for (int i = 0; i < trusterlist.length; i++) {
      dataRow.add(DataRow(cells: [
        DataCell(Text(NameConverter.uint64ToName(BigInt.parse(trusterlist[i].trustername)))),
        DataCell(Text(trusterlist[i].karma.toString())),
        DataCell(Text(trusterlist[i].status.toString())),
        //Only day without time
        DataCell(Text(DateFormat('yyyy-MM-dd').format(trusterlist[i].electiondate))),
      ]));
    }
    return dataRow;

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
            child: Column(
              children: [
                const Text("Truster", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                DataTable(
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
                  rows: dataRow
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loadtrusterdata(){
    if (loadfinish) {
      return;
    }
    Chainactions().gettrusters().then((value) {
      setState(() {
        dataRow.clear();
        loadfinish = true;
        dataRow = createDataRow(value);
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
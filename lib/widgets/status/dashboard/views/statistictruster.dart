import 'package:flutter/material.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/truster.dart';
import 'package:fr0gsite/ipfsactions.dart';
import 'package:fr0gsite/nameconverter.dart';
import 'package:fr0gsite/widgets/postviewer/comment/timedifferencewidget.dart';

class StatisticTrusterList extends StatefulWidget {
  const StatisticTrusterList({super.key});

  @override
  State<StatisticTrusterList> createState() => _StatisticTrusterListState();
}

class _StatisticTrusterListState extends State<StatisticTrusterList> {
  List<Truster> trusterlist = [];

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
      child: Padding(
        padding: EdgeInsets.all(10),
        child: DataTable(
          columns: [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Karma')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Wahltag')),
          ],
          rows: trusterlist.map((truster) => DataRow(cells: [
            DataCell(Text(NameConverter.uint64ToName(BigInt.parse(truster.trustername)))),
            DataCell(Text(truster.karma.toString())),
            DataCell(Text(truster.status.toString())),
            DataCell(TimeDifferenceWidget(dateTimeString: truster.electiondate.toString())),
          ])).toList()
        ),
      ),
    );
  }

  void loadtrusterdata(){
    Chainactions().gettrusters().then((value) {
      setState(() {
        trusterlist = value;
      });
    });
  }
}
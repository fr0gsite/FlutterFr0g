import 'dart:async';

import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/producerinfo.dart';
import 'package:fr0gsite/datatypes/blockchainnode.dart';
import 'package:eosdart/eosdart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';

import '../../datatypes/globaltable1.dart';

//Nessesary API calls
//Jede Sekunden
//getblock
//getinfo
//Alle 2 Sekunden
//get_table_row, {"code": "eosio","scope": "eosio","table": "global","limit": 10,"json": true}
//get_table_row, {"code": "eosio","scope": "eosio","table": "rammarket","limit": 10,"json": true}

class TransactionTimeline extends StatefulWidget {
  const TransactionTimeline({super.key});

  @override
  State<TransactionTimeline> createState() => _TransactionTimelineState();
}

class _TransactionTimelineState extends State<TransactionTimeline> {
  @override
  void initState() {
    super.initState();
    lineChartBarData1 = LineChartBarData(
        spots: [
          const FlSpot(0, 0),
        ],
        isCurved: true,
        barWidth: 5,
        dotData: const FlDotData(
          show: true,
        ),
        color: Colors.blue,
        curveSmoothness: 0.3);

    lineChartData = LineChartData(
        backgroundColor: AppColor.nicegrey,
        lineTouchData: const LineTouchData(enabled: true),
        gridData: const FlGridData(
          show: true,
        ),
        titlesData: const FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            axisNameSize: 60,
            axisNameWidget: Text(
              "Time",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          topTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
          leftTitles: AxisTitles(
            axisNameSize: 60,
            axisNameWidget: Text(
              "Transactions",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        lineBarsData: [lineChartBarData1],
        minX: 0,
        maxX: 1,
        minY: 0,
        maxY: 1);

    initrequest();
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint("dispose");
    timer500?.cancel();
    timerglobal?.cancel();
    timerproducers?.cancel();
  }

  int lastblocknr = 0;
  int plotcounter = 1;
  double maxYspot = 5;
  int range = 40;
  Timer? timer500;
  Timer? timerglobal;
  Timer? timerproducers;
  NodeInfo lastNodeInfo = NodeInfo();
  Block lastBlock = Block("Dummy", 1);
  int transactionscounter = 0;
  double usedram = 0;
  double maxram = 0;
  List<ProducerInfo> producers = [];

  void initrequest() async {
    Blockchainnode node = Chainactions().chooseNode();
    EOSClient client = EOSClient(node.getfullurl, node.apiversion);

    timer500 = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      if (ModalRoute.of(context)?.isCurrent ?? false) {
        NodeInfo tempNodeInfo = await client.getInfo();
        if (lastblocknr != tempNodeInfo.headBlockNum!) {
          lastblocknr = tempNodeInfo.headBlockNum!;
          lastNodeInfo = tempNodeInfo;
          Block tempBlock = await client.getBlock(lastblocknr.toString());
          lastBlock = tempBlock;
          double transactionsinblock =
              tempBlock.transactions!.length.toDouble();
          if (mounted) {
            setState(() {
              //double transactionsinblock = Random().nextInt(5).toDouble() + 1;

              maxYspot < transactionsinblock
                  ? maxYspot = transactionsinblock
                  : null;
              transactionscounter += transactionsinblock.toInt();
              lineChartBarData1.spots
                  .add(FlSpot(plotcounter.toDouble(), transactionsinblock));
              lineChartBarData1.spots.length > range
                  ? lineChartBarData1.spots.removeAt(0)
                  : null;
              plotcounter++;
              lineChartData = lineChartData.copyWith(
                minX: plotcounter.toDouble() - range,
                maxX: plotcounter.toDouble(),
                maxY: maxYspot + 1,
              );
              debugPrint(
                  "current Block: $lastblocknr, Transactions: $transactionsinblock");
            });
          }
        }
      }
    });

    timerglobal = Timer.periodic(const Duration(seconds: 2), (timer) {
      client
          .getTableRow(AppConfig.blockchainsystemcontract,
              AppConfig.blockchainsystemcontract, "global",
              json: true)
          .then((value) {
        if (mounted) {
          GlobalTable1 temp = GlobalTable1.fromJson(value!);
          usedram = (temp.totalRamBytesReserved / 1024 / 1024).roundToDouble();
          maxram = (temp.maxRamSize / 1024 / 1024).roundToDouble();
        }
      });
    });

    timerproducers = Timer.periodic(const Duration(seconds: 2), (timer) {
      client
          .getTableRows(AppConfig.blockchainsystemcontract,
              AppConfig.blockchainsystemcontract, "producers",
              json: true, limit: 300)
          .then((value) {
        if (mounted) {
          producers = value.map((data) => ProducerInfo.fromJson(data)).toList();
          producers.sort((a, b) => b.totalVotes.compareTo(a.totalVotes));
        }
      });
    });
  }

  LineChartData lineChartData = LineChartData();

  LineChartBarData lineChartBarData1 = LineChartBarData();
  final ScrollController scrollControllerhorizontal = ScrollController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: AppColor.nicegrey,
          child: SizedBox(
            width: 1200,
            child: ListView(
              children: [
                SizedBox(
                  height: constraints.maxHeight * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.statusoftheblockchain,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: 300,
                    child: LineChart(
                      lineChartData,
                    ),
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    infobox(
                        "${AppLocalizations.of(context)!.lastblockid}:",
                        lastNodeInfo.headBlockNum.toString() == "null"
                            ? ""
                            : lastNodeInfo.headBlockNum.toString()),
                    infobox(
                        AppLocalizations.of(context)!.blockproducer,
                        lastNodeInfo.headBlockProducer.toString() == "null"
                            ? ""
                            : lastNodeInfo.headBlockProducer.toString()),
                    infobox(
                        "${AppLocalizations.of(context)!.lastirreversibleblock}:",
                        lastNodeInfo.lastIrreversibleBlockNum.toString() ==
                                "null"
                            ? ""
                            : lastNodeInfo.lastIrreversibleBlockNum.toString()),
                    infobox("${AppLocalizations.of(context)!.transactionsum}:",
                        transactionscounter.toString()),
                    infobox(
                        "${AppLocalizations.of(context)!.price}/1000 ${AppConfig.systemtoken} ${AppLocalizations.of(context)!.token}",
                        "-.-- \$"),
                    infobox("${AppLocalizations.of(context)!.usedram}:",
                        "$usedram / $maxram MB"),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Scrollbar(
                      controller: scrollControllerhorizontal,
                      scrollbarOrientation: ScrollbarOrientation.top,
                      thickness: 15,
                      child: SingleChildScrollView(
                        controller: scrollControllerhorizontal,
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          border: const TableBorder(
                            horizontalInside:
                                BorderSide(color: Colors.grey, width: 1),
                            verticalInside:
                                BorderSide(color: Colors.grey, width: 1),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          headingRowColor: WidgetStateColor.resolveWith(
                              (states) =>
                                  Colors.blue.withAlpha((0.3 * 255).toInt())),
                          columns: [
                            const DataColumn(
                                label: Flexible(
                                    child: Text(
                              'Nr',
                            ))),
                            DataColumn(
                                label: Flexible(
                                    child: Text(
                              AppLocalizations.of(context)!.status,
                              overflow: TextOverflow.ellipsis,
                            ))),
                            DataColumn(
                                label: Flexible(
                                    child: Text(
                              AppLocalizations.of(context)!.owner,
                              overflow: TextOverflow.ellipsis,
                            ))),
                            DataColumn(
                                label: Flexible(
                                    child: Text(
                              AppLocalizations.of(context)!.totalvotes,
                              overflow: TextOverflow.ellipsis,
                            ))),
                            DataColumn(
                                label: Flexible(
                                    child: Text(
                              AppLocalizations.of(context)!.unpaidblocks,
                              overflow: TextOverflow.ellipsis,
                            ))),
                            DataColumn(
                                label: Flexible(
                                    child: Text(
                              AppLocalizations.of(context)!.isactive,
                              overflow: TextOverflow.ellipsis,
                            ))),
                            DataColumn(
                                label: Flexible(
                                    child: Text(
                              AppLocalizations.of(context)!.url,
                            ))),
                          ],
                          rows: producers
                              .where((element) => element.totalVotes != 0)
                              .map((producer) {
                            return DataRow(cells: [
                              DataCell(Text((producers.indexOf(producer) + 1)
                                  .toString())),
                              DataCell(Container(
                                  decoration: BoxDecoration(
                                      color: lastNodeInfo.headBlockProducer
                                                  .toString() ==
                                              producer.owner
                                          ? Colors.red
                                          : producers.indexOf(producer) < 21
                                              ? Colors.red.withAlpha(
                                                  (0.2 * 255).toInt())
                                              : null,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: lastNodeInfo.headBlockProducer
                                                  .toString() ==
                                              producer.owner
                                          ? Text(AppLocalizations.of(context)!
                                              .currentlyproducing)
                                          : producers.indexOf(producer) < 21
                                              ? Text(
                                                  AppLocalizations.of(context)!
                                                      .electedblockproducer)
                                              : Text(
                                                  AppLocalizations.of(context)!
                                                      .standbyblockproducer)))),
                              DataCell(
                                Container(
                                  decoration: BoxDecoration(
                                      color: lastNodeInfo.headBlockProducer
                                                  .toString() ==
                                              producer.owner
                                          ? Colors.green
                                              .withAlpha((0.6 * 255).toInt())
                                          : producers.indexOf(producer) < 21
                                              ? Colors.green.withAlpha(
                                                  (0.2 * 255).toInt())
                                              : null,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(producer.owner),
                                  ),
                                ),
                              ),
                              DataCell(Text(producer.totalVotes.toString())),
                              DataCell(Text(producer.unpaidBlocks.toString())),
                              DataCell(Text(producer.isActive
                                  ? AppLocalizations.of(context)!.yes
                                  : AppLocalizations.of(context)!.no)),
                              DataCell(Text(producer.url)),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget infobox(String title, String info) {
  return ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 200, maxHeight: 70),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.blue.withAlpha((0.3 * 255).toInt()),
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              info,
              style:
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    ),
  );
}

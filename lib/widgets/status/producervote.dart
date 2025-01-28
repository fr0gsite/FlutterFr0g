import 'dart:async';

import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/producerinfo.dart';
import 'package:fr0gsite/widgets/login/login.dart';
import 'package:fr0gsite/widgets/status/producervotedialog.dart';
import 'package:fr0gsite/widgets/status/transactiontimeline.dart';
import 'package:eosdart/eosdart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Producervote extends StatefulWidget {
  const Producervote({super.key});

  @override
  State<Producervote> createState() => _ProducervoteState();
}

class _ProducervoteState extends State<Producervote> {
  late Future futuregetblockproducer;
  VoterInfo uservoteinfo = VoterInfo();
  List<ProducerInfo> producerlist = [];
  final ScrollController scrollControllerhorizontal = ScrollController();
  NodeInfo lastNodeInfo = NodeInfo();
  double vote = 0;
  bool run = true;

  @override
  void initState() {
    super.initState();
    futuregetblockproducer = getBlockProducer();
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<GlobalStatus>(context, listen: true).isLoggedin && run) {
      run = false;

      getUserInfo().then((value) {
        List<dynamic> votedproducerlist = value.producers as List<dynamic>;
        if (mounted) {
          setState(() {
            uservoteinfo = value;
            if (votedproducerlist.isNotEmpty) {
              vote = (double.parse(uservoteinfo.lastVoteWeight.toString()) +
                      double.parse(uservoteinfo.proxiedVoteWeight.toString())) /
                  votedproducerlist.length;
            }
            Timer.periodic(const Duration(milliseconds: 100), (timer) {
              if (mounted) {
                if (producerlist.isNotEmpty) {
                  setState(() {
                    for (var element in producerlist) {
                      element.uservote = 0;
                      if (votedproducerlist.contains(element.owner)) {
                        element.uservote = vote;
                      }
                    }
                    timer.cancel();
                  });
                }
              } else {
                timer.cancel();
              }
            });
          });
        }
      });
    }

    return Consumer<GlobalStatus>(builder: (context, globalstatus, child) {
      return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 20,
              children: [
                uservoteinfo.isProxy == 1
                    ? infobox(AppLocalizations.of(context)!.proxy,
                        AppLocalizations.of(context)!.yes)
                    : infobox(AppLocalizations.of(context)!.proxy,
                        AppLocalizations.of(context)!.no),
                if (uservoteinfo.isProxy == 1)
                  infobox(AppLocalizations.of(context)!.proxy,
                      uservoteinfo.proxy.toString()),
                if (uservoteinfo.isProxy == 1)
                  infobox(AppLocalizations.of(context)!.proxiedvoteweight,
                      uservoteinfo.proxiedVoteWeight ?? "0"),
                infobox(
                    AppLocalizations.of(context)!.producers,
                    uservoteinfo.producers.toString() == "null"
                        ? AppLocalizations.of(context)!.no
                        : uservoteinfo.producers.toString()),
                infobox(
                    AppLocalizations.of(context)!.staked,
                    uservoteinfo.staked.toString() == "null"
                        ? "0"
                        : uservoteinfo.staked.toString()),
                infobox(
                    AppLocalizations.of(context)!.lastvoteweight,
                    uservoteinfo.lastVoteWeight.toString() == "null"
                        ? "0"
                        : uservoteinfo.lastVoteWeight.toString()),

                //Button for vote
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.green),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  onPressed: () {
                    if (!globalstatus.isLoggedin) {
                      showDialog(
                        context: context,
                        builder: ((context) {
                          return const Login();
                        }),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: ((context) {
                          return const ProducervoteDialog();
                        }),
                      );
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.vote,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder(
              future: futuregetblockproducer,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.white,
                  ));
                } else {
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                            '${AppLocalizations.of(context)!.error} ${snapshot.error}'));
                  } else {
                    if (snapshot.data == false) {
                      return Center(
                          child: Text(AppLocalizations.of(context)!
                              .noblockproducerfound));
                    } else {
                      return Center(
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
                                    (states) => Colors.blue.withAlpha((0.3 * 255).toInt())),
                                columns: [
                                  const DataColumn(label: Text('Nr')),
                                  DataColumn(
                                      label: Text(
                                          AppLocalizations.of(context)!.owner)),
                                  DataColumn(
                                      label: Text(AppLocalizations.of(context)!
                                          .totalvotes)),
                                  DataColumn(
                                      label: Text(AppLocalizations.of(context)!
                                          .yourvote)),
                                ],
                                rows: producerlist.map((producer) {
                                  return DataRow(cells: [
                                    DataCell(Text(
                                        (producerlist.indexOf(producer) + 1)
                                            .toString())),
                                    DataCell(
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(producer.owner),
                                      ),
                                    ),
                                    DataCell(
                                        Text(producer.totalVotes.toString())),
                                    DataCell(
                                        Text(producer.uservote.toString())),
                                  ]);
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  }
                }
              }),
        ],
      );
    });
  }

  Future getBlockProducer() async {
    try {
      producerlist = await Chainactions().getproducerlist();
      producerlist.sort((a, b) => b.totalVotes.compareTo(a.totalVotes));
      setState(() {});
    } catch (e) {
      return false;
    }
    if (producerlist.isEmpty) return false;

    return true;
  }

  Future<VoterInfo> getUserInfo() async {
    try {
      Account useraccount =
          Provider.of<GlobalStatus>(context, listen: false).useraccount;
      debugPrint("getUserInfo: ${useraccount.voterInfo}");
      return useraccount.voterInfo ?? VoterInfo();
    } catch (e) {
      return VoterInfo();
    }
  }
}

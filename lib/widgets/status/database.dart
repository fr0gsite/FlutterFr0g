import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:eosdart/eosdart.dart';
import 'package:flutter/material.dart';

class Database extends StatefulWidget {
  const Database({super.key});

  @override
  State<Database> createState() => _DatabaseState();
}

class _DatabaseState extends State<Database> {
  Future? futuregetalltables;
  Future? futuregettable;
  List<String> tablelist = [];
  String dropdownvalue = "uploads";
  final ScrollController scrollController = ScrollController();
  final ScrollController scrollControllerhorizontal = ScrollController();

  @override
  void initState() {
    super.initState();
    futuregetalltables = getalltables();
    futuregettable = gettable(dropdownvalue);
    //Allow Mouse Scroll horizontal
    scrollControllerhorizontal.addListener(() {
      if (scrollControllerhorizontal.position.pixels ==
          scrollControllerhorizontal.position.maxScrollExtent) {
        scrollControllerhorizontal.position.moveTo(
            scrollControllerhorizontal.position.minScrollExtent,
            duration: const Duration(milliseconds: 1),
            curve: Curves.easeIn);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futuregetalltables,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scrollbar(
                controller: scrollController,
                thickness: 15,
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    controller: scrollController,
                    child: Wrap(
                      children: [
                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 10,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButton(
                                  dropdownColor: Colors.black,
                                  value: dropdownvalue,
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                  ),
                                  items: tablelist.map(
                                    (String value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        dropdownvalue = value.toString();
                                      },
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 200,
                                child: TextField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'scrope',
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 3),
                                      ),
                                      filled: true,
                                      fillColor: Colors.blueGrey),
                                ),
                              ),
                              const SizedBox(
                                width: 200,
                                child: TextField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'limit',
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 3),
                                      ),
                                      filled: true,
                                      fillColor: Colors.blueGrey),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Scrollbar(
                            controller: scrollControllerhorizontal,
                            thickness: 15,
                            scrollbarOrientation: ScrollbarOrientation.top,
                            child: SingleChildScrollView(
                              controller: scrollControllerhorizontal,
                              scrollDirection: Axis.horizontal,
                              child: FutureBuilder(
                                future: gettable(dropdownvalue),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List<String> headlines = [];
                                    if (snapshot.data.isEmpty) {
                                      return const Center(
                                          child: Padding(
                                              padding: EdgeInsets.all(16),
                                              child: Text("No Data")));
                                    }
                                    snapshot.data.first.forEach((key, value) {
                                      headlines.add(key);
                                    });

                                    return DataTable(
                                      border: const TableBorder(
                                        horizontalInside: BorderSide(
                                            color: Colors.white, width: 1),
                                        verticalInside: BorderSide(
                                            color: Colors.white, width: 1),
                                      ),
                                      headingRowColor:
                                          WidgetStateColor.resolveWith(
                                              (states) =>
                                                  Colors.blue.withOpacity(0.3)),
                                      dataRowColor:
                                          WidgetStateColor.resolveWith(
                                              (states) => AppColor.nicegrey),
                                      headingRowHeight: 50,
                                      columns: headlines.map<DataColumn>(
                                        (String headline) {
                                          return DataColumn(
                                            label: SelectionArea(
                                              child: Text(
                                                headline,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          );
                                        },
                                      ).toList(),
                                      rows: snapshot.data.map<DataRow>(
                                        (Map<String, dynamic> data) {
                                          return DataRow(
                                            cells: headlines.map<DataCell>(
                                              (String headline) {
                                                return DataCell(
                                                  SelectionArea(
                                                    child: Text(
                                                      data[headline].toString(),
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ).toList(),
                                          );
                                        },
                                      ).toList(),
                                    );
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                },
                              ),
                            ))
                      ],
                    )));
          } else if (snapshot.hasError) {
            return const CircularProgressIndicator();
          }
          return const CircularProgressIndicator();
        });
  }

  Future getalltables() async {
    AbiResp response = await Chainactions().geteosclient().getAbi("cbased");
    for (var i = 0; i < response.abi!.tables!.length; i++) {
      tablelist.add(response.abi!.tables![i].name);
    }
    return true;
  }

  Future gettable(String tablename) async {
    List<Map<String, dynamic>> response = await Chainactions()
        .geteosclient()
        .getTableRows("cbased", "cbased", tablename, limit: 100);
    return response;
  }
}

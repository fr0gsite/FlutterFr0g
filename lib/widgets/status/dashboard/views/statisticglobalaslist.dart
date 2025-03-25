import 'package:flutter/material.dart';
import 'package:fr0gsite/chainactions/statisticactions.dart';
import 'package:fr0gsite/datatypes/statistics.dart';

class Statisticglobalaslist extends StatefulWidget {
  const Statisticglobalaslist({super.key});

  @override
  State<Statisticglobalaslist> createState() => _StatisticglobalaslistState();
}

class _StatisticglobalaslistState extends State<Statisticglobalaslist> {
  late Future globalstatistics;

  @override
  void initState() {
    super.initState();
    globalstatistics = getglobalstatistics();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Global statistics", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Expanded(
          child: FutureBuilder(
            future: globalstatistics,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data.isNotEmpty) {
                  return ListView.separated(
                    itemCount: snapshot.data.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              snapshot.data[index].int64number.toString(),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              snapshot.data[index].text,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ],
    );
  }

  Future<List<Statistics>> getglobalstatistics() async {
    List<Statistics> statistics = await StatisticActions().getglobalstatistics();
    debugPrint("Global statistics loaded");
    return statistics;
  }
}
import 'package:flutter/material.dart';
import 'package:fr0gsite/chainactions/statisticactions.dart';
import 'package:fr0gsite/datatypes/statistics.dart';
import 'dashboard_card.dart';

class GlobalStatisticsList extends StatefulWidget {
  const GlobalStatisticsList({super.key});

  @override
  State<GlobalStatisticsList> createState() => _GlobalStatisticsListState();
}

class _GlobalStatisticsListState extends State<GlobalStatisticsList> {
  late Future globalstatistics;

  @override
  void initState() {
    super.initState();
    globalstatistics = getglobalstatistics();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
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
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final stat = snapshot.data[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(
                            stat.text,
                            style: const TextStyle(fontSize: 16),
                          ),
                          trailing: Text(
                            stat.int64number.toString(),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
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
      )
    );
  }

  Future<List<Statistics>> getglobalstatistics() async {
    List<Statistics> statistics = await StatisticActions().getglobalstatistics();
    debugPrint("Global statistics loaded");
    return statistics;
  }
}

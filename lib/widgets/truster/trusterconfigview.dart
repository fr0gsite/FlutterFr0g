import 'package:flutter/material.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/rewardcalc.dart';
import 'package:fr0gsite/datatypes/truster.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';
import 'package:fr0gsite/config.dart';
import 'package:provider/provider.dart';

class StatusOverview extends StatefulWidget {
  const StatusOverview({super.key});

  @override
  State<StatusOverview> createState() => _StatusOverviewState();
}

class _StatusOverviewState extends State<StatusOverview> {
  bool dorefresh = true;
  late Future<RewardCalc> getRewardToken;
  late Future<List<Truster>> getTrusterInfo;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalStatus globalStatus = Provider.of<GlobalStatus>(context);
    if (dorefresh) {
      getRewardToken = Chainactions().getrewardtokeninfo(
        globalStatus.username,
      );
      getTrusterInfo = Chainactions().gettrusters();
      dorefresh = false;
    }

    return Card(
      color: AppColor.niceblack,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Colors.white, width: 2),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                AppLocalizations.of(context)!.status,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(AppLocalizations.of(context)!.changestatus, 
                    style: const TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Labels
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(title: AppLocalizations.of(context)!.claim),
                      const SizedBox(height: 8),
                      Text(AppLocalizations.of(context)!.claimable),
                      const SizedBox(height: 16),
                      const SectionHeader(title: 'Truster'),
                      const SizedBox(height: 8),
                      Text("Karma"),
                      const SizedBox(height: 8),
                      Text("In Vacation"),
                      const SizedBox(height: 8),
                      Text("Vacation Days"),
                      const SizedBox(height: 8),
                      Text("Open Reports"),
                      const SizedBox(height: 8),
                      Text(AppLocalizations.of(context)!.closedreports),
                      const SizedBox(height: 8),
                      Text(AppLocalizations.of(context)!.language),
                      const SizedBox(height: 16),
                      const SectionHeader(title: 'Settings')
                    ],
                  ),
                ),
                // Values
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 28),
                      FutureBuilder(future: getRewardToken, builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text('Loading...', style: const TextStyle(color: Colors.white));
                        } else if (snapshot.hasError) {
                          return Text('Error');
                        } else {
                          return Text('${snapshot.data!.usersupplyTRUST} TRUST', style: const TextStyle(color: Colors.white));
                        }
                      }),
                      const SizedBox(height: 50),

                      FutureBuilder(future: getTrusterInfo, builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text('Loading...', style: const TextStyle(color: Colors.white));
                        } else if (snapshot.hasError) {
                          return Text('Error');
                        } else {
                          Truster? truster = snapshot.data!.firstWhere(
                            (t) => t.trustername == globalStatus.username,
                            orElse: () => Truster.dummy(),
                          );
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${truster.karma}', style: const TextStyle(color: Colors.white)),
                              Text(truster.invacation ? AppLocalizations.of(context)!.yes : AppLocalizations.of(context)!.no, style: const TextStyle(color: Colors.white)),
                              Text('${truster.vacationdays}', style: const TextStyle(color: Colors.white)),
                              Text('${truster.numofopenreports}', style: const TextStyle(color: Colors.white)),
                              Text('${truster.numofclosedreports}', style: const TextStyle(color: Colors.white)),
                              Text(truster.language, style: const TextStyle(color: Colors.white)),
                            ],
                          );
                        }
                      }),
                      
                      Row(
                        children: [
                          const Expanded(child: Text('Deutsch/Englisch')),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Edit', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Colors.white,
      ),
    );
  }
}

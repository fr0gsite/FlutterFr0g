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
            // Status Information Table
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withAlpha((0.05 * 255).toInt()),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withAlpha((0.2 * 255).toInt()), width: 1),
              ),
              child: Column(
                children: [
                  // Claim Section
                  _buildSectionHeader(AppLocalizations.of(context)!.claim),
                  FutureBuilder(
                    future: getRewardToken, 
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildInfoRow(AppLocalizations.of(context)!.claimable, 'Loading...', isLoading: true);
                      } else if (snapshot.hasError) {
                        return _buildInfoRow(AppLocalizations.of(context)!.claimable, 'Error', isError: true);
                      } else {
                        return _buildInfoRow(AppLocalizations.of(context)!.claimable, '${snapshot.data!.usersupplyTRUST} TRUST');
                      }
                    }
                  ),
                  
                  // Truster Section
                  _buildSectionHeader('Truster'),
                  FutureBuilder(
                    future: getTrusterInfo, 
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(
                          children: [
                            _buildInfoRow('Karma', 'Loading...', isLoading: true),
                            _buildInfoRow('In Vacation', 'Loading...', isLoading: true),
                            _buildInfoRow('Vacation Days', 'Loading...', isLoading: true),
                            _buildInfoRow('Open Reports', 'Loading...', isLoading: true),
                            _buildInfoRow(AppLocalizations.of(context)!.closedreports, 'Loading...', isLoading: true),
                            _buildInfoRow(AppLocalizations.of(context)!.language, 'Loading...', isLoading: true),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return _buildInfoRow('Truster Info', 'Error', isError: true);
                      } else {
                        Truster? truster = snapshot.data!.firstWhere(
                          (t) => t.trustername == globalStatus.username,
                          orElse: () => Truster.dummy(),
                        );
                        return Column(
                          children: [
                            _buildInfoRow('Karma', '${truster.karma}'),
                            _buildInfoRow('In Vacation', truster.invacation ? AppLocalizations.of(context)!.yes : AppLocalizations.of(context)!.no),
                            _buildInfoRow('Vacation Days', '${truster.vacationdays}'),
                            _buildInfoRow('Open Reports', '${truster.numofopenreports}'),
                            _buildInfoRow(AppLocalizations.of(context)!.closedreports, '${truster.numofclosedreports}'),
                            _buildInfoRow(AppLocalizations.of(context)!.language, truster.language),
                          ],
                        );
                      }
                    }
                  ),
                  
                  // Settings Section
                  _buildSectionHeader('Settings'),
                  _buildInfoRowWithButton('Language Preference', 'Deutsch/Englisch', 'Edit', () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isLoading = false, bool isError = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(bottom: 1),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((0.02 * 255).toInt()),
        border: Border(
          bottom: BorderSide(color: Colors.white.withAlpha((0.1 * 255).toInt()), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: isLoading
                ? Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        value,
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  )
                : Text(
                    value,
                    style: TextStyle(
                      color: isError ? Colors.red[300] : Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRowWithButton(String label, String value, String buttonText, VoidCallback onPressed) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(bottom: 1),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((0.02 * 255).toInt()),
        border: Border(
          bottom: BorderSide(color: Colors.white.withAlpha((0.1 * 255).toInt()), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            width: 60,
            height: 32,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
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

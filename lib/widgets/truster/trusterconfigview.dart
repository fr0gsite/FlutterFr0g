import 'package:flutter/material.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';

class StatusOverview extends StatelessWidget {
  const StatusOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Your Status'),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child:  Text(AppLocalizations.of(context)!.changestatus),
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
                      Text(AppLocalizations.of(context)!.token),
                      Text(AppLocalizations.of(context)!.price),
                      const SizedBox(height: 16),
                      const SectionHeader(title: 'Truster'),
                      const SizedBox(height: 8),
                      const Text("Karma"),
                      Text(AppLocalizations.of(context)!.vacation),
                      Text(AppLocalizations.of(context)!.openreport),
                      Text(AppLocalizations.of(context)!.closedreports),
                      Text(AppLocalizations.of(context)!.language),
                    ],
                  ),
                ),
                // Values
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          const Expanded(child: Text('743 TRUST')),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade900,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text('Reward', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                      const Text('744 System Token'),
                      const Text('43\$'),
                      const SizedBox(height: 16),
                      const Text('600'),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade700,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text('Active', style: TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(width: 8),
                          const Text('72'),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Set'),
                          ),
                        ],
                      ),
                      const Text('2'),
                      const Text('43'),
                      Row(
                        children: [
                          const Expanded(child: Text('Deutsch/Englisch')),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade900,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
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

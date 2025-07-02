import 'package:flutter/material.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';
import 'package:fr0gsite/config.dart';

class StatusOverview extends StatelessWidget {
  const StatusOverview({super.key});

  @override
  Widget build(BuildContext context) {
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
                            ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            ),
                            child: const Text('Reward', style: TextStyle(color: Colors.white)),
                            )
                        
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
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('Active', style: TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(width: 8),
                          const Text('72'),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text('Set', style: TextStyle(color: Colors.white)),
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

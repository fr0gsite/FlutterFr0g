import 'package:flutter/material.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';

class ActionBoard extends StatelessWidget {
  const ActionBoard({super.key});

  void _notImplemented(BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Not implemented')));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Colors.white, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalizations.of(context)!.actionboard,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildAction(
              context,
              icon: Icons.list_alt,
              label: AppLocalizations.of(context)!.openreport,
              description:
                  AppLocalizations.of(context)!.actionboardreviewdesc,
            ),
            const SizedBox(height: 8),
            _buildAction(
              context,
              icon: Icons.star,
              label: AppLocalizations.of(context)!.changestatus,
              description:
                  AppLocalizations.of(context)!.actionboardstatusdesc,
            ),
            const SizedBox(height: 8),
            _buildAction(
              context,
              icon: Icons.settings,
              label: AppLocalizations.of(context)!.settings,
              description:
                  AppLocalizations.of(context)!.actionboardsettingsdesc,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String description,
  }) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () => _notImplemented(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            description,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      ],
    );
  }
}

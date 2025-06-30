import 'package:flutter/material.dart';
import "../../../../config.dart";

class DashboardCard extends StatelessWidget {
  final Widget child;
  const DashboardCard({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: AppColor.niceblack,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: child,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:world_map/world_map.dart';
import '../../../../config.dart';
import 'dashboard_card.dart';

class WorldMapStatistics extends StatefulWidget {
  const WorldMapStatistics({super.key});

  @override
  State<WorldMapStatistics> createState() => _WorldMapStatisticsState();
}

class _WorldMapStatisticsState extends State<WorldMapStatistics> {
  late final SimpleMapController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SimpleMapController();
    _controller.points = [
      SimpleMapPoint(lat: 47.5596, lng: 7.5886, color: Colors.red, radius: 4),
      SimpleMapPoint(lat: 35.6895, lng: 139.6917, color: Colors.red, radius: 4),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        children: [
          const Text('World Map',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Expanded(
            child: SimpleMap(
              controller: _controller,
              options: SimpleMapOptions(
                mapAsset: 'packages/world_map/assets/map.png',
                mapColor: AppColor.nicewhite,
                bgColor: AppColor.niceblack,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

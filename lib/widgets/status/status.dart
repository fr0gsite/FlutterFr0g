import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/widgets/status/dashboard/dashboardwidget.dart';
import 'package:fr0gsite/widgets/status/producervote.dart';
import 'package:fr0gsite/widgets/status/transactiontimeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Status extends StatefulWidget {
  const Status({super.key});

  @override
  StatusState createState() => StatusState();
}

class StatusState extends State<Status> {
  @override
  void initState() {
    super.initState();
  }

  int selectedIndex = 0;

  List<Widget> widgetOptions = <Widget>[
    const Expanded(child: TransactionTimeline()),
    const Expanded(child: Producervote()),
    Expanded(child: DashboardWidget()),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: LayoutBuilder(builder: (context, constraints) {
        return Container(
          color: AppColor.nicegrey,
          child: Column(children: [
            TabBar(
              onTap: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              dividerColor: Colors.transparent,
              unselectedLabelColor: Colors.white,
              automaticIndicatorColorAdjustment: true,
              labelColor: Colors.yellow,
              indicator: gloabltabindicator,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Stack(
                  children: [
                    Tab(
                      text: AppLocalizations.of(context)!.chainstatus,
                    ),
                  ],
                ),
                Tab(
                  text: AppLocalizations.of(context)!.blockproducers,
                ),
                Tab(
                  text: AppLocalizations.of(context)!.statistics,
                ),
              ],
            ),
            widgetOptions[selectedIndex]
          ]),
        );
      }),
    );
  }
}

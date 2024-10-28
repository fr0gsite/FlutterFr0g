import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/networkstatus.dart';
import 'package:fr0gsite/widgets/topbar/connectionoverview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConnectionOverviewtopbar extends StatefulWidget {
  const ConnectionOverviewtopbar({super.key});

  @override
  State<ConnectionOverviewtopbar> createState() =>
      _ConnectionOverviewtopbarState();
}

class _ConnectionOverviewtopbarState extends State<ConnectionOverviewtopbar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkStatus>(builder: (context, networkstatus, child) {
      return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.all(0.0)),
        ),
        onPressed: () {
          debugPrint("Open ConnectionOverview");
          showDialog(
            context: context,
            builder: (context) {
              return const ConnectionOverview();
            },
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Column(
                    children: [
                      Icon(networkstatus.connectionstatusIPFS.icon,
                          color: networkstatus.connectionstatusIPFS.color),
                      Text("IPFS",
                          style: TextStyle(
                              color: networkstatus.connectionstatusIPFS.color)),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Icon(networkstatus.connectionStatusChain.icon,
                        color: networkstatus.connectionStatusChain.color),
                    Text("Chain",
                        style: TextStyle(
                            color: networkstatus.connectionStatusChain.color)),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

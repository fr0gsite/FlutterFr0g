import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/blockchainnode.dart';
import 'package:fr0gsite/datatypes/ipfsnode.dart';
import 'package:fr0gsite/datatypes/networkstatus.dart';
import 'package:flutter/material.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';
import 'package:fr0gsite/widgets/topbar/customconnectionchain.dart';
import 'package:fr0gsite/widgets/topbar/customconnectionipfs.dart';
import 'package:provider/provider.dart';

class ConnectionOverview extends StatefulWidget {
  const ConnectionOverview({super.key});

  @override
  State<ConnectionOverview> createState() => _ConnectionOverviewState();
}

class _ConnectionOverviewState extends State<ConnectionOverview> {
  TextEditingController ipfsdropdowncontroller = TextEditingController();
  TextEditingController chaindropdowncontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<NetworkStatus>(context, listen: false)
        .testallIPFSNodes()
        .then((value) {
      //Wait 1 second
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            debugPrint("Tested all IPFS Nodes");
          });
        }
      });
    });

    Provider.of<NetworkStatus>(context, listen: false)
        .testallChainNodes()
        .then((value) {
      //Wait 1 second
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            debugPrint("Tested all Chain Nodes");
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> connectionstatustext = [
      AppLocalizations.of(context)!.connected,
      AppLocalizations.of(context)!.connecting,
      AppLocalizations.of(context)!.disconnected,
      AppLocalizations.of(context)!.error
    ];

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        child: Material(
          color: AppColor.nicegrey,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              side: BorderSide(color: Colors.white, width: 6)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                AppLocalizations.of(context)!.connectionoverview,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            body: Consumer<NetworkStatus>(
                builder: (context, networkstatus, child) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(AppLocalizations.of(context)!.ipfsnodes,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const Spacer(),
                        //Checkbox for Automatic IPFS Node Selection
                        Tooltip(
                          message: AppLocalizations.of(context)!
                              .automaticchooseipfsnode,
                          child: Row(
                            children: [
                              Checkbox(
                                value: networkstatus.automaticipfsnode,
                                activeColor: Colors.white,
                                checkColor: Colors.black,
                                onChanged: (value) {
                                  networkstatus.setAutomaticIPFSNode(value!);
                                },
                                focusColor: Colors.white,
                              ),
                              Text(AppLocalizations.of(context)!.automatic,
                                  style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),

                        const Spacer(),
                        Text(
                            connectionstatustext[
                                networkstatus.connectionstatusIPFS.index],
                            style: TextStyle(
                                color:
                                    networkstatus.connectionstatusIPFS.color)),
                        const Spacer(),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(AppLocalizations.of(context)!.ipfsexplain,
                          style: const TextStyle(color: Colors.grey)),
                    ),
                    Stack(
                      children: [
                        DropdownMenu(
                          key: UniqueKey(),
                          enabled: !networkstatus.automaticipfsnode,
                          textStyle: TextStyle(
                              color: networkstatus.automaticipfsnode
                                  ? Colors.grey
                                  : Colors.white),
                          expandedInsets: const EdgeInsets.all(8),
                          leadingIcon: Icon(
                              networkstatus.connectionstatusIPFS.icon,
                              color: networkstatus.connectionstatusIPFS.color),
                          controller: ipfsdropdowncontroller,
                          initialSelection: networkstatus.currentipfsnode.name,
                          dropdownMenuEntries:
                              networkstatus.ipfsnodes.map((IPFSNode ipfsnode) {
                            return DropdownMenuEntry(
                              leadingIcon: Icon(ipfsnode.connectionstatus.icon,
                                  color: ipfsnode.connectionstatus.color),
                              label:
                                  "${ipfsnode.name} - ${ipfsnode.averagerequesttime()}ms",
                              value: ipfsnode.name,
                            );
                          }).toList(),
                          onSelected: (value) {
                            IPFSNode node = networkstatus.ipfsnodes
                                .firstWhere((element) => element.name == value);
                            networkstatus.setIPFSNode(node);
                          },
                        ),
                        if (networkstatus.automaticipfsnode)
                          const Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.lock,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    OverflowBar(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const CustomConnectionIPFS();
                              },
                            );
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all<Color>(Colors.blue),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              )),
                          child: Text(
                              AppLocalizations.of(context)!.customipfsnode,
                              style: const TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              AppLocalizations.of(context)!.blockchainnodes,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const Spacer(),
                        Tooltip(
                          message: AppLocalizations.of(context)!
                              .automaticchooseblockchainnode,
                          child: Row(
                            children: [
                              Checkbox(
                                value: networkstatus.automaticblockchainnode,
                                activeColor: Colors.white,
                                checkColor: Colors.black,
                                onChanged: (value) {
                                  networkstatus
                                      .setAutomaticBlockchainNode(value!);
                                },
                                focusColor: Colors.white,
                              ),
                              Text(AppLocalizations.of(context)!.automatic,
                                  style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(
                            connectionstatustext[
                                networkstatus.connectionStatusChain.index],
                            style: TextStyle(
                                color:
                                    networkstatus.connectionStatusChain.color)),
                        const Spacer(),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(AppLocalizations.of(context)!.chainexplain,
                          style: const TextStyle(color: Colors.grey)),
                    ),
                    Stack(
                      children: [
                        DropdownMenu(
                          key: UniqueKey(),
                          enabled: !networkstatus.automaticblockchainnode,
                          textStyle: TextStyle(
                              color: networkstatus.automaticblockchainnode
                                  ? Colors.grey
                                  : Colors.white),
                          expandedInsets: const EdgeInsets.all(8),
                          leadingIcon: Icon(
                              networkstatus.connectionStatusChain.icon,
                              color: networkstatus.connectionStatusChain.color),
                          controller: chaindropdowncontroller,
                          initialSelection:
                              networkstatus.currentblockchainnode.name,
                          dropdownMenuEntries: networkstatus.blockchainnodes
                              .map((Blockchainnode blockchainnode) {
                            return DropdownMenuEntry(
                              leadingIcon: Icon(
                                  blockchainnode.connectionstatus.icon,
                                  color: blockchainnode.connectionstatus.color),
                              label:
                                  "${blockchainnode.name} - ${blockchainnode.averagerequesttime()}ms",
                              value: blockchainnode.name,
                            );
                          }).toList(),
                          onSelected: (value) {
                            Blockchainnode node = networkstatus.blockchainnodes
                                .firstWhere((element) => element.name == value);
                            networkstatus.setBlockchainNode(node);
                          },
                        ),
                        if (networkstatus.automaticblockchainnode)
                          const Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.lock,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    OverflowBar(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const CustomConnectionChain();
                              },
                            );
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all<Color>(Colors.blue),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              )),
                          child: Text(
                              AppLocalizations.of(context)!
                                  .customblockchainnode,
                              style: const TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

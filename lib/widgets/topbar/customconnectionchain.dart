import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fr0gsite/config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fr0gsite/datatypes/blockchainnode.dart';
import 'package:fr0gsite/datatypes/networkstatus.dart';
import 'package:provider/provider.dart';

class CustomConnectionChain extends StatefulWidget {
  const CustomConnectionChain({super.key});

  @override
  State<CustomConnectionChain> createState() => _CustomConnectionChainState();
}

enum Protocol { http, https }

enum ApiVersion { v1 }

class _CustomConnectionChainState extends State<CustomConnectionChain> {
  String fullurlexample = '';
  Protocol? choosenprotocoll = Protocol.http;
  ApiVersion? choosenapi = ApiVersion.v1;

  TextEditingController connectionname = TextEditingController();
  TextEditingController connectionaddress = TextEditingController();
  TextEditingController connectionport = TextEditingController();

  bool buttonactive = false;

  @override
  void initState() {
    super.initState();
    connectionname.addListener(() {
      setState(() {
        updateexample();
      });
    });

    connectionaddress.addListener(() {
      setState(() {
        updateexample();
      });
    });

    connectionport.addListener(() {
      setState(() {
        updateexample();
      });
    });
  }

  void updateexample() {
    setState(() {
      fullurlexample =
          choosenprotocoll == Protocol.http ? "http://" : "https://";
      fullurlexample += connectionaddress.text;
      fullurlexample += ":";
      fullurlexample += connectionport.text;

      if (connectionname.text.isNotEmpty &&
          connectionaddress.text.isNotEmpty &&
          connectionport.text.isNotEmpty) {
        buttonactive = true;
      } else {
        buttonactive = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                AppLocalizations.of(context)!.customipfsnode,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            body: Consumer<NetworkStatus>(
                builder: (context, networkstatus, child) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: connectionname,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.connectionname,
                        labelStyle: const TextStyle(color: Colors.white),
                        hintText: networkstatus.currentblockchainnode.name,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  // Radio Buttons for Protokoll HTTP or HTTPS
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Radio(
                          value: Protocol.http,
                          groupValue: choosenprotocoll,
                          onChanged: (value) {
                            setState(() {
                              choosenprotocoll = value;
                              updateexample();
                            });
                          },
                        ),
                        const Text(
                          "http",
                          style: TextStyle(color: Colors.white),
                        ),
                        Radio(
                          value: Protocol.https,
                          groupValue: choosenprotocoll,
                          onChanged: (value) {
                            setState(() {
                              choosenprotocoll = value;
                              updateexample();
                            });
                          },
                        ),
                        const Text(
                          "https",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: connectionaddress,
                      decoration: InputDecoration(
                        labelText:
                            AppLocalizations.of(context)!.connectionaddress,
                        labelStyle: const TextStyle(color: Colors.white),
                        hintText: networkstatus.currentblockchainnode.url,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: connectionport,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.connectionport,
                        labelStyle: const TextStyle(color: Colors.white),
                        hintText: networkstatus.currentblockchainnode.port,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(fullurlexample,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18))),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        debugPrint("Test Chain Node");
                        Blockchainnode node = Blockchainnode(
                            1,
                            connectionname.text,
                            connectionaddress.text,
                            connectionport.text,
                            choosenprotocoll!.name,
                            choosenapi!.name);
                        networkstatus.checkConnectionChain(node).then(
                          (value) {
                            if (value == -1) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocalizations.of(context)!
                                        .connectionfailed,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocalizations.of(context)!
                                        .connectionsuccessfull,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          },
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.testhere),
                    ),
                  ),

                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: buttonactive
                            ? WidgetStateProperty.all<Color>(Colors.white)
                            : WidgetStateProperty.all<Color>(Colors.grey)),
                    onPressed: () {
                      if (buttonactive) {
                        Blockchainnode node = Blockchainnode(
                            1,
                            connectionname.text,
                            connectionaddress.text,
                            connectionport.text,
                            choosenprotocoll!.name,
                            choosenapi!.name);
                        // Add Node to List
                        networkstatus.setBlockchainNode(node);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(AppLocalizations.of(context)!.save),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

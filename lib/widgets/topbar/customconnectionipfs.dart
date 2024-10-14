import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/ipfsnode.dart';
import 'package:fr0gsite/datatypes/networkstatus.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomConnectionIPFS extends StatefulWidget {
  const CustomConnectionIPFS({super.key});

  @override
  State<CustomConnectionIPFS> createState() => _CustomConnectionIPFSState();
}

enum Protocol { http, https }

enum Method { get, post }

class _CustomConnectionIPFSState extends State<CustomConnectionIPFS> {
  String fullurlexample = '';
  Protocol? choosenprotocoll = Protocol.http;
  Method? choosenmethode = Method.get;

  TextEditingController connectionname = TextEditingController();
  TextEditingController connectionaddress = TextEditingController();
  TextEditingController connectionport = TextEditingController();
  TextEditingController connectionpath = TextEditingController();

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

    connectionpath.addListener(() {
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
      fullurlexample += connectionpath.text;

      if (connectionname.text.isNotEmpty &&
          connectionaddress.text.isNotEmpty &&
          connectionport.text.isNotEmpty &&
          connectionpath.text.isNotEmpty) {
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
                        hintText: "IPFS Node",
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
                        hintText: "ipfs.fr0g.site",
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
                        hintText: "443",
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
                      controller: connectionpath,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.connectionpath,
                        labelStyle: const TextStyle(color: Colors.white),
                        hintText: "/ipfs/",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Radio(
                          value: Method.get,
                          groupValue: choosenmethode,
                          onChanged: (value) {
                            setState(() {
                              choosenmethode = value;
                            });
                          },
                        ),
                        const Text(
                          "GET",
                          style: TextStyle(color: Colors.white),
                        ),
                        Radio(
                          value: Method.post,
                          groupValue: choosenmethode,
                          onChanged: (value) {
                            setState(() {
                              choosenmethode = value;
                            });
                          },
                        ),
                        const Text(
                          "POST",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
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
                        debugPrint("Test IPFS Node");
                        IPFSNode node = IPFSNode(
                            connectionname.text,
                            choosenprotocoll!.name,
                            connectionaddress.text,
                            int.parse(connectionport.text),
                            connectionpath.text,
                            choosenmethode!.name);
                        networkstatus.checkConnectionIPFS(node).then(
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
                        IPFSNode node = IPFSNode(
                            connectionname.text,
                            choosenprotocoll!.name,
                            connectionaddress.text,
                            int.parse(connectionport.text),
                            connectionpath.text,
                            choosenmethode!.name);
                        networkstatus.setIPFSNode(node);
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

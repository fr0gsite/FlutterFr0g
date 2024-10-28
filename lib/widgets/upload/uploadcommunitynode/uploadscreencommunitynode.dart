import 'package:flutter/material.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/ipfsuploadnode.dart';
import 'package:fr0gsite/datatypes/uploadfeedback.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fr0gsite/datatypes/uploadfilestatus.dart';
import 'package:fr0gsite/widgets/upload/uploadcommunitynode/uploadcommunitynodeproviderlist.dart';
import 'package:fr0gsite/widgets/upload/uploadcommunitynode/uploadcommunitynodeuploadchoosefiles.dart';
import 'package:provider/provider.dart';

class UploadScreencommunitynode extends StatefulWidget {
  const UploadScreencommunitynode({super.key, required this.feedback});

  final void Function(bool success, UploadFeedback uploadfeedback) feedback;

  @override
  State<UploadScreencommunitynode> createState() =>
      _UploadScreencommunitynodeState();
}

//States
// seaching nodes
// check quota
// offer providers
// op: send token to provider
// set sec pub key
// upload with sec priv key
// get ipfs informatoin and set values in next screen

class _UploadScreencommunitynodeState extends State<UploadScreencommunitynode> {
  late Map<UploadFileStates, String> uploadstates;
  UploadFileStates uploadstate = UploadFileStates.searchingnodes;
  late Future initfuture;

  @override
  void initState() {
    super.initState();
    initfuture = init();
  }

  Future<bool> init() async {
    List<IPFSUploadNode> ipfsnodes = AppConfig.ipfsuploadnodes;

    //Check connection
    List<Future> ipfsnodesfutures = [];
    for (var ipfsnode in ipfsnodes) {
      ipfsnodesfutures
          .add(ipfsnode.testconnection().timeout(const Duration(seconds: 2)));
    }
    await Future.wait(ipfsnodesfutures);
    ipfsnodes.removeWhere((element) => element.online == false);

    //Check Quota
    setState(() {
      uploadstate = UploadFileStates.checkquota;
    });
    List<Future> checkquotafutures = [];
    for (var ipfsnode in ipfsnodes) {
      if (mounted) {
        String username =
            Provider.of<GlobalStatus>(context, listen: false).username;
        checkquotafutures.add(ipfsnode.checkuserslots(username));
      }
    }
    await Future.wait(checkquotafutures);

    //Offer Providers
    setState(() {
      uploadstate = UploadFileStates.selectproviders;
    });
    if (mounted) {
      Provider.of<UploadFileStatus>(context, listen: false).nodes = ipfsnodes;
    }

    return true;
  }

  void feedbackofferprovider(IPFSUploadNode node) {
    setState(() {
      uploadstate = UploadFileStates.choosefiles;
    });
  }

  void feedbackuploadfiles(bool success, UploadFeedback uploadfeedback) {
    widget.feedback(success, uploadfeedback);
  }

  @override
  Widget build(BuildContext context) {
    uploadstates = {
      UploadFileStates.searchingnodes:
          AppLocalizations.of(context)!.searchingnodes,
      UploadFileStates.checkquota: AppLocalizations.of(context)!.checkquota,
      UploadFileStates.selectproviders:
          AppLocalizations.of(context)!.selectprovider,
      UploadFileStates.choosefiles: AppLocalizations.of(context)!.choosefiles,
    };

    return ChangeNotifierProvider(
      create: (context) => UploadFileStatus(),
      builder: (context, child) {
        return Consumer<UploadFileStatus>(
          builder: (context, uploadfilestatus, child) {
            return Center(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: 800,
                  height: 800,
                  child: Material(
                    color: AppColor.nicegrey,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        side: BorderSide(
                          color: Colors.white,
                          width: 6,
                        )),
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      resizeToAvoidBottomInset: true,
                      appBar: AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        leading: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      body: Column(
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                uploadstates[uploadstate]!,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 30),
                              ),
                            ),
                          ),
                          FutureBuilder(
                            future: initfuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (uploadstate ==
                                    UploadFileStates.selectproviders) {
                                  return ProviderList(
                                      feedback: feedbackofferprovider);
                                }
                                if (uploadstate ==
                                    UploadFileStates.choosefiles) {
                                  return UploadChooseFiles(
                                      feedback: feedbackuploadfiles);
                                }
                              } else {
                                return const SizedBox.shrink();
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          const Spacer(),
                          if (uploadstate == UploadFileStates.checkquota ||
                              uploadstate == UploadFileStates.searchingnodes)
                            const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          const Spacer(),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all<Color>(Colors.red),
                              shape: WidgetStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                AppLocalizations.of(context)!.cancel,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

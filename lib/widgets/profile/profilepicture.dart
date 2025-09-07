import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/userconfig.dart';
import 'package:fr0gsite/ipfsactions.dart';
import 'package:fr0gsite/nameconverter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';

class Profilepicture extends StatefulWidget {
  final String accountname;
  const Profilepicture({super.key, required this.accountname});

  @override
  State<Profilepicture> createState() => _ProfilepictureState();
}

enum ProfilePictureStatus { loading, loaded, timeout, error }

class _ProfilepictureState extends State<Profilepicture> {
  late Future getprofilepicturefuture;
  String accountname = "";
  ProfilePictureStatus status = ProfilePictureStatus.loading;

  @override
  void initState() {
    super.initState();
    accountname = widget.accountname;
    getprofilepicturefuture = getProfilePicture(context, widget.accountname)
      ..timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          debugPrint("Timeout: Profilepicture");
          if (mounted) {
            setState(() {
              getprofilepicturefuture =
                  rootBundle.load("assets/images/black.png").then((value) {
                status = ProfilePictureStatus.timeout;
                return value.buffer.asUint8List();
              });
            });
          }

          return rootBundle.load("assets/images/black.png").then((value) {
            status = ProfilePictureStatus.timeout;
            return value.buffer.asUint8List();
          });
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    if (accountname != widget.accountname) {
      setState(() {
        accountname = widget.accountname;
        getprofilepicturefuture =
            getProfilePicture(context, widget.accountname);
      });
    }

    return FutureBuilder(
      future: getprofilepicturefuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.black.withAlpha((0.4 * 255).toInt()),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(children: [
              Image.memory(
                snapshot.data as Uint8List,
                height: 256,
                width: 256,
              ),
              status == ProfilePictureStatus.timeout
                  ? Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                            AppLocalizations.of(context)!
                                .profilepictureloadingtimeout,
                            style: const TextStyle(color: Colors.white)),
                      ),
                    )
                  : Container()
            ]),
          );
        } else {
          return Container(
            decoration: BoxDecoration(
              color: Colors.black.withAlpha((0.4 * 255).toInt()),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(children: [
              Image.asset(
                "assets/images/black.png",
                height: 256,
                width: 256,
              ),
              const Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 10.0,
                    strokeAlign: 20.0,
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(AppLocalizations.of(context)!.loading,
                      style: const TextStyle(color: Colors.white)),
                ),
              )
            ]),
          );
        }
      },
    );
  }

  Future<Uint8List> getProfilePicture(BuildContext context, String username) async {
    BigInt userid = NameConverter.nameToUint64(username);
    bool foundexisting = false;
    late UserConfig userconfig;
    List<UserConfig> tempuserconfig =
        Provider.of<GlobalStatus>(context, listen: false).userconfiglist;

    for (int i = 0; i < tempuserconfig.length; i++) {
      if (tempuserconfig[i].configid == userid) {
        userconfig = tempuserconfig[i];
        foundexisting = true;
      }
    }

    if (!foundexisting) {
      userconfig = await Chainactions().getuserconfig(username);
      Provider.of<GlobalStatus>(context, listen: false)
          .userconfiglist
          .add(userconfig);
    }

    try {
      Uint8List temp = await IPFSActions.fetchipfsdata(
          context, userconfig.profileimageipfs.toString());
      if (temp.isNotEmpty) {
        status = ProfilePictureStatus.loaded;
        return temp;
      } else {
        debugPrint("Profilepicture data empty");
        status = ProfilePictureStatus.error;
        return rootBundle.load("assets/images/black.png").then((value) {
          return value.buffer.asUint8List();
        });
      }
    } catch (e) {
      debugPrint("Profilepicture loading error: $e");
      status = ProfilePictureStatus.error;
      return rootBundle.load("assets/images/black.png").then((value) {
        return value.buffer.asUint8List();
      });
    }
  }
}

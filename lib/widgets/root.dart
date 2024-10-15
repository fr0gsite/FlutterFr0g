import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/localstorage.dart';
import 'package:fr0gsite/utils/utils.dart';
import 'package:fr0gsite/widgets/disclaimer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Root extends StatefulWidget {
  final String? destination;
  const Root({super.key, this.destination});

  @override
  State<Root> createState() => _Root();
}

class _Root extends State<Root> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //Check if the user has accepted the disclaimer
      readlocaluserconfig(context).then((value) {
        if (!Provider.of<GlobalStatus>(context, listen: false)
            .localuserconfig
            .accepteddisclaimer) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const GlobalDisclaimer());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("In Root Widget");
    getPlatform(context);

    return Container(color: Colors.black);
  }
}

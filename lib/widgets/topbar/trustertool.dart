import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/truster.dart';
import 'package:fr0gsite/widgets/truster/trusterview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TrusterTool extends StatefulWidget {
  const TrusterTool({super.key});

  @override
  State<TrusterTool> createState() => _TrusterToolState();
}

class _TrusterToolState extends State<TrusterTool> {
  int numberofopenreports = 0;

  @override
  void initState() {
    super.initState();
    getnumberofopenreports().then((value) {
      setState(() {
        numberofopenreports = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalStatus>(builder: (context, userstatus, child) {
      if (userstatus.userconfig.istruster) {
        return ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: ((context) {
                  return const TrusterView();
                }));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.visibility_rounded, color: Colors.yellow),
              Text("${AppLocalizations.of(context)!.openreport}:$numberofopenreports", style: const TextStyle(color: Colors.yellow))
            ],
          ),
        );
      } else {
        return Container();
      }
    });
  }

  Future<int> getnumberofopenreports() async {
    Chainactions chainactions = Chainactions();
    String username = Provider.of<GlobalStatus>(context, listen: false).username;
    Truster truster = await chainactions.gettruster(username);
    return truster.numofopenreports;
  }
}

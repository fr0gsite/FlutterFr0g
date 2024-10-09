import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/widgets/truster/trusterview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrusterTool extends StatefulWidget {
  const TrusterTool({super.key});

  @override
  State<TrusterTool> createState() => _TrusterToolState();
}

class _TrusterToolState extends State<TrusterTool> {
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
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.visibility_rounded, color: Colors.yellow),
              Text("Open:4", style: TextStyle(color: Colors.yellow))
            ],
          ),
        );
      } else {
        return Container();
      }
    });
  }
}

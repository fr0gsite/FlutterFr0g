import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/widgets/upload/upload.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UploadButton extends StatelessWidget {
  const UploadButton({super.key});

  @override
  Widget build(BuildContext context) {
    if (Provider.of<GlobalStatus>(context).isLoggedin) {
      return IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: ((context) {
                return const Upload();
              }));
        },
        icon: const Icon(Icons.arrow_circle_up, color: Colors.white),
      );
    } else {
      return Container();
    }
  }
}

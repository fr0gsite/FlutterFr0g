import 'package:fr0gsite/config.dart';
import 'package:flutter/material.dart';

class ProducervoteDialog extends StatefulWidget {
  const ProducervoteDialog({super.key});

  @override
  State<ProducervoteDialog> createState() => _ProducervoteDialogState();
}

class _ProducervoteDialogState extends State<ProducervoteDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: const SingleChildScrollView(
        child: SizedBox(
          width: 500.0,
          child: Material(
            color: AppColor.nicegrey,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                side: BorderSide(
                  color: Colors.blue,
                  width: 6,
                )),
            child: Center(
              child: Column(
                children: [Text("Test")],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

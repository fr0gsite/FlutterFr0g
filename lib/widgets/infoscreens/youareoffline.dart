import 'package:fr0gsite/config.dart';
import 'package:flutter/material.dart';

class Youareoffline extends StatelessWidget {
  const Youareoffline({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.nicegrey,
      child: const Center(child: Text("You are offline")),
    );
  }
}

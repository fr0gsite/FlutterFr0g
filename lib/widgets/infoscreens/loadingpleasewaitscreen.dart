import 'dart:typed_data';

import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/ipfsactions.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loadingpleasewaitscreen extends StatelessWidget {
  final String? thumbhash;
  const Loadingpleasewaitscreen({super.key, this.thumbhash});

  @override
  Widget build(BuildContext context) {
    // Determine screen height
    double screenHeight = MediaQuery.of(context).size.height;

    // Account for AppBar height (if present) and system status bar (around 80 - 100 pixels).
    // Adjust this value to fit your needs.
    double reservedHeight = 100;

    // Calculate available height by subtracting the reserved height from the full screen height.
    double availableHeight = screenHeight - reservedHeight;

    // Divide the available height by 3 to distribute it among the three elements.
    double elementheight = availableHeight / 8;

    return Material(
        child: Container(
      color: AppColor.nicegrey,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (thumbhash != null)
              FutureBuilder<Uint8List>(
                  future: IPFSActions.fetchipfsdata(context, thumbhash),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData &&
                        snapshot.data!.isNotEmpty) {
                      return Image.memory(snapshot.data!,
                          height: elementheight * 4 /2, fit: BoxFit.contain);
                    }
                    return SizedBox(height: elementheight * 4 /2);
                  }),
            Lottie.asset('assets/lottie/loadingdots.json',
                repeat: true, animate: true, height: elementheight * 4 /2),
          ],
        ),
      ),
    ));
  }
}

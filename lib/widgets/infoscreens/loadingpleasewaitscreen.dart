import 'package:fr0gsite/config.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loadingpleasewaitscreen extends StatelessWidget {
  final ValueNotifier<double> downloadProgress;

  const Loadingpleasewaitscreen({super.key, required this.downloadProgress});

  @override
  Widget build(BuildContext context) {
    // Bildschirmhöhe ermitteln
    double screenHeight = MediaQuery.of(context).size.height;

    // Höhe für AppBar (wenn vorhanden) und Systemstatusleiste (etwa 80 - 100 Pixel) berücksichtigen.
    // Diesen Wert können Sie an Ihre Bedürfnisse anpassen.
    double reservedHeight = 100;

    // Verfügbare Höhe ermitteln, indem die reservierte Höhe von der gesamten Bildschirmhöhe abgezogen wird.
    double availableHeight = screenHeight - reservedHeight;

    // Die verfügbare Höhe durch 3 teilen, um sie zwischen den drei Elementen aufzuteilen.
    double elementheight = availableHeight / 8;

    return Material(
        child: Container(
      color: AppColor.nicegrey,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/lottie/loadingdots.json',
                repeat: true, animate: true, height: elementheight * 6),
            SizedBox(height: elementheight),
            ValueListenableBuilder<double>(
              valueListenable: downloadProgress,
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                );
              },
            ),
          ],
        ),
      ),
    ));
  }
}

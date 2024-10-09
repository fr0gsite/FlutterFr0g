import 'dart:async';
import 'package:fr0gsite/config.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessUpload extends StatefulWidget {
  const SuccessUpload({super.key});

  @override
  SuccessUploadState createState() => SuccessUploadState();
}

class SuccessUploadState extends State<SuccessUpload> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer(const Duration(seconds: 6), () {
      Navigator.of(context).pop(); // Schließt das Widget nach 5 Sekunden
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 800,
        width: 800,
        child: Container(
          padding: const EdgeInsets.all(20),
          color: AppColor.nicegrey,
          child: Center(
            child: Column(
              children: [
                Lottie.asset('assets/lottie/celebration.json',
                    fit: BoxFit.fill, repeat: false, height: 300),
                const Text(
                  "Upload successful",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

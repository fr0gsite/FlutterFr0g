import 'package:auto_size_text/auto_size_text.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Walletreceive extends StatefulWidget {
  const Walletreceive({super.key});

  @override
  State<Walletreceive> createState() => _WalletreceiveState();
}

class _WalletreceiveState extends State<Walletreceive> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 16),
          child: AutoSizeText(
            "Scan this QR code to send money to: ${Provider.of<GlobalStatus>(context, listen: false).username}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: QrImageView(
                data:
                    "cb:actions:sendto:${Provider.of<GlobalStatus>(context, listen: false).username}",
                version: QrVersions.auto,
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

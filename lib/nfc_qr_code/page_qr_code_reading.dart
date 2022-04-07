import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class PageQRCodeReading extends StatefulWidget {
  PageQRCodeReading({Key? key}) : super(key: key);

  _PageQRCodeReadingState createState() => _PageQRCodeReadingState();
}

class _PageQRCodeReadingState extends State<PageQRCodeReading> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late Barcode result;
  late QRViewController controller;
  bool hasQrCodeReading = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();

    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Veuillez scanner votre QR Code.'),
      content: Container(
        margin: const EdgeInsets.only(bottom: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        height: 300,
        child: QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
              borderColor: Colors.black,
              borderWidth: 10,
              borderRadius: 10,
              borderLength: 30),
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      if (!hasQrCodeReading) {
        setState(() {
          hasQrCodeReading = true;
        });

        FlutterBeep.beep();

        this.controller.stopCamera();

        print('Qrcode detected !');
        print(scanData.code);
        print(scanData.rawBytes);

        setState(() {
          result = scanData;
        });
        Navigator.of(context).pop(scanData.code);
      }
    });
  }
}

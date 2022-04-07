import 'dart:io' show Platform;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> createCustomMarkerBitmap(String title) async {
  TextSpan span = new TextSpan(
    style: new TextStyle(
      color: Colors.black,
      fontSize: 40.0,
      fontWeight: FontWeight.bold,
    ),
    text: title,
  );

  TextPainter tp = new TextPainter(
      textScaleFactor: (Platform.isAndroid) ? 1 : 0.7,
      text: span,
      textAlign: TextAlign.center,
      textDirection: ui.TextDirection.ltr);
  tp.text = TextSpan(
    text: title.toString(),
    style: TextStyle(
      fontSize: 40.0,
      color: Color.fromRGBO(0, 125, 188, 1),
      letterSpacing: 1.0,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w700,
      background: Paint()
        ..color = Colors.transparent
        ..style = PaintingStyle.fill,
    ),
  );

  ui.PictureRecorder fakerecorder = new ui.PictureRecorder();
  Paint paintFill = new Paint()..color = Colors.white;
  Paint paintBorder = new Paint()
    ..color = Color.fromRGBO(0, 125, 188, 1)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 5;
  Paint paintShadow = new Paint()
    ..color = Color.fromRGBO(0, 83, 125, 0.1)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 5;
  // ignore: unused_local_variable
  Canvas cc = new Canvas(fakerecorder);

  tp.layout();
  final RRect rrect = RRect.fromLTRBR(
    2,
    2,
    tp.size.width + 30,
    tp.size.height + 30,
    Radius.circular(10),
  );
  final RRect rrectShadow = RRect.fromLTRBR(
    0,
    0,
    tp.size.width + 34,
    tp.size.height + 34,
    Radius.circular(10),
  );
  // ignore: unused_local_variable
  ui.Picture pi = fakerecorder.endRecording();
  ui.PictureRecorder recorder = new ui.PictureRecorder();
  Canvas c = new Canvas(recorder);
  c.drawRRect(rrectShadow, paintShadow);
  c.drawRRect(rrect, paintFill);
  c.drawRRect(rrect, paintBorder);
  tp.layout();
  tp.paint(c, new Offset(15.0, 15.0));

  ui.Picture p = recorder.endRecording();
  ByteData? pngBytes =
      await (await p.toImage(tp.width.toInt() + 34, tp.height.toInt() + 34))
          .toByteData(format: ui.ImageByteFormat.png);

  Uint8List data = Uint8List.view(pngBytes!.buffer);

  return BitmapDescriptor.fromBytes(data);
}

Future<BitmapDescriptor> createCustomMarkerBitmapSelected(String title) async {
  TextSpan span = new TextSpan(
    style: new TextStyle(
      color: Colors.black,
      fontSize: 40.0,
      fontWeight: FontWeight.bold,
    ),
    text: title,
  );

  TextPainter tp = new TextPainter(
      textScaleFactor: (Platform.isAndroid) ? 1 : 0.7,
      text: span,
      textAlign: TextAlign.center,
      textDirection: ui.TextDirection.ltr);
  tp.text = TextSpan(
    text: title.toString(),
    style: TextStyle(
      fontSize: 40.0,
      color: Colors.white,
      letterSpacing: 1.0,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w700,
      background: Paint()
        ..color = Colors.transparent
        ..style = PaintingStyle.fill,
    ),
  );

  ui.PictureRecorder fakerecorder = new ui.PictureRecorder();
  Paint paintFill = new Paint()..color = Color.fromRGBO(0, 125, 188, 1);
  Paint paintBorder = new Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 5;
  Paint paintShadow = new Paint()
    ..color = Color.fromRGBO(0, 83, 125, 0.1)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 5;
  // ignore: unused_local_variable
  Canvas cc = new Canvas(fakerecorder);

  tp.layout();
  final RRect rrect = RRect.fromLTRBR(
    2,
    2,
    tp.size.width + 30,
    tp.size.height + 30,
    Radius.circular(10),
  );
  final RRect rrectShadow = RRect.fromLTRBR(
    0,
    0,
    tp.size.width + 34,
    tp.size.height + 34,
    Radius.circular(10),
  );
  // ignore: unused_local_variable
  ui.Picture pi = fakerecorder.endRecording();
  ui.PictureRecorder recorder = new ui.PictureRecorder();
  Canvas c = new Canvas(recorder);
  c.drawRRect(rrectShadow, paintShadow);
  c.drawRRect(rrect, paintFill);
  c.drawRRect(rrect, paintBorder);
  tp.layout();
  tp.paint(c, new Offset(15.0, 15.0));

  ui.Picture p = recorder.endRecording();
  ByteData? pngBytes =
      await (await p.toImage(tp.width.toInt() + 34, tp.height.toInt() + 34))
          .toByteData(format: ui.ImageByteFormat.png);

  Uint8List data = Uint8List.view(pngBytes!.buffer);

  return BitmapDescriptor.fromBytes(data);
}

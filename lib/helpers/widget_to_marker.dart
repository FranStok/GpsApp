import 'dart:ui' as UI;
import 'package:google_maps_flutter/google_maps_flutter.dart'
    show BitmapDescriptor;
import 'package:gps_app/markers/markers.dart';

Future<BitmapDescriptor> getStartCustomMarker(
    int minutes, String destination) async {
  final recorder = UI.PictureRecorder();
  final canvas = UI.Canvas(recorder);
  const size = UI.Size(350, 150);

  final startMarker =
      StartMarkerPainter(minutes: minutes, destination: destination);
  startMarker.paint(canvas, size);
  final picture = recorder.endRecording();
  final image = await picture.toImage(size.width.toInt(), size.height.toInt());
  final byteData = await image.toByteData(format: UI.ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
}
Future<BitmapDescriptor> getEndCustomMarker(
    int kilometers, String destination) async {
  final recorder = UI.PictureRecorder();
  final canvas = UI.Canvas(recorder);
  const size = UI.Size(350, 150);

  final endMarker =
      EndMarkerPainter(kilometers: kilometers, destination: destination);
  endMarker.paint(canvas, size);
  final picture = recorder.endRecording();
  final image = await picture.toImage(size.width.toInt(), size.height.toInt());
  final byteData = await image.toByteData(format: UI.ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
}

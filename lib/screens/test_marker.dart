import 'package:flutter/material.dart';
import 'package:gps_app/markers/markers.dart';


class TestMarkerScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.red,
          width: 350,
          height: 150,
          child: CustomPaint(
            painter: StartMarkerPainter(destination: "Rooster rest & Snack-bar", minutes: 50),
          ),
        ),
     ),
   );
  }
}
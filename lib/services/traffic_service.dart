import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrafficService {
  final Dio _dioTraffic;
  final String _baseTrafficUrl = "https://api.mapbox.com/directions/v5/mapbox";

  TrafficService() : _dioTraffic = Dio();

  Future getCoorsStartToEnd(LatLng start, LatLng end) async {
    final coordsString =
        "${start.longitude},${start.latitude};${end.longitude},${end.latitude}";
    final url = "$_baseTrafficUrl/driving/$coordsString";

    final response = await _dioTraffic.get(url);
    return response.data;
  }
}

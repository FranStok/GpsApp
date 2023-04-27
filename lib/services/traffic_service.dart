import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_app/models/models.dart';
import 'package:gps_app/services/services.dart';

class TrafficService {
  final Dio _dioTraffic;
  final String _baseTrafficUrl = "https://api.mapbox.com/directions/v5/mapbox";

  //..interceptors: los .. son el operador de cascada de dart.
  TrafficService()
      : _dioTraffic = Dio()..interceptors.add(TrafficInterceptor());

  Future<TrafficResponse> getCoorsStartToEnd(LatLng start, LatLng end) async {
    final coordsString =
        "${start.longitude},${start.latitude};${end.longitude},${end.latitude}";
    final url = "$_baseTrafficUrl/driving/$coordsString";

    final response = await _dioTraffic.get(url);
    final data = TrafficResponse.fromJson(response.data);
    return data;
  }
}

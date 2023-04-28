import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart'
    show decodePolyline;
import 'package:gps_app/models/models.dart';
import 'package:gps_app/services/services.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  TrafficService trafficService;
  SearchBloc({required this.trafficService}) : super(const SearchState()) {
    on<OnActivateManualMarkerEvent>(
        (event, emit) => emit(state.copyWith(displayManualMarker: true)));
    on<OnDeactivateManualMarkerEvent>(
        (event, emit) => emit(state.copyWith(displayManualMarker: false)));
    on<OnNewPlacesFoundEvent>(
        (event, emit) => emit(state.copyWith(places: event.places)));
    on<AddNewHistoryEvent>(
        (event, emit) => emit(state.copyWith(history: event.history)));
  }

  Future<RouteDestination> getCoordsStartToEnd(LatLng start, LatLng end) async {
    final trafficResponse = await trafficService.getCoorsStartToEnd(start, end);

    final geometry = trafficResponse.routes.first.geometry;
    final duration = trafficResponse.routes.first.duration;
    final distance = trafficResponse.routes.first.distance;

    //decode geometry del paquete google polylines algorithm
    final points = decodePolyline(geometry, accuracyExponent: 6);
    // points=[[38.5, -120.2],[40.7, -120.95],[43.252, -126.453],]
    final latLngList = points
        .map((coords) => LatLng(coords[0].toDouble(), coords[1].toDouble()))
        .toList();

    return RouteDestination(
        points: latLngList, duration: duration, distance: distance);
  }

  Future getPlacesByQuery(LatLng proximity, String query) async {
    final newPlacesResponse =
        await trafficService.getResultsByQuery(proximity, query);
    add(OnNewPlacesFoundEvent(places: newPlacesResponse));
  }
}

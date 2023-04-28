import 'dart:async';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:bloc/bloc.dart';
import 'package:gps_app/blocs/blocs.dart';
import 'package:gps_app/helpers/helpers.dart';
import 'package:gps_app/models/models.dart';
import '../../themes/themes.dart ';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationBloc locationBloc;
  GoogleMapController? _mapController;
  StreamSubscription<LocationState>? locationSubscription;
  LatLng? mapCenter;

  MapBloc({required this.locationBloc}) : super(const MapState()) {
    //2 maneras de hacerlo
    // on<onMapInitilializedEvent>((event, emit) {
    //   emit(state.copyWith(isMapInitialized: true));
    // });
    on<onMapInitilializedEvent>(_onInitMap);

    on<StopFollowingUser>(
        (event, emit) => emit(state.copyWith(followUser: false)));
    on<StartFollowingUser>(_onStartFollowingUser);
    on<UpdateUserPolylines>(_UpdateUserPolynes);
    on<OnToggleRoute>(
        (event, emit) => emit(state.copyWith(showRoute: !state.showRoute)));
    on<DisplayPolylinesEvent>((event, emit) => emit(
        state.copyWith(polylines: event.polylines, markers: event.markers)));

    //El stream escucha cada vez que hay un cambio de estado (asumo yo)
    locationSubscription = locationBloc.stream.listen((locationState) {
      if (locationState.lastLocation == null) return;
      add(UpdateUserPolylines(locationState.history));
      if (!state.followUser) return;
      moveCamera(locationState.lastLocation!);
    });
  }

  void _onInitMap(onMapInitilializedEvent event, Emitter<MapState> emit) {
    _mapController = event.mapController;
    _mapController!.setMapStyle(jsonEncode(Uber));
    emit(state.copyWith(isMapInitialized: true));
  }

  void _onStartFollowingUser(StartFollowingUser event, Emitter<MapState> emit) {
    emit(state.copyWith(followUser: true));
    if (locationBloc.state.lastLocation == null) return;
    moveCamera(locationBloc.state.lastLocation!);
  }

  void _UpdateUserPolynes(UpdateUserPolylines event, Emitter<MapState> emit) {
    final myRoute = Polyline(
        polylineId: const PolylineId("myRoute"),
        color: Colors.black,
        width: 5,
        points: event.history,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap);
    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    //Si no existe "myRoute", lo crea, sino lo remplaza por el nuevo myRoute
    currentPolylines["myRoute"] = myRoute;
    emit(state.copyWith(polylines: currentPolylines));
  }

  Future drawRoutePolyline(RouteDestination destination) async {
    final route = Polyline(
        polylineId: const PolylineId("route"),
        color: Colors.black,
        width: 5,
        points: destination.points,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap);

    //kilometros a metro y hago redondeo.
    double km = destination.distance / 1000;
    km = (km * 100).floorToDouble() / 100;

    double tripDuration =
        ((destination.duration / 60) * 100).floorToDouble() / 100;

    //Custom markers


    //Creacion de markers:
    final startMarker = Marker(
        markerId: const MarkerId("start"),
        anchor: const Offset(0.06, 0.9),
        position: destination.points.first,
        // icon: await getAssetImage()
        icon: await getStartCustomMarker(tripDuration.toInt(), "Mi ubicacion"),
        // infoWindow: InfoWindow(
        //   title: "Inicio",
        //   snippet: "Kms: $km, duracion: $tripDuration minutos",
        // )
    );
    final endMarker = Marker(
        markerId: const MarkerId("end"),
        position: destination.points.last,
        // icon: await getNetworkImageMarker(),
        icon: await getEndCustomMarker(km.toInt(), destination.endPlace.text),
        //Muevo un poco el icon
         anchor: const Offset(0.5, 0.9),
        // infoWindow: InfoWindow(
        //   title: destination.endPlace.text,
        //   snippet: destination.endPlace.placeName,
        // )
    );

    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines["route"] = route;
    final currentMarkers = Map<String, Marker>.from(state.markers);
    currentMarkers["start"] = startMarker;
    currentMarkers["end"] = endMarker;

    add(DisplayPolylinesEvent(currentPolylines, currentMarkers));

    //Estp controla que infoWindow se muestra primero.
    // await Future.delayed(const Duration(milliseconds: 300));
    // _mapController?.showMarkerInfoWindow(const MarkerId("start"));
  }

  void moveCamera(LatLng newLocation) {
    final cameraUpdate = CameraUpdate.newLatLng(newLocation);
    _mapController?.animateCamera(cameraUpdate);
  }

  @override
  Future<void> close() {
    locationSubscription?.cancel();
    return super.close();
  }
}

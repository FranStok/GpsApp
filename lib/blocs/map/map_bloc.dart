import 'dart:async';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:bloc/bloc.dart';
import 'package:gps_app/blocs/blocs.dart';
import '../../themes/themes.dart ';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationBloc locationBloc;
  GoogleMapController? _mapController;
  StreamSubscription<LocationState>? locationSubscription;

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

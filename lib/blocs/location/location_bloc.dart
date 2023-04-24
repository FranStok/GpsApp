import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  StreamSubscription? positionStream;
  LocationBloc() : super(const LocationState()) {
    on<OnNewUserLocationEvent>((event, emit) {
      emit(state.copyWith(
          lastLocation: event.newLocation,
          history: [...state.history, event.newLocation]));
    });
    on<OnStartFollowingUserEvent>((event, emit) {
      emit(state.copyWith(followingUser: true));
    });
    on<OnStopFollowingUserEvent>((event, emit) {
      emit(state.copyWith(followingUser: false));
    });
  }

  Future getCurrentPosition() async {
    final position = await Geolocator.getCurrentPosition();
    print("$position");
    add(OnNewUserLocationEvent(
        newLocation: LatLng(position.latitude, position.longitude)));
  }

  void startFollowingUser() {
    add(OnStartFollowingUserEvent());
    positionStream = Geolocator.getPositionStream().listen((position) {
      print("$position");
      add(OnNewUserLocationEvent(
          newLocation: LatLng(position.latitude, position.longitude)));
    });
  }

  @override
  Future<void> close() {
    positionStream?.cancel();
    add(OnStopFollowingUserEvent());
    // TODO: implement close
    return super.close();
  }
}

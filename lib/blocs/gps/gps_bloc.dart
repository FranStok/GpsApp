import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;

part 'gps_event.dart';
part 'gps_state.dart';

class GpsBloc extends Bloc<GpsEvent, GpsState> {
  StreamSubscription? gpsServiceSuscription;
  GpsBloc()
      : super(
            const GpsState(isGpsEnable: false, isGpsPermissionGranted: false)) {
    on<GpsAndPermissionEvent>((event, emit) => emit(state.copyWith(
        isGpsEnable: event.isGpsEnable,
        isGpsPermissionGranted: event.isGpsPermissionGranted)));

    _init();
  }
  Future<void> _init() async {
    // final isEnable = await _checkGpsStatus();
    // final isGranted = await _isPermissionGranted();
    // add(GpsAndPermissionEvent(
    //     isGpsEnable: isEnable, isGpsPermissionGranted: isGranted));
    final gpsInitStatus=await Future.wait([
      _checkGpsStatus(),
      _isPermissionGranted()
    ]);
    // print(gpsInitStatus[0]);
    // print(gpsInitStatus[1]);
    add(GpsAndPermissionEvent(
        isGpsEnable: gpsInitStatus[0], isGpsPermissionGranted: gpsInitStatus[1]));
  }

  Future<bool> _isPermissionGranted() async {
    final isGranted = await permission_handler.Permission.location.isGranted;
    return isGranted;
  }

  Future<bool> _checkGpsStatus() async {
    final isEnable = await Geolocator.isLocationServiceEnabled();
    gpsServiceSuscription = Geolocator.getServiceStatusStream().listen((event) {
      final isEnabled = (event == ServiceStatus.enabled) ? true : false;
      print("Service status $isEnabled");
      add(GpsAndPermissionEvent(
          isGpsEnable: isEnabled,
          isGpsPermissionGranted: state.isGpsPermissionGranted));
      //Disparar eventos
    });
    return isEnable;
  }

  Future<void> askGpsAccess() async {
    final status = await permission_handler.Permission.location.request();

    switch (status) {
      case permission_handler.PermissionStatus.granted:
        add(GpsAndPermissionEvent(
            isGpsEnable: state.isGpsEnable, isGpsPermissionGranted: true));
        break;
      case permission_handler.PermissionStatus.denied:
      case permission_handler.PermissionStatus.restricted:
      case permission_handler.PermissionStatus.limited:
      case permission_handler.PermissionStatus.permanentlyDenied:
        add(GpsAndPermissionEvent(
            isGpsEnable: state.isGpsEnable, isGpsPermissionGranted: false));
        permission_handler.openAppSettings();
    }
  }

  Future<void> close() {
    gpsServiceSuscription?.cancel();
    return super.close();
  }
}

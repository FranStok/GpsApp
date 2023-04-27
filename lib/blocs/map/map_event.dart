part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class onMapInitilializedEvent extends MapEvent {
  final GoogleMapController mapController;

  const onMapInitilializedEvent(this.mapController);
}

class StartFollowingUser extends MapEvent {}

class StopFollowingUser extends MapEvent {}

class UpdateUserPolylines extends MapEvent {
  final List<LatLng> history;

  const UpdateUserPolylines(this.history);
}

class DisplayPolylinesEvent extends MapEvent {
  final Map<String, Polyline> polylines;

  const DisplayPolylinesEvent(this.polylines);
}

class OnToggleRoute extends MapEvent {}

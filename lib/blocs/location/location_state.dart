part of 'location_bloc.dart';

class LocationState extends Equatable {
  final bool followingUser;
  final LatLng? lastLocation;
  final List<LatLng> history;
  //Ultima localizacion conocida
  //Historial de ultimas localizaciones

  const LocationState({this.lastLocation, this.history=const[], this.followingUser = false});

  LocationState copyWith({
    bool? followingUser,
    LatLng? lastLocation,
    List<LatLng>? history
  })=>LocationState(
    followingUser: followingUser ?? this.followingUser,
    lastLocation: lastLocation ?? this.lastLocation,
    history: history ?? this.history
  );

  @override
  List<Object?> get props => [followingUser,lastLocation,history];
}

part of 'map_bloc.dart';

class MapState extends Equatable {
  final bool isMapInitialized;
  final bool followUser;
  //Polylines
  final Map<String, Polyline> polylines;
  final bool showRoute;

  const MapState({this.showRoute=true, 
      Map<String, Polyline>? polylines,
      this.isMapInitialized = false,
      this.followUser = true})
      : this.polylines = polylines ?? const {};

  MapState copyWith(
          {bool? showRoute,
          Map<String, Polyline>? polylines,
          bool? isMapInitialized,
          bool? followUser}) =>
      MapState(
          isMapInitialized: isMapInitialized ?? this.isMapInitialized,
          followUser: followUser ?? this.followUser,
          polylines: polylines ?? this.polylines,
          showRoute: showRoute ?? this.showRoute);

  @override
  List<Object> get props => [isMapInitialized, followUser, polylines, showRoute];
}

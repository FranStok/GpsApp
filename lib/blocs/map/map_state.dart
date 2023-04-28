part of 'map_bloc.dart';

class MapState extends Equatable {
  final bool isMapInitialized;
  final bool followUser;
  //Polylines
  final Map<String, Polyline> polylines;
  final bool showRoute;
  //Markers
  final Map<String, Marker> markers;

  const MapState(
      {this.showRoute = true,
      Map<String, Polyline>? polylines,
      Map<String, Marker>? markers,
      this.isMapInitialized = false,
      this.followUser = true})
      : this.polylines = polylines ?? const {},
        this.markers = markers ?? const {};

  MapState copyWith(
          {bool? showRoute,
          Map<String, Polyline>? polylines,
          Map<String, Marker>? markers,
          bool? isMapInitialized,
          bool? followUser}) =>
      MapState(
          isMapInitialized: isMapInitialized ?? this.isMapInitialized,
          followUser: followUser ?? this.followUser,
          polylines: polylines ?? this.polylines,
          markers: markers ?? this.markers,
          showRoute: showRoute ?? this.showRoute);

  @override
  List<Object> get props =>
      [isMapInitialized, followUser, polylines, markers, showRoute];
}

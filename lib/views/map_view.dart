import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../blocs/blocs.dart';

class MapView extends StatelessWidget {
  final Set<Polyline> polylines;
  final LatLng initialLocation;
  const MapView(
      {super.key, required this.initialLocation, required this.polylines});

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final CameraPosition initialCameraPosition =
        CameraPosition(target: initialLocation, zoom: 15);
    final size = MediaQuery.of(context).size;
    return SizedBox(
        width: size.width,
        height: size.height,
        child: Listener(
          //Rodeo al widget GoogleMap con listener, para poder escuchar cuando mueve la camara,
          //ya que onCamaraMove de GoogleMap no nos sirve.
          //onPointerMove nos viene mejor.
          onPointerMove: (pointerMoveEvent) => mapBloc.add(StopFollowingUser()),
          child: GoogleMap(
            initialCameraPosition: initialCameraPosition,
            compassEnabled: false,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (mapController) =>
                mapBloc.add(onMapInitilializedEvent(mapController)),
            polylines: polylines,
            //Markers

            //Cuando se mueve el mapa. Lo uso para pasar la end location de un marker personal.
            //Target es la latitud y la longitud
            onCameraMove:(position)=> mapBloc.mapCenter=position.target,
          ),
        ));
  }
}

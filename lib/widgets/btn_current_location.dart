import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/UI/UI.dart';
import 'package:gps_app/blocs/blocs.dart';

class BtnCurrentLocation extends StatelessWidget {
  const BtnCurrentLocation({super.key});

  @override
  Widget build(BuildContext context) {
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        maxRadius: 25,
        child: IconButton(
          icon: const Icon(Icons.my_location_outlined),
          onPressed: () {
            final userLocation = locationBloc.state.lastLocation;
            if(userLocation==null){
              final snackBar = CustomSnackBar(mesagge: "No hay ubiacion");
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              return;
            }
            mapBloc.moveCamera(userLocation);
          },
        ),
      ),
    );
  }
}

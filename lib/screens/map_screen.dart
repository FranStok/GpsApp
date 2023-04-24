import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/blocs/blocs.dart';
import 'package:gps_app/views/views.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final locationBloc;
  @override
  void initState() {
    locationBloc = BlocProvider.of<LocationBloc>(context);
    locationBloc.startFollowingUser();
    super.initState();
  }

  @override
  void dispose() {
    locationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        if (state.lastLocation == null) {
          return const Center(
              child: Text("Espere por favor...",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
        }
        return SingleChildScrollView(
          
          child: Stack(
            children: [
              MapView(initialLocation: state.lastLocation!)
            ],
          ),
        );
      },
    ));
  }
}

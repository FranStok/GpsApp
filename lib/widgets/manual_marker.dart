import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';

import '../blocs/blocs.dart';
import 'package:gps_app/helpers/helpers.dart';

class ManualMarker extends StatelessWidget {
  const ManualMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return (state.displayManualMarker)
            ? const _ManualMarkerBody()
            : const SizedBox();
      },
    );
  }
}

class _ManualMarkerBody extends StatelessWidget {
  const _ManualMarkerBody({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          const Positioned(
            top: 70,
            left: 20,
            child: _BtnBack(),
          ),
          Center(
              child: Transform.translate(
            offset: const Offset(0, -21),
            child: BounceInDown(
                //Animacion de animate_do
                from: 100,
                child: const Icon(Icons.location_on_rounded, size: 60)),
          )),
          //Boton de confirmar
          Positioned(
            bottom: 55,
            left: 40,
            child: FadeInUp(
              duration: const Duration(milliseconds: 300),
              child: MaterialButton(
                minWidth: size.width - 120,
                height: 50,
                color: Colors.black,
                elevation: 0,
                shape: const StadiumBorder(),
                onPressed: () async {
                  final start = locationBloc.state.lastLocation;
                  final end = mapBloc.mapCenter;
                  if (start == null || end == null) return;
                  searchBloc.add(OnDeactivateManualMarkerEvent());
                  showLoadingMessage(context);
                  final navigator = Navigator.of(context); // Si no hago esto, falla por el tema context y async.
                  final destination =
                      await searchBloc.getCoordsStartToEnd(start, end);
                  await mapBloc.drawRoutePolyline(destination);
                  navigator.pop(); //Cierra el loadingMessage
                },
                child: const Text("Confirmar destino",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300)),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _BtnBack extends StatelessWidget {
  const _BtnBack({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      duration: const Duration(milliseconds: 300),
      child: CircleAvatar(
        maxRadius: 30,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            final searchBloc = BlocProvider.of<SearchBloc>(context);
            searchBloc.add(OnDeactivateManualMarkerEvent());
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';

class GpsAccessScreen extends StatelessWidget {
  const GpsAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: BlocBuilder<GpsBloc, GpsState>(
        builder: (context, state) {
          return (!state.isGpsEnable)
              ? const _EnableGpsMessage()
              : const _AccessButton();
        },
      )),
    );
  }
}

class _AccessButton extends StatelessWidget {
  const _AccessButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Es necesario el acceso al gps",
            style: TextStyle(fontSize: 20)),
        ElevatedButton(
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.black),
            shape: MaterialStatePropertyAll(StadiumBorder()),
            elevation: MaterialStatePropertyAll(0),
          ),
          onPressed: () {
            final gpsBloc = BlocProvider.of<GpsBloc>(context);
            gpsBloc.askGpsAccess();
          },
          child: const Text("Solicitar acceso",
              style: TextStyle(color: Colors.white, fontSize: 17)),
        )
      ],
    );
  }
}

class _EnableGpsMessage extends StatelessWidget {
  const _EnableGpsMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text('Debe de habilitar el gps',
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300));
  }
}

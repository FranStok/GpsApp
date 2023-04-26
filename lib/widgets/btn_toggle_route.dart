import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/UI/UI.dart';
import 'package:gps_app/blocs/blocs.dart';

class BtnToggleRoute extends StatelessWidget {
  const BtnToggleRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        maxRadius: 25,
        child: IconButton(
          icon: const Icon((Icons.route_outlined)),
          onPressed: () {
            mapBloc.add(OnToggleRoute());
          },
        ),
      ),
    );
  }
}

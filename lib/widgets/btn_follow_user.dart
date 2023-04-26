import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/UI/UI.dart';
import 'package:gps_app/blocs/blocs.dart';

class BtnFollowUser extends StatelessWidget {
  const BtnFollowUser({super.key});

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        maxRadius: 25,
        child: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            return IconButton(
              icon: (state.followUser)
                  ? const Icon((Icons.directions_run_outlined))
                  : const Icon((Icons.hail_rounded)),
              onPressed: () {
                (state.followUser)
                    ? mapBloc.add(StopFollowingUser())
                    : mapBloc.add(StartFollowingUser());
              },
            );
          },
        ),
      ),
    );
  }
}

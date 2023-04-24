import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/blocs/gps/gps_bloc.dart';
import 'package:gps_app/screens/screens.dart';

void main() { 
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create:(context) => GpsBloc())
  ], 
  child: const MapsApp()));
}

class MapsApp extends StatelessWidget {
  const MapsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Maps App',
      home: LoadingScreen()
    );
  }
}
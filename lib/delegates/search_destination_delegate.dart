import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_app/models/models.dart';

import '../blocs/blocs.dart';

class SearchDestinationDelegate extends SearchDelegate<SearchResult> {
  SearchDestinationDelegate() : super(searchFieldLabel: "Buscar...");

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ""; //Viene de SearchDelegate
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        final result = SearchResult(cancel: true);
        close(context, result); //Viene de SearchDelegate
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final proximity =
        BlocProvider.of<LocationBloc>(context).state.lastLocation!;
    searchBloc.getPlacesByQuery(
        proximity, query); //Query viene de SearchDelegate
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final places = state.places;
        return Container(
          padding: EdgeInsets.only(top: 7),
          child: ListView.separated(
              itemBuilder: (context, i) => ListTile(
                    title: Text(places[i].text),
                    subtitle: Text(places[i].placeName),
                    leading:
                        const Icon(Icons.place_outlined, color: Colors.black),
                    onTap: () {
                      final result = SearchResult(
                          cancel: false,
                          manual: false,
                          //MapBox trabaja con longitud/latitud,
                          //mientras que googleMaps con latitud/longitud,
                          //Hay que darlas vueltas, por eso primero places[i].center[1]
                          position: LatLng(
                              places[i].center[1], (places[i].center[0])),
                          name: places[i].text,
                          description: places[i].placeName);
                      final history = [...searchBloc.state.history].toList();
                      final newHistory = [
                        places[i],
                        ...history
                            .where((place) => (place.id != places[i].id))
                            .toList()
                      ];
                      searchBloc.add(AddNewHistoryEvent(history: newHistory));
                      close(context, result);
                    },
                  ),
              separatorBuilder: (context, i) => const Divider(),
              itemCount: places.length),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final history = BlocProvider.of<SearchBloc>(context).state.history;
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.location_on_outlined, color: Colors.black),
          title: const Text("Colocar marcador manual",
              style: TextStyle(color: Colors.black)),
          onTap: () {
            final result = SearchResult(cancel: false, manual: true);
            close(context, result);
          },
        ),
        const Divider(),
        ...history.map((place) => ListTile(
              title: Text(place.text),
              subtitle: Text(place.placeName),
              leading: const Icon(Icons.history, color: Colors.black),
              onTap: () {
                final result = SearchResult(
                    cancel: false,
                    manual: false,
                    position: LatLng(place.center[1], (place.center[0])),
                    name: place.text,
                    description: place.placeName);
                close(context, result);
              },
            ))
        // BlocBuilder<SearchBloc, SearchState>(
        //   builder: (context, state) {
        //     final history = searchBloc.state.history;
        //     if (history == []) return const SizedBox();
        //     return ListView.separated(
        //         shrinkWrap: true,
        //         itemBuilder: (context, i) => ListTile(
        //               title: Text(history[i].text),
        //               subtitle: Text(history[i].placeName),
        //               leading:
        //                   const Icon(Icons.place_outlined, color: Colors.black),
        //               onTap: () {
        //                 final result = SearchResult(
        //                     cancel: false,
        //                     manual: false,
        //                     position: LatLng(
        //                         history[i].center[1], (history[i].center[0])),
        //                     name: history[i].text,
        //                     description: history[i].placeName);
        //                 searchBloc.add(AddNewHistoryEvent(place: history[i]));
        //                 close(context, result);
        //               },
        //             ),
        //         separatorBuilder: (context, i) => const Divider(),
        //         itemCount: history.length);
        //   },
        // )
      ],
    );
  }
}

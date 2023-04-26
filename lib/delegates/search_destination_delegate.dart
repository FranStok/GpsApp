import 'package:flutter/material.dart';
import 'package:gps_app/models/models.dart';

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
    return const Text("BuildResults");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.location_on_outlined, color: Colors.black),
          title: const Text("Colocar marcador manual",
              style: TextStyle(color: Colors.black)),
          onTap: () {
            final result = SearchResult(cancel: false,manual: true);
            close(context, result);
          },
        )
      ],
    );
  }
}

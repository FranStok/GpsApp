// To parse this JSON data, do
//
//     final placesResponse = placesResponseFromJson(jsonString);

import 'dart:convert';

class PlacesResponse {
  final String type;
  final List<String> query;
  final List<Feature> features;
  final String attribution;

  PlacesResponse({
    required this.type,
    required this.query,
    required this.features,
    required this.attribution,
  });

  factory PlacesResponse.fromRawJson(String str) =>
      PlacesResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PlacesResponse.fromJson(Map<String, dynamic> json) => PlacesResponse(
        type: json["type"],
        query: List<String>.from(json["query"].map((x) => x)),
        features: List<Feature>.from(
            json["features"].map((x) => Feature.fromJson(x))),
        attribution: json["attribution"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "query": List<dynamic>.from(query.map((x) => x)),
        "features": List<dynamic>.from(features.map((x) => x.toJson())),
        "attribution": attribution,
      };
}

class Feature {
  final String id;
  final String type;
  final List<String> placeType;
  final Properties properties;
  final String text;
  final String placeName;
  final List<double> center;
  final Geometry geometry;

  Feature({
    required this.id,
    required this.type,
    required this.placeType,
    required this.properties,
    required this.text,
    required this.placeName,
    required this.center,
    required this.geometry,
  });

  factory Feature.fromRawJson(String str) => Feature.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        id: json["id"],
        type: json["type"],
        placeType: List<String>.from(json["place_type"].map((x) => x)),
        properties: Properties.fromJson(json["properties"]),
        text: json["text"],
        placeName: json["place_name"],
        center: List<double>.from(json["center"].map((x) => x?.toDouble())),
        geometry: Geometry.fromJson(json["geometry"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "place_type": List<dynamic>.from(placeType.map((x) => x)),
        "properties": properties.toJson(),
        "text": text,
        "place_name": placeName,
        "center": List<dynamic>.from(center.map((x) => x)),
        "geometry": geometry.toJson(),
      };
  @override
  String toString() {
    return "feature: $placeName";
  }
}

class Context {
  final String id;
  final String mapboxId;
  final String text;
  final String? wikidata;
  final String? shortCode;

  Context({
    required this.id,
    required this.mapboxId,
    required this.text,
    this.wikidata,
    this.shortCode,
  });

  factory Context.fromRawJson(String str) => Context.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Context.fromJson(Map<String, dynamic> json) => Context(
        id: json["id"],
        mapboxId: json["mapbox_id"],
        text: json["text"],
        wikidata: json["wikidata"],
        shortCode: json["short_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "mapbox_id": mapboxId,
        "text": text,
        "wikidata": wikidata,
        "short_code": shortCode,
      };
}

class Geometry {
  final List<double> coordinates;
  final String type;

  Geometry({
    required this.coordinates,
    required this.type,
  });

  factory Geometry.fromRawJson(String str) =>
      Geometry.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
        "type": type,
      };
}

class Properties {
  final String? foursquare;
  final bool? landmark;
  final String? address;
  final String? category;
  final String? maki;
  final String? wikidata;
  final String? mapboxId;

  Properties({
    this.foursquare,
    this.landmark,
    this.address,
    this.category,
    this.maki,
    this.wikidata,
    this.mapboxId,
  });

  factory Properties.fromRawJson(String str) =>
      Properties.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        foursquare: json["foursquare"],
        landmark: json["landmark"],
        address: json["address"],
        category: json["category"],
        maki: json["maki"],
        wikidata: json["wikidata"],
        mapboxId: json["mapbox_id"],
      );

  Map<String, dynamic> toJson() => {
        "foursquare": foursquare,
        "landmark": landmark,
        "address": address,
        "category": category,
        "maki": maki,
        "wikidata": wikidata,
        "mapbox_id": mapboxId,
      };
}

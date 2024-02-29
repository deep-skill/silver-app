// To parse this JSON data, do
//
//     final googleResponse = googleResponseFromJson(jsonString);

import 'dart:convert';

GoogleResponse googleResponseFromJson(String str) =>
    GoogleResponse.fromJson(json.decode(str));

String googleResponseToJson(GoogleResponse data) => json.encode(data.toJson());

class GoogleResponse {
  List<ResultGoogle> results;
  String status;

  GoogleResponse({
    required this.results,
    required this.status,
  });

  factory GoogleResponse.fromJson(Map<String, dynamic> json) => GoogleResponse(
        results: List<ResultGoogle>.from(
            json["results"].map((x) => ResultGoogle.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "status": status,
      };
}

class ResultGoogle {
  List<AddressComponent> addressComponents;
  String formattedAddress;
  Geometry geometry;
  String placeId;
  List<String> types;

  ResultGoogle({
    required this.addressComponents,
    required this.formattedAddress,
    required this.geometry,
    required this.placeId,
    required this.types,
  });

  factory ResultGoogle.fromJson(Map<String, dynamic> json) => ResultGoogle(
        addressComponents: List<AddressComponent>.from(
            json["address_components"]
                .map((x) => AddressComponent.fromJson(x))),
        formattedAddress: json["formatted_address"],
        geometry: Geometry.fromJson(json["geometry"]),
        placeId: json["place_id"],
        types: List<String>.from(json["types"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "address_components":
            List<dynamic>.from(addressComponents.map((x) => x.toJson())),
        "formatted_address": formattedAddress,
        "geometry": geometry.toJson(),
        "place_id": placeId,
        "types": List<dynamic>.from(types.map((x) => x)),
      };
}

class AddressComponent {
  String longName;
  String shortName;
  List<String> types;

  AddressComponent({
    required this.longName,
    required this.shortName,
    required this.types,
  });

  factory AddressComponent.fromJson(Map<String, dynamic> json) =>
      AddressComponent(
        longName: json["long_name"],
        shortName: json["short_name"],
        types: List<String>.from(json["types"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "long_name": longName,
        "short_name": shortName,
        "types": List<dynamic>.from(types.map((x) => x)),
      };
}

class Geometry {
  Bounds bounds;
  Location location;
  String locationType;
  Bounds viewport;

  Geometry({
    required this.bounds,
    required this.location,
    required this.locationType,
    required this.viewport,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        bounds: Bounds.fromJson(json["bounds"]),
        location: Location.fromJson(json["location"]),
        locationType: json["location_type"],
        viewport: Bounds.fromJson(json["viewport"]),
      );

  Map<String, dynamic> toJson() => {
        "bounds": bounds.toJson(),
        "location": location.toJson(),
        "location_type": locationType,
        "viewport": viewport.toJson(),
      };
}

class Bounds {
  Location northeast;
  Location southwest;

  Bounds({
    required this.northeast,
    required this.southwest,
  });

  factory Bounds.fromJson(Map<String, dynamic> json) => Bounds(
        northeast: Location.fromJson(json["northeast"]),
        southwest: Location.fromJson(json["southwest"]),
      );

  Map<String, dynamic> toJson() => {
        "northeast": northeast.toJson(),
        "southwest": southwest.toJson(),
      };
}

class Location {
  double lat;
  double lng;

  Location({
    required this.lat,
    required this.lng,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}

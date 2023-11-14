// To parse this JSON data, do
//
//     final tripDriverStatus = tripDriverStatusFromJson(jsonString);

import 'dart:convert';

TripDriverStatus tripDriverStatusFromJson(String str) =>
    TripDriverStatus.fromJson(json.decode(str));

String tripDriverStatusToJson(TripDriverStatus data) =>
    json.encode(data.toJson());

class TripDriverStatus {
  int id;
  int? totalPrice;
  DateTime onWayDriver;
  DateTime? arrivedDriver;
  DateTime? startTime;
  DateTime? endTime;
  String? status;
  int reserveId;
  String startAddress;
  String endAddress;
  List<Stop> stops;
  List<Observations> observations;
  List<Parking> parkings;
  List<TollMap> tollMaps;

  TripDriverStatus({
    required this.id,
    required this.totalPrice,
    required this.onWayDriver,
    required this.arrivedDriver,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.reserveId,
    required this.stops,
    required this.observations,
    required this.parkings,
    required this.tollMaps,
    required this.startAddress,
    required this.endAddress,
  });

  factory TripDriverStatus.fromJson(Map<String, dynamic> json) =>
      TripDriverStatus(
        id: json["id"],
        totalPrice: json["totalPrice"] ?? 0,
        onWayDriver: DateTime.parse(json["onWayDriver"]),
        arrivedDriver: json["arrivedDriver"] == null
            ? null
            : DateTime.parse(json["arrivedDriver"]),
        startTime: json["startTime"] == null
            ? null
            : DateTime.parse(json["startTime"]),
        endTime:
            json["endTime"] == null ? null : DateTime.parse(json["endTime"]),
        status: json["status"] ?? '',
        reserveId: json["reserveId"],
        startAddress: json["Reserve"]["startAddress"],
        endAddress: json["Reserve"]["endAddress"],
        stops:
            List<Stop>.from(json["Stops"]?.map((x) => Stop.fromJson(x)) ?? []),
        observations: List<Observations>.from(
            json["Observations"]?.map((x) => Observations.fromJson(x)) ?? []),
        parkings: List<Parking>.from(
            json["Parkings"]?.map((x) => Parking.fromJson(x)) ?? []),
        tollMaps: List<TollMap>.from(
            json["TollMaps"]?.map((x) => TollMap.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "totalPrice": totalPrice,
        "onWayDriver": onWayDriver.toIso8601String(),
        "arrivedDriver": arrivedDriver?.toIso8601String(),
        "startTime": startTime?.toIso8601String(),
        "endTime": endTime?.toIso8601String(),
        "status": status,
        "reserveId": reserveId,
        "Stops": List<dynamic>.from(stops.map((x) => x.toJson())),
        "Observations": List<dynamic>.from(observations.map((x) => x.toJson())),
        "Parkings": List<dynamic>.from(parkings.map((x) => x.toJson())),
        "TollMaps": List<dynamic>.from(tollMaps.map((x) => x.toJson())),
      };
}

class Observations {
  int id;
  String observation;
  int tripId;

  Observations({
    required this.id,
    required this.observation,
    required this.tripId,
  });

  factory Observations.fromJson(Map<String, dynamic> json) => Observations(
        id: json["id"],
        observation: json["observation"],
        tripId: json["tripId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "observation": observation,
        "tripId": tripId,
      };
}

class Parking {
  int id;
  int amount;
  String name;
  int tripId;

  Parking({
    required this.id,
    required this.amount,
    required this.name,
    required this.tripId,
  });

  factory Parking.fromJson(Map<String, dynamic> json) => Parking(
        id: json["id"],
        amount: json["amount"],
        name: json["name"],
        tripId: json["tripId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "name": name,
        "tripId": tripId,
      };
}

class Stop {
  int tripId;
  int id;
  String location;

  Stop({
    required this.id,
    required this.location,
    required this.tripId,
  });

  factory Stop.fromJson(Map<String, dynamic> json) => Stop(
        id: json["id"],
        location: json["location"],
        tripId: json["tripId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "location": location,
        "tripId": tripId,
      };
}

class TollMap {
  String id;
  String location;
  String name;
  int amount;
  Toll toll;

  TollMap({
    required this.id,
    required this.location,
    required this.name,
    required this.amount,
    required this.toll,
  });

  factory TollMap.fromJson(Map<String, dynamic> json) => TollMap(
        id: json["id"],
        location: json["location"],
        name: json["name"],
        amount: json["amount"],
        toll: Toll.fromJson(json["Toll"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "location": location,
        "name": name,
        "amount": amount,
        "Toll": toll.toJson(),
      };
}

class Toll {
  String id;
  int tripId;
  String tollMapId;

  Toll({
    required this.id,
    required this.tripId,
    required this.tollMapId,
  });

  factory Toll.fromJson(Map<String, dynamic> json) => Toll(
        id: json["id"],
        tripId: json["trip_id"],
        tollMapId: json["toll_map_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "trip_id": tripId,
        "toll_map_id": tollMapId,
      };
}

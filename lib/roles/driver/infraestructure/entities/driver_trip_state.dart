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
  DateTime? onWayDriver;
  DateTime? arrivedDriver;
  DateTime? startTime;
  DateTime? endTime;
  String? status;
  dynamic driverRating;
  dynamic passengerRating;
  DateTime createdAt;
  DateTime updatedAt;
  int reserveId;
  String startAddress;
  String endAddress;
  List<Stop> stops;
  List<Detour> detours;
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
    required this.driverRating,
    required this.passengerRating,
    required this.createdAt,
    required this.updatedAt,
    required this.reserveId,
    required this.stops,
    required this.detours,
    required this.parkings,
    required this.tollMaps,
    required this.startAddress,
    required this.endAddress,
  });

  factory TripDriverStatus.fromJson(Map<String, dynamic> json) =>
      TripDriverStatus(
        id: json["id"],
        totalPrice: json["totalPrice"] ?? 0,
        onWayDriver: json["onWayDriver"] == null
            ? null
            : DateTime.parse(json["onWayDriver"]),
        arrivedDriver: json["arrivedDriver"] == null
            ? null
            : DateTime.parse(json["arrivedDriver"]),
        startTime: json["startTime"] == null
            ? null
            : DateTime.parse(json["startTime"]),
        endTime:
            json["endTime"] == null ? null : DateTime.parse(json["endTime"]),
        status: json["status"] ?? '',
        driverRating: json["driverRating"],
        passengerRating: json["passengerRating"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        reserveId: json["reserveId"],
        startAddress: json["Reserve"]["startAddress"],
        endAddress: json["Reserve"]["endAddress"],
        stops:
            List<Stop>.from(json["Stops"]?.map((x) => Stop.fromJson(x)) ?? []),
        detours: List<Detour>.from(
            json["Detours"]?.map((x) => Detour.fromJson(x)) ?? []),
        parkings: List<Parking>.from(
            json["Parkings"]?.map((x) => Parking.fromJson(x)) ?? []),
        tollMaps: List<TollMap>.from(
            json["TollMaps"]?.map((x) => TollMap.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "totalPrice": totalPrice,
        "onWayDriver": onWayDriver?.toIso8601String(),
        "arrivedDriver": arrivedDriver?.toIso8601String(),
        "startTime": startTime?.toIso8601String(),
        "endTime": endTime?.toIso8601String(),
        "status": status,
        "driverRating": driverRating,
        "passengerRating": passengerRating,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "reserveId": reserveId,
        "Stops": List<dynamic>.from(stops.map((x) => x.toJson())),
        "Detours": List<dynamic>.from(detours.map((x) => x.toJson())),
        "Parkings": List<dynamic>.from(parkings.map((x) => x.toJson())),
        "TollMaps": List<dynamic>.from(tollMaps.map((x) => x.toJson())),
      };
}

class Detour {
  String id;
  int amount;
  String observation;
  int tripId;

  Detour({
    required this.id,
    required this.amount,
    required this.observation,
    required this.tripId,
  });

  factory Detour.fromJson(Map<String, dynamic> json) => Detour(
        id: json["id"],
        amount: json["amount"],
        observation: json["observation"],
        tripId: json["trip_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "observation": observation,
        "trip_id": tripId,
      };
}

class Parking {
  String id;
  int amount;
  int duration;
  String name;
  String location;
  String observation;
  int tripId;

  Parking({
    required this.id,
    required this.amount,
    required this.duration,
    required this.name,
    required this.location,
    required this.observation,
    required this.tripId,
  });

  factory Parking.fromJson(Map<String, dynamic> json) => Parking(
        id: json["id"],
        amount: json["amount"],
        duration: json["duration"],
        name: json["name"],
        location: json["location"],
        observation: json["observation"],
        tripId: json["trip_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "duration": duration,
        "name": name,
        "location": location,
        "observation": observation,
        "trip_id": tripId,
      };
}

class Stop {
  String id;
  String location;
  int hours;
  int minutes;
  int tripId;

  Stop({
    required this.id,
    required this.location,
    required this.hours,
    required this.minutes,
    required this.tripId,
  });

  factory Stop.fromJson(Map<String, dynamic> json) => Stop(
        id: json["id"],
        location: json["location"],
        hours: json["hours"],
        minutes: json["minutes"],
        tripId: json["trip_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "location": location,
        "hours": hours,
        "minutes": minutes,
        "trip_id": tripId,
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

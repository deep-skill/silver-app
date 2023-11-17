class TripDriverStatus {
  //TODO: Modify totalPrice to notNull and double
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
  List<Toll> tolls;

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
    required this.tolls,
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
        tolls:
            List<Toll>.from(json["Tolls"]?.map((x) => Toll.fromJson(x)) ?? []),
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
        "Tolls": List<dynamic>.from(tolls.map((x) => x.toJson())),
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
  double amount;
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
        amount: json["amount"].toDouble(),
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

class Toll {
  int id;
  String name;
  double amount;
  double lat;
  double lon;
  int tripId;

  Toll({
    required this.id,
    required this.name,
    required this.amount,
    required this.lat,
    required this.lon,
    required this.tripId,
  });

  factory Toll.fromJson(Map<String, dynamic> json) => Toll(
        id: json["id"],
        name: json["name"],
        amount: json["amount"].toDouble(),
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
        tripId: json["tripId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "amount": amount,
        "lat": lat,
        "lon": lon,
        "tripId": tripId,
      };
}

class TollMap {
  double amount;
  String id;
  double lat;
  double lon;
  String name;

  TollMap({
    required this.amount,
    required this.id,
    required this.lat,
    required this.lon,
    required this.name,
  });

  factory TollMap.fromJson(Map<String, dynamic> json) => TollMap(
        amount: json["amount"]?.toDouble(),
        id: json["id"],
        lat: json["location"]["lat"]?.toDouble(),
        lon: json["location"]["lon"]?.toDouble(),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "id": id,
        "lat": lat,
        "lon": lon,
        "name": name,
      };
}

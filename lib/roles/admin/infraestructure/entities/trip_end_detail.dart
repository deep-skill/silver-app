class AdminTripEnd {
  int id;
  double totalPrice;
  DateTime onWayDriver;
  DateTime? arrivedDriver;
  DateTime? startTime;
  DateTime? endTime;
  String status;
  String startAddress;
  String endAddress;
  double price;
  int driverPercent;
  int silverPercent;
  String userName;
  String userLastName;
  String? enterpriseName;
  String? driverName;
  String? driverLastName;
  String licensePlate;
  String brand;
  String model;
  String color;
  String tripType;
  String serviceType;
  List<Stop> stops;
  List<Observations> observations;
  List<Parking> parkings;
  List<Toll> tolls;

  AdminTripEnd({
    required this.id,
    required this.onWayDriver,
    required this.status,
    required this.totalPrice,
    required this.arrivedDriver,
    required this.startTime,
    required this.endTime,
    required this.startAddress,
    required this.endAddress,
    required this.price,
    required this.driverPercent,
    required this.silverPercent,
    required this.userName,
    required this.userLastName,
    required this.enterpriseName,
    required this.driverName,
    required this.driverLastName,
    required this.licensePlate,
    required this.brand,
    required this.model,
    required this.color,
    required this.tripType,
    required this.serviceType,
    required this.stops,
    required this.observations,
    required this.parkings,
    required this.tolls,
  });

  factory AdminTripEnd.fromJson(Map<String, dynamic> json) => AdminTripEnd(
        id: json["id"],
        status: json["status"],
        totalPrice: json["totalPrice"].toDouble(),
        onWayDriver: DateTime.parse(json["onWayDriver"]),
        arrivedDriver: json["arrivedDriver"] == null
            ? null
            : DateTime.parse(json["arrivedDriver"]),
        startTime: json["startTime"] == null
            ? null
            : DateTime.parse(json["startTime"]),
        endTime:
            json["endTime"] == null ? null : DateTime.parse(json["endTime"]),
        startAddress: json["Reserve"]["startAddress"],
        endAddress: json["Reserve"]["endAddress"],
        price: json["Reserve"]["price"].toDouble(),
        driverPercent: json["Reserve"]["driverPercent"],
        silverPercent: json["Reserve"]["silverPercent"],
        userName: json["Reserve"]["User"]["name"] ?? "no-user-name",
        userLastName: json["Reserve"]["User"]["lastName"] ?? "no-user-lastName",
        enterpriseName: json["Reserve"]["Enterprise"]["name"],
        driverName: json["Reserve"]["Driver"] != null
            ? json["Reserve"]["Driver"]["name"] ?? 'no-driver-name'
            : 'no-driver-name',
        driverLastName: json["Reserve"]["Driver"] != null
            ? json["Reserve"]["Driver"]["lastName"] ?? 'no-driver-name'
            : 'no-driver-name',
        licensePlate: json["Reserve"]["Car"]["licensePlate"] ?? 'no-car-plate',
        brand: json["Reserve"]["Car"]["brand"] ?? 'no-car-brand',
        model: json["Reserve"]["Car"]["model"] ?? 'no-car-model',
        color: json["Reserve"]["Car"]["color"] ?? 'no-car-color',
        tripType: json["Reserve"]["tripType"],
        serviceType: json["Reserve"]["serviceType"],
        stops:
            List<Stop>.from(json["Stops"]?.map((x) => Stop.fromJson(x)) ?? []),
        observations: List<Observations>.from(
            json["Observations"]?.map((x) => Observations.fromJson(x)) ?? []),
        parkings: List<Parking>.from(
            json["Parkings"]?.map((x) => Parking.fromJson(x)) ?? []),
        tolls:
            List<Toll>.from(json["Tolls"]?.map((x) => Toll.fromJson(x)) ?? []),
      );
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

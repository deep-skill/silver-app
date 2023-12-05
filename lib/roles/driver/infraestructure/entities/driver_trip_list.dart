import 'package:silverapp/roles/driver/infraestructure/entities/driver_trip_state.dart';

class DriverTripList {
  int id;
  double totalPrice;
  DateTime onWayDriver;
  String status;
  String name;
  String lastName;
  String? enterpriseName;
  int silverPercent;
  List<Toll> tolls;
  List<Parking> parkings;

  DriverTripList(
      {required this.id,
      required this.onWayDriver,
      required this.status,
      required this.totalPrice,
      required this.name,
      required this.lastName,
      this.enterpriseName,
      required this.silverPercent,
      required this.tolls,
      required this.parkings});

  factory DriverTripList.fromJson(Map<String, dynamic> json) => DriverTripList(
        id: json["id"],
        onWayDriver: DateTime.parse(json["onWayDriver"]).toLocal(),
        status: json["status"],
        totalPrice: json["totalPrice"].toDouble(),
        name: json["Reserve"]["User"]["name"],
        lastName: json["Reserve"]["User"]["lastName"],
        enterpriseName: json["Reserve"]["Enterprise"] != null
            ? json["Reserve"]["Enterprise"]["name"]
            : null,
        silverPercent: json["Reserve"]["silverPercent"],
        tolls:
            List<Toll>.from(json["Tolls"]?.map((x) => Toll.fromJson(x)) ?? []),
        parkings: List<Parking>.from(
            json["Parkings"]?.map((x) => Parking.fromJson(x)) ?? []),
      );
}

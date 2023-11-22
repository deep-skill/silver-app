import 'package:silverapp/roles/driver/infraestructure/entities/driver_trip_state.dart';

class ListTripDriver {
  DateTime onWayDriver;
  String status;
  double totalPrice;
  String userName;
  String lastName;
  String enterpriseName;
  List<Toll> tolls;
  List<Parking> parkings;

  ListTripDriver(
      {required this.onWayDriver,
      required this.status,
      required this.totalPrice,
      required this.userName,
      required this.lastName,
      required this.enterpriseName,
      required this.tolls,
      required this.parkings});

  factory ListTripDriver.fromJson(Map<String, dynamic> json) => ListTripDriver(
        onWayDriver: DateTime.parse(json["onWayDriver"]),
        status: json["status"],
        totalPrice: json["totalPrice"].toDouble(),
        userName: json["Reserve"]["User"]["name"],
        lastName: json["Reserve"]["User"]["lastName"],
        enterpriseName: json["Reserve"]["Enterprise"]["name"],
        tolls:
            List<Toll>.from(json["Tolls"]?.map((x) => Toll.fromJson(x)) ?? []),
        parkings: List<Parking>.from(
            json["Parkings"]?.map((x) => Parking.fromJson(x)) ?? []),
      );
}

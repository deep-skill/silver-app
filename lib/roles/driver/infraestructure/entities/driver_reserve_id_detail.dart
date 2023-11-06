// To parse this JSON data, do
//
//     final driverReserveById = driverReserveByIdFromJson(jsonString);

import 'dart:convert';

DriverReserveById driverReserveByIdFromJson(String str) =>
    DriverReserveById.fromJson(json.decode(str));

String driverReserveByIdToJson(DriverReserveById data) =>
    json.encode(data.toJson());

class DriverReserveById {
  int id;
  DateTime startTime;
  String serviceType;
  String tripType;
  String startAddress;
  String endAddress;
  double price;
  String user;
  String status;
  String enterprise;

  DriverReserveById({
    required this.id,
    required this.startTime,
    required this.serviceType,
    required this.tripType,
    required this.startAddress,
    required this.endAddress,
    required this.price,
    required this.user,
    required this.status,
    required this.enterprise,
  });

  factory DriverReserveById.fromJson(Map<String, dynamic> json) =>
      DriverReserveById(
        id: json["id"],
        startTime: DateTime.parse(json["startTime"]),
        serviceType: json["serviceType"],
        tripType: json["tripType"],
        startAddress: json["startAddress"],
        endAddress: json["endAddress"],
        price: json["price"]?.toDouble(),
        user: json["user"],
        status: json["status"],
        enterprise: json["enterprise"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "startTime": startTime.toIso8601String(),
        "serviceType": serviceType,
        "tripType": tripType,
        "startAddress": startAddress,
        "endAddress": endAddress,
        "price": price,
        "user": user,
        "status": status,
        "enterprise": enterprise,
      };
}

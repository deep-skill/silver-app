class DriverReserveDetail {
  int id;
  DateTime startTime;
  String serviceType;
  String tripType;
  String startAddress;
  String endAddress;
  double price;
  String name;
  String lastName;
  String? state;
  String enterpriseName;

  DriverReserveDetail({
    required this.id,
    required this.startTime,
    required this.serviceType,
    required this.tripType,
    required this.startAddress,
    required this.endAddress,
    required this.price,
    required this.name,
    required this.lastName,
    required this.state,
    required this.enterpriseName,
  });

  factory DriverReserveDetail.fromJson(Map<String, dynamic> json) =>
      DriverReserveDetail(
        id: json["id"],
        startTime: DateTime.parse(json["startTime"]),
        serviceType: json["serviceType"],
        tripType: json["tripType"],
        startAddress: json["startAddress"],
        endAddress: json["endAddress"],
        price: json["price"]?.toDouble(),
        name: json["User"]["name"],
        lastName: json["User"]["lastName"],
        state: (json["Trip"] == null) ? null : json["Trip"]["state"],
        enterpriseName: json["Enterprise"]["name"],
      );
}

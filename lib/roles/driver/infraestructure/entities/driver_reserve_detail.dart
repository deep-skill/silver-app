class DriverReserveDetail {
  int id;
  DateTime startTime;
  String serviceType;
  String tripType;
  String startAddress;
  String? endAddress;
  double price;
  String name;
  String lastName;
  String? state;
  String? enterpriseName;
  int silverPercent;
  String? reserveDistanceMeters;

  DriverReserveDetail(
      {required this.id,
      required this.startTime,
      required this.serviceType,
      required this.tripType,
      required this.startAddress,
      this.endAddress,
      required this.price,
      required this.name,
      required this.lastName,
      required this.state,
      this.enterpriseName,
      required this.silverPercent,
      this.reserveDistanceMeters});

  factory DriverReserveDetail.fromJson(Map<String, dynamic> json) =>
      DriverReserveDetail(
          id: json["id"],
          startTime: DateTime.parse(json["startTime"]).toLocal(),
          serviceType: json["serviceType"],
          tripType: json["tripType"],
          startAddress: json["startAddress"],
          endAddress: json["endAddress"],
          price: json["price"].toDouble(),
          name: json["User"]["name"],
          lastName: json["User"]["lastName"],
          state: (json["Trip"] == null) ? null : json["Trip"]["status"],
          enterpriseName:
              json["Enterprise"] == null ? null : json["Enterprise"]["name"],
          silverPercent: json["silverPercent"],
          reserveDistanceMeters: json["reserveDistanceMeters"]);
}

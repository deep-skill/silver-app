class ReserveDetailResponse {
  ReserveDetailResponse(
      {required this.id,
      required this.startTime,
      required this.name,
      required this.lastName,
      required this.serviceType,
      required this.entrepriseName,
      required this.driverName,
      required this.driverLastName,
      required this.licensePlate,
      required this.brand,
      required this.model,
      required this.color,
      required this.tripType,
      required this.startAddress,
      required this.endAddress,
      required this.price,
      required this.silverPercent});

  final int id;
  final DateTime startTime;
  final String name;
  final String lastName;
  final String serviceType;
  final String entrepriseName;
  final String driverName;
  final String driverLastName;
  final String licensePlate;
  final String brand;
  final String model;
  final String color;
  final String tripType;
  final String startAddress;
  final String endAddress;
  final String price;
  final String silverPercent;

  factory ReserveDetailResponse.fromJson(Map<String, dynamic> json) =>
      ReserveDetailResponse(
        id: json["id"],
        startTime: json["startTime"],
        name: json["name"],
        lastName: json["lastName"],
        serviceType: json["serviceType"],
        entrepriseName: json["entrepriseName"],
        driverName: json["driverName"],
        driverLastName: json["driverLastName"],
        licensePlate: json["licensePlate"],
        brand: json["brand"],
        model: json["model"],
        color: json["color"],
        tripType: json["tripType"],
        startAddress: json["startAddress"],
        endAddress: json["endAddress"],
        price: json["price"],
        silverPercent: json["silverPercent"],
      );
}

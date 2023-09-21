class ReserveDetailResponse {
  ReserveDetailResponse(
      {required this.id,
      required this.userId,
      required this.enterpriseId,
      required this.driverId,
      required this.carId,
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
  final int userId;
  final int enterpriseId;
  final int driverId;
  final int carId;
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
        userId: json["userId"],
        enterpriseId: json["enterpriseId"],
        driverId: json["driverId"],
        carId: json["carId"],
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

class CreateReserve {
  int? id;
  int userId;
  String userName;
  String userLastName;
  int enterpriseId;
  int? carId;
  int? licensePlate;
  int? driverId;
  String? driverName;
  String? driverLastName;
  String tripType;
  String serviceType;
  String startTime;
  String startAddress;
  String? endAddress;
  double price;
  int driverPercent;
  int silverPercent;

  CreateReserve({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userLastName,
    required this.enterpriseId,
    this.driverId,
    this.driverName,
    this.driverLastName,
    this.carId,
    this.licensePlate,
    required this.tripType,
    required this.serviceType,
    required this.startTime,
    required this.startAddress,
    this.endAddress,
    required this.price,
    required this.driverPercent,
    required this.silverPercent,
  });

  factory CreateReserve.fromJson(Map<String, dynamic> json) => CreateReserve(
        id: json['id'],
        userId: json['User']['id'],
        userName: json['User']['name'],
        userLastName: json['User']['lastName'],
        enterpriseId: json['Enterprise']['id'],
        driverId: json['Driver'] == null ? null : json['Driver']['id'],
        driverName: json['Driver'] == null ? null : json['Driver']['name'],
        driverLastName:
            json['Driver'] == null ? null : json['Driver']['lastName'],
        carId: json['Car'] == null ? null : json['Car']['id'],
        licensePlate: json['Car'] == null ? null : json['Car']['licensePlate'],
        tripType: json['tripType'],
        serviceType: json['serviceType'],
        startAddress: json['startAddress'],
        endAddress: json['endAddress'],
        price: json['price'],
        silverPercent: json['silverPercent'],
        driverPercent: json['driverPercent'],
        startTime: json['startTime'],
      );
}

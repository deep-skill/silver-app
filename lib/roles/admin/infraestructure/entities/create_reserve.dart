class CreateReserve {
  int? id;
  int? tripId;
  int userId;
  String userName;
  String userLastName;
  int? enterpriseId;
  int? carId;
  String? licensePlate;
  String? brand;
  String? model;
  String? color;
  int? driverId;
  String? driverName;
  String? driverLastName;
  String tripType;
  String serviceType;
  String startTime;
  String startDate;
  String startAddress;
  String? endAddress;
  String price;
  int driverPercent;
  String silverPercent;

  CreateReserve({
    required this.id,
    this.tripId,
    required this.userId,
    required this.userName,
    required this.userLastName,
    required this.enterpriseId,
    this.driverId,
    this.driverName,
    this.driverLastName,
    this.carId,
    this.licensePlate,
    this.brand,
    this.model,
    this.color,
    required this.tripType,
    required this.serviceType,
    required this.startTime,
    required this.startDate,
    required this.startAddress,
    this.endAddress,
    required this.price,
    required this.driverPercent,
    required this.silverPercent,
  });

  factory CreateReserve.fromJson(Map<String, dynamic> json) => CreateReserve(
        id: json['id'],
        tripId: json['Trip'] == null ? null : json["Trip"]['id'],
        userId: json['User'] == null ? null : json['User']['id'],
        userName: json['User'] == null ? null : json['User']['name'],
        userLastName: json['User'] == null ? null : json['User']['lastName'],
        enterpriseId:
            json['Enterprise'] == null ? null : json['Enterprise']['id'],
        driverId: json['Driver'] == null ? null : json['Driver']['id'],
        driverName: json['Driver'] == null ? null : json['Driver']['name'],
        driverLastName:
            json['Driver'] == null ? null : json['Driver']['lastName'],
        carId: json['Car'] == null ? null : json['Car']['id'],
        licensePlate: json['Car'] == null ? null : json['Car']['licensePlate'],
        brand: json['Car'] == null ? null : json['Car']['brand'],
        model: json['Car'] == null ? null : json['Car']['model'],
        color: json['Car'] == null ? null : json['Car']['color'],
        tripType: json['tripType'],
        serviceType: json['serviceType'],
        startAddress: json['startAddress'],
        endAddress: json['endAddress'],
        price: json['price'].toString(),
        driverPercent: 0,
        silverPercent: json['silverPercent'].toString(),
        startTime: json['startTime'].substring(11, 16),
        startDate: json['startTime'].substring(0, 10),
      );
}

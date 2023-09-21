class CreateReserve {
  int userId;
  int enterpriseId;
  int? carId;
  int? driverId;
  String tripType;
  String serviceType;
  String startTime;
  String startAddress;
  String? endAddress;
  double price;
  int driverPercent;
  int silverPercent;

  CreateReserve({
    required this.userId,
    required this.enterpriseId,
    this.carId,
    this.driverId,
    required this.tripType,
    required this.serviceType,
    required this.startTime,
    required this.startAddress,
    this.endAddress,
    required this.price,
    required this.driverPercent,
    required this.silverPercent,
  });
}

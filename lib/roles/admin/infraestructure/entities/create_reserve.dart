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
  String serviceCarType;
  String serviceType;
  String startTime;
  String startDate;
  String startAddress;
  double startAddressLat;
  double startAddressLon;
  String? endAddress;
  double? endAddressLat;
  double? endAddressLon;
  String price;
  String? suggestedPrice;
  int driverPercent;
  String silverPercent;
  String? polyline;
  String? tripTotalPrice;
  String? reserveDistanceMeters;

  CreateReserve(
      {required this.id,
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
      required this.serviceCarType,
      required this.serviceType,
      required this.startTime,
      required this.startDate,
      required this.startAddress,
      required this.startAddressLat,
      required this.startAddressLon,
      this.endAddress,
      this.endAddressLat,
      this.endAddressLon,
      required this.price,
      this.suggestedPrice,
      required this.driverPercent,
      required this.silverPercent,
      this.polyline,
      this.tripTotalPrice,
      this.reserveDistanceMeters});

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
        serviceCarType: json['serviceCarType'],
        serviceType: json['serviceType'],
        startAddress: json['startAddress'],
        startAddressLat: json['startAddressLat'],
        startAddressLon: json['startAddressLon'],
        endAddress: json['endAddress'],
        endAddressLat: json['endAddressLat'],
        endAddressLon: json['endAddressLon'],
        price: json['price'].toString(),
        suggestedPrice: json['suggestedPrice']?.toString(),
        driverPercent: 0,
        silverPercent: json['silverPercent'].toString(),
        startTime:
            '${DateTime.parse(json['startTime']).toLocal().hour.toString().padLeft(2, '0')}:${DateTime.parse(json['startTime']).toLocal().minute.toString().padLeft(2, '0')}',
        startDate:
            '${DateTime.parse(json['startTime']).toLocal().year.toString()}-${DateTime.parse(json['startTime']).toLocal().month.toString().padLeft(2, '0')}-${DateTime.parse(json['startTime']).toLocal().day.toString().padLeft(2, '0')}',
        polyline: json['polyline'],
        tripTotalPrice:
            json['Trip'] == null ? null : json['Trip']['totalPrice'].toString(),
        reserveDistanceMeters: json['reserveDistanceMeters'],
      );
}

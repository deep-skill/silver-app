class ReserveDetail {
  final int id;
  final int userId;
  final int? enterpriseId;
  final int? driverId;
  final int? carId;
  final DateTime startTime;
  final String name;
  final String lastName;
  final String serviceType;
  final String entrepriseName;
  final String? driverName;
  final String? driverLastName;
  final String? licensePlate;
  final String? brand;
  final String? model;
  final String? color;
  final String tripType;
  final String startAddress;
  final String? endAddress;
  final String price;
  final String silverPercent;

  ReserveDetail(
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

  factory ReserveDetail.fromJson(Map<String, dynamic> json) => ReserveDetail(
        id: json['id'],
        userId: json['User']['id'],
        enterpriseId: json['Enterprise'] == null ? null : json['Enterprise']['id'],
        driverId: json['Driver'] == null ? null : json['Driver']['id'],
        carId: json['Car'] == null ? null : json['Car']['id'],
        tripType: json['tripType'],
        serviceType: json['serviceType'],
        startAddress: json['startAddress'],
        endAddress: json['endAddress'],
        price: json['price'].toString(),
        silverPercent: json['silverPercent'].toString(),
        startTime: DateTime.parse(json['startTime']),
        name: json['User']['name'],
        lastName: json['User']['lastName'],
        entrepriseName: json['Enterprise'] == null ? 'Viaje personal' : json['Enterprise']['name'],
        driverName: json['Driver'] == null ? '' : json['Driver']['name'],
        driverLastName:
            json['Driver'] == null ? '' : json['Driver']['lastName'],
        licensePlate: json['Car'] == null ? '' : json['Car']['licensePlate'],
        brand: json['Car'] == null ? '' : json['Car']['brand'],
        model: json['Car'] == null ? '' : json['Car']['model'],
        color: json['Car'] == null ? '' : json['Car']['color'],
      );
}

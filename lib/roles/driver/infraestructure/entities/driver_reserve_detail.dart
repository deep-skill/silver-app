class DriverReserveDetail {
  final int id;
  final int userId;
  final int? enterpriseId;
  final DateTime startTime;
  final String name;
  final String lastName;
  final String serviceType;
  final String entrepriseName;
  final String tripType;
  final String startAddress;
  final String? endAddress;
  final String price;

  DriverReserveDetail(
      {required this.id,
      required this.userId,
      required this.enterpriseId,
      required this.startTime,
      required this.name,
      required this.lastName,
      required this.serviceType,
      required this.entrepriseName,
      required this.tripType,
      required this.startAddress,
      required this.endAddress,
      required this.price});

  factory DriverReserveDetail.fromJson(Map<String, dynamic> json) =>
      DriverReserveDetail(
        id: json['id'],
        userId: json['User']['id'],
        enterpriseId:
            json['Enterprise'] == null ? null : json['Enterprise']['id'],
        tripType: json['tripType'],
        serviceType: json['serviceType'],
        startAddress: json['startAddress'],
        endAddress: json['endAddress'],
        price: json['price'].toString(),
        startTime: DateTime.parse(json['startTime']),
        name: json['User']['name'],
        lastName: json['User']['lastName'],
        entrepriseName: json['Enterprise'] == null
            ? 'Viaje personal'
            : json['Enterprise']['name'],
      );
}

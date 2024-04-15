class ReserveList {
  final int id;
  final String tripType;
  final String serviceType;
  final DateTime startTime;
  final String name;
  final String lastName;
  final String entrepriseName;
  final String driverName;
  final String driverLastName;
  final String carType;
  final int? tripId;
  final String? driverImageUrl;

  ReserveList({
    required this.id,
    required this.tripType,
    required this.serviceType,
    required this.startTime,
    required this.name,
    required this.lastName,
    required this.entrepriseName,
    required this.driverName,
    required this.driverLastName,
    required this.carType,
    this.driverImageUrl,
    this.tripId,
  });
  factory ReserveList.fromJson(Map<String, dynamic> json) => ReserveList(
        id: json['id'],
        tripType: json['tripType'],
        serviceType: json['serviceType'],
        startTime: DateTime.parse(json['startTime']).toLocal(),
        name: json['User'] == null ? '' : json['User']['name'],
        lastName: json['User']['lastName'],
        entrepriseName: json['Enterprise'] == null
            ? 'Viaje personal'
            : json['Enterprise']['name'],
        driverName: json['Driver'] == null ? '' : json['Driver']['name'],
        driverLastName:
            json['Driver'] == null ? '' : json['Driver']['lastName'],
        carType: json['Car'] == null ? '' : json['Car']['type'],
        tripId: json['Trip'] == null ? null : json['Trip']['id'],
        driverImageUrl:
            json['Driver'] == null ? null : json['Driver']['imageUrl'],
      );
}

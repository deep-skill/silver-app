class ReserveHome {
  final int id;
  final String tripType;
  final DateTime startTime;
  final String name;
  final String lastName;
  final String serviceType;
  final String entrepriseName;

  ReserveHome({
    required this.id,
    required this.tripType,
    required this.startTime,
    required this.name,
    required this.lastName,
    required this.entrepriseName,
    required this.serviceType,
  });
  factory ReserveHome.fromJson(Map<String, dynamic> json) => ReserveHome(
        id: json['id'],
        tripType: json['tripType'],
        serviceType: json['serviceType'],
        startTime: DateTime.parse(json['startTime']).toLocal(),
        name: json['User']['name'],
        lastName: json['User']['lastName'],
        entrepriseName: json['Enterprise'] == null
            ? 'Viaje personal'
            : json['Enterprise']['name'],
      );
}

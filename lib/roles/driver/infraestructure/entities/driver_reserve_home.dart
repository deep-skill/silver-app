class DriverReserveHome {
  final int id;
  final DateTime startTime;
  final String name;
  final String lastName;
  final String entrepriseName;

  DriverReserveHome({
    required this.id,
    required this.startTime,
    required this.name,
    required this.lastName,
    required this.entrepriseName,
  });
  factory DriverReserveHome.fromJson(Map<String, dynamic> json) => DriverReserveHome(
        id: json['id'],
        startTime: DateTime.parse(json['startTime']),
        name: json['User']['name'],
        lastName: json['User']['lastName'],
        entrepriseName: json['Enterprise'] == null ? 'Viaje personal' : json['Enterprise']['name'],
      );
}

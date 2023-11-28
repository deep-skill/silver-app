class DriverReserveHome {
  final int id;
  final DateTime startTime;
  final String name;
  final String lastName;
  final String entrepriseName;
  final String startAddress;

  DriverReserveHome({
    required this.id,
    required this.startTime,
    required this.name,
    required this.lastName,
    required this.entrepriseName,
    required this.startAddress,
  });
  factory DriverReserveHome.fromJson(Map<String, dynamic> json) => DriverReserveHome(
        id: json['id'],
        startTime: DateTime.parse(json['startTime']).toLocal(),
        name: json['User']['name'],
        lastName: json['User']['lastName'],
        entrepriseName: json['Enterprise'] == null ? 'Viaje personal' : json['Enterprise']['name'],
        startAddress: json['startAddress'],
      );
}

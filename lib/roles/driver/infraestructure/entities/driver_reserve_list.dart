class DriverReserveList {
  final int id;
  final DateTime startTime;
  final String startAddress;
  final String name;
  final String lastName;
  final String? entrepriseName;
  final int? tripId;

  DriverReserveList({
    required this.id,
    required this.startTime,
    required this.startAddress,
    required this.name,
    required this.lastName,
    required this.entrepriseName,
    this.tripId,
  });
  factory DriverReserveList.fromJson(Map<String, dynamic> json) =>
      DriverReserveList(
        id: json['id'],
        startAddress: json['startAddress'],
        startTime: DateTime.parse(json['startTime']).toLocal(),
        name: json['User'] == null ? '' : json['User']['name'],
        lastName: json['User']['lastName'],
        entrepriseName: json['Enterprise'] == null
            ? 'Viaje personal'
            : json['Enterprise']['name'],
        tripId: json['Trip'] == null ? null : json['Trip']['id'],
      );
}

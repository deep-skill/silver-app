class TripList {
  final int id;
  final double? totalPrice;
  final DateTime onWayDriver;
  final String status;
  final int reserveId;
  final String startAddress;
  final int userId;
  final String serviceType;
  final String userName;
  final String userLastName;
  final int? driverId;
  final String? driverName;
  final String? driverLastName;
  final int? enterpriseId;
  final String enterpriseName;
  final DateTime? startTime;
  final String? driverImageUrl;
  TripList({
    required this.id,
    this.totalPrice,
    required this.onWayDriver,
    required this.serviceType,
    required this.status,
    required this.reserveId,
    required this.startAddress,
    required this.userId,
    required this.userName,
    required this.userLastName,
    required this.startTime,
    required this.enterpriseName,
    this.driverId,
    this.driverName,
    this.driverLastName,
    this.enterpriseId,
    this.driverImageUrl,
  });
  factory TripList.fromJson(Map<String, dynamic> json) => TripList(
        id: json['id'],
        onWayDriver: DateTime.parse(json['onWayDriver']).toLocal(),
        totalPrice: json['totalPrice'].toDouble(),
        status: json['status'],
        reserveId: json['Reserve']['id'],
        serviceType: json['Reserve']['serviceType'],
        startAddress: json['Reserve']['startAddress'],
        userId: json['Reserve']['User']['id'],
        userName: json['Reserve']['User']['name'],
        userLastName: json['Reserve']['User']['lastName'],
        driverId: json['Reserve']['Driver'] == null
            ? null
            : json['Reserve']['Driver']['id'],
        driverName: json['Reserve']['Driver'] == null
            ? 'no-driver-name'
            : json['Reserve']['Driver']['name'],
        driverLastName: json['Reserve']['Driver'] == null
            ? 'no-driver-lastName'
            : json['Reserve']['Driver']['lastName'],
        enterpriseId: json['Reserve']['Enterprise'] == null
            ? null
            : json['Reserve']['Enterprise']['id'],
        enterpriseName: json['Reserve']['Enterprise'] == null
            ? 'Viaje personal'
            : json['Reserve']['Enterprise']['name'],
        startTime: json['Reserve']['startTime'] == null
            ? null
            : DateTime.parse(json['Reserve']['startTime']).toLocal(),
        driverImageUrl: json['Reserve']['Driver'] == null
            ? null
            : json['Reserve']['Driver']['imageUrl'],
      );
}

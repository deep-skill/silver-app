class TripList {
  final int id;
  final int? totalPrice;
  final DateTime onWayDriver;
  final String status;
  //from reserve
  final int reserveId;
  final String startAddress;
  //from user
  final int userId;
  final String userName;
  final String userLastName;
  //from driver
  final int? driverId;
  final String? driverName;
  final String? driverLastName;
  //from enterprise
  final int? enterpriseId;
  final String? enterpriseName;

  TripList({
    required this.id,
    this.totalPrice,
    required this.onWayDriver,
    required this.status,
    required this.reserveId,
    required this.startAddress,
    required this.userId,
    required this.userName,
    required this.userLastName,
    this.driverId,
    this.driverName,
    this.driverLastName,
    this.enterpriseId,
    this.enterpriseName,
  });
  factory TripList.fromJson(Map<String, dynamic> json) => TripList(
        id: json['id'],
        totalPrice: json['totalPrice'],
        onWayDriver: DateTime.parse(json['onWayDriver']),
        status: json['status'],
        //from reserve
        reserveId: json['Reserve']['id'],
        startAddress: json['Reserve']['startAddress'],
        //from user
        userId: json['Reserve']['User']['id'],
        userName: json['Reserve']['User']['name'],
        userLastName: json['Reserve']['User']['lastName'],
        //from driver
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
            ? 'no-enterprise-id'
            : json['Reserve']['Enterprise']['id'],
        enterpriseName: json['Reserve']['Enterprise'] == null
            ? 'no-enterprise-name'
            : json['Reserve']['Enterprise']['name'],
      );
}

import 'package:silverapp/roles/driver/infraestructure/entities/driver_reserve_home.dart';

class DriverReservesPaginatedResponse {
  DriverReservesPaginatedResponse({
    required this.count,
    required this.rows,
  });

  final int count;
  final List<DriverReserveHome> rows;

  factory DriverReservesPaginatedResponse.fromJson(Map<String, dynamic> json) =>
      DriverReservesPaginatedResponse(
        count: json["count"],
        rows: List<DriverReserveHome>.from(
            json["rows"].map((x) => DriverReserveHome.fromJson(x))),
      );
}

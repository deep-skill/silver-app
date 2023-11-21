import 'package:silverapp/roles/driver/infraestructure/entities/driver_reserve_list.dart';

class DriverReservesListResponse {
  DriverReservesListResponse({
    required this.count,
    required this.rows,
  });

  final int count;
  final List<DriverReserveList> rows;

  factory DriverReservesListResponse.fromJson(Map<String, dynamic> json) =>
      DriverReservesListResponse(
        count: json["count"],
        rows: List<DriverReserveList>.from(
            json["rows"].map((x) => DriverReserveList.fromJson(x))),
      );
}

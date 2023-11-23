import 'package:silverapp/roles/driver/infraestructure/entities/driver_trip_list.dart';

class DriverTripsListResponse {
  DriverTripsListResponse({
    required this.count,
    required this.rows,
  });

  final int count;
  final List<DriverTripList> rows;

  factory DriverTripsListResponse.fromJson(Map<String, dynamic> json) =>
      DriverTripsListResponse(
        count: json["count"],
        rows: List<DriverTripList>.from(
            json["rows"].map((x) => DriverTripList.fromJson(x))),
      );
}

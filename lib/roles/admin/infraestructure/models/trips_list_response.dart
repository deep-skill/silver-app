import 'package:silverapp/roles/admin/infraestructure/entities/trip_list.dart';

class TripsListResponse {
  TripsListResponse({
    required this.count,
    required this.rows,
  });

  final int count;
  final List<TripList> rows;

  factory TripsListResponse.fromJson(Map<String, dynamic> json) =>
      TripsListResponse(
        count: json["count"],
        rows:
            List<TripList>.from(json["rows"].map((x) => TripList.fromJson(x))),
      );
}

import 'package:silverapp/roles/admin/infraestructure/entities/reserve_home.dart';

class ReservesPaginatedResponse {
  ReservesPaginatedResponse({
    required this.count,
    required this.rows,
  });

  final int count;
  final List<ReserveHome> rows;

  factory ReservesPaginatedResponse.fromJson(Map<String, dynamic> json) =>
      ReservesPaginatedResponse(
        count: json["count"],
        rows: List<ReserveHome>.from(
            json["rows"].map((x) => ReserveHome.fromJson(x))),
      );
}

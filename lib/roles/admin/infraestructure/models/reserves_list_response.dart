import 'package:silverapp/roles/admin/infraestructure/entities/reserve_list.dart';

class ReservesListResponse {
  ReservesListResponse({
    required this.count,
    required this.rows,
  });

  final int count;
  final List<ReserveList> rows;

  factory ReservesListResponse.fromJson(Map<String, dynamic> json) =>
      ReservesListResponse(
        count: json["count"],
        rows: List<ReserveList>.from(
            json["rows"].map((x) => ReserveList.fromJson(x))),
      );
}

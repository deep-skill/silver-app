import 'package:silverapp/roles/admin/infraestructure/entities/reserve_list.dart';

class SearchReserveResponse {
  SearchReserveResponse({
    required this.reserves,
  });

  final List<ReserveList> reserves;

  factory SearchReserveResponse.fromJson(List json) => SearchReserveResponse(
        reserves: List<ReserveList>.from(
            json.map((x) => ReserveList.fromJson(x))),
      );
}
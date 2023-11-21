import 'package:silverapp/roles/driver/infraestructure/entities/driver_reserve_list.dart';

class SearchDriverReserveResponse {
  SearchDriverReserveResponse({
    required this.reserves,
  });

  final List<DriverReserveList> reserves;

  factory SearchDriverReserveResponse.fromJson(List json) =>
      SearchDriverReserveResponse(
        reserves: List<DriverReserveList>.from(
            json.map((x) => DriverReserveList.fromJson(x))),
      );
}

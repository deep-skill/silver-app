
import 'package:silverapp/roles/admin/infraestructure/entities/search_driver.dart';

class SearchDriverResponse {
  SearchDriverResponse({
    required this.drivers,
  });

  final List<SearchDriver> drivers;

  factory SearchDriverResponse.fromJson(List json) => SearchDriverResponse(
        drivers: List<SearchDriver>.from(
            json.map((x) => SearchDriver.fromJson(x))),
      );
}

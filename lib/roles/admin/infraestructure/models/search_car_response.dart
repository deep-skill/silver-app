import 'package:silverapp/roles/admin/infraestructure/entities/search_car.dart';

class SearchCarResponse {
  SearchCarResponse({
    required this.cars,
  });

  final List<SearchCar> cars;

  factory SearchCarResponse.fromJson(List json) => SearchCarResponse(
        cars: List<SearchCar>.from(
            json.map((x) => SearchCar.fromJson(x))),
      );
}

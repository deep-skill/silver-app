import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/config/dio/dio.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/search_car.dart';
import 'package:silverapp/roles/admin/infraestructure/models/search_car_response.dart';

final searchCarsProvider = StateProvider<String>((ref) {
  return '';
});

List<SearchCar> _jsonToDriver(List json) {
  final carsResponse = SearchCarResponse.fromJson(json);
  final List<SearchCar> cars =
      carsResponse.cars.toList();
  return cars;
}

final searchedCarsProvider =
    StateNotifierProvider<SearchedCarsNotifier, List<SearchCar>>(
        (ref) {
  Future<List<SearchCar>> searchCar(query) async {
    if (query.isEmpty) return [];
    final response = await dio.get('/cars/cars', queryParameters: {
      'query': query,
    });
    return _jsonToDriver(response.data);
  }

  return SearchedCarsNotifier(
    searchCars: searchCar,
    ref: ref,
  );
});

typedef SearchedCarsCallback = Future<List<SearchCar>> Function(
    String query);

class SearchedCarsNotifier extends StateNotifier<List<SearchCar>> {
  SearchedCarsNotifier({
    required this.ref,
    required this.searchCars,
  }) : super([]);

  final SearchedCarsCallback searchCars;
  final Ref ref;

  Future<List<SearchCar>> searchCarsByQuery(String query) async {
    final List<SearchCar> cars = await searchCars(query);
    ref.read(searchCarsProvider.notifier).update((state) => query);
    state = cars;
    return cars;
  }
}

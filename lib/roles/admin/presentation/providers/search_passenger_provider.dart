import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/config/dio/dio.dart';
import 'package:silverapp/roles/admin/entities/search_passenger.dart';
import 'package:silverapp/roles/admin/models/search_passenger_response.dart';

final searchPassengersProvider = StateProvider<String>((ref) {
  return '';
});

List<SearchPassenger> _jsonToPassenger(List json) {
  final passengersResponse = SerchPassengerResponse.fromJson(json);
  final List<SearchPassenger> passengers =
      passengersResponse.passengers.toList();
  return passengers;
}

final searchedPassengersProvider =
    StateNotifierProvider<SearchedPassengersNotifier, List<SearchPassenger>>(
        (ref) {
  Future<List<SearchPassenger>> searchPassenger(query) async {
    if (query.isEmpty) return [];
    final response = await dio.get('/users/passengers', queryParameters: {
      'query': query,
    });
    return _jsonToPassenger(response.data);
  }

  return SearchedPassengersNotifier(
    searchPassengers: searchPassenger,
    ref: ref,
  );
});

typedef SearchedPassengersCallback = Future<List<SearchPassenger>> Function(
    String query);

class SearchedPassengersNotifier extends StateNotifier<List<SearchPassenger>> {
  SearchedPassengersNotifier({
    required this.ref,
    required this.searchPassengers,
  }) : super([]);

  final SearchedPassengersCallback searchPassengers;
  final Ref ref;

  Future<List<SearchPassenger>> searchMoviesByQuery(String query) async {
    final List<SearchPassenger> passengers = await searchPassengers(query);
    ref.read(searchPassengersProvider.notifier).update((state) => query);
    state = passengers;
    return passengers;
  }
}

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/env/env.dart';
import 'package:silverapp/roles/user/entities/reserves_home.dart';
import 'package:silverapp/roles/user/models/reserves_paginated_response.dart';

final dio = Dio(BaseOptions(
  baseUrl: Env.httpRequest,
));

List<ReserveHome> _jsonToReserves(Map<String, dynamic> json) {
  final reservesResponse = ReservesPaginatedResponse.fromJson(json);
  final List<ReserveHome> reserves = reservesResponse.rows.toList();
  return reserves;
}

final reservesProvider =
    StateNotifierProvider<ReservesNotifier, List<ReserveHome>>((ref) {
  Future<List<ReserveHome>> getReserves({int page = 0}) async {
    final response = await dio.get('reserves/admin-home', queryParameters: {
      'page': page,
    });
    return _jsonToReserves(response.data);
  }

  final fetchMoreMovies = getReserves;
  return ReservesNotifier(fetchMoreReserves: fetchMoreMovies);
});

typedef ReserveCallback = Future<List<ReserveHome>> Function({int page});

class ReservesNotifier extends StateNotifier<List<ReserveHome>> {
  int currentPage = 0;
  bool isLoading = false;
  ReserveCallback fetchMoreReserves;

  ReservesNotifier({
    required this.fetchMoreReserves,
  }) : super([]);

  Future<void> loadNextPage() async {
    if (isLoading) return;
    //print('Loading new pages');
    isLoading = true;
    final List<ReserveHome> reserves =
        await fetchMoreReserves(page: currentPage);
    currentPage++;
    state = [...state, ...reserves];
    await Future.delayed(const Duration(milliseconds: 400));
    isLoading = false;
  }
}

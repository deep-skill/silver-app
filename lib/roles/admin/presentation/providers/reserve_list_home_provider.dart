import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/config/dio/dio.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/reserve_home.dart';
import 'package:silverapp/roles/admin/infraestructure/models/reserves_paginated_response.dart';

List<ReserveHome> _jsonToReserves(Map<String, dynamic> json) {
  final reservesResponse = ReservesPaginatedResponse.fromJson(json);
  final List<ReserveHome> reserves = reservesResponse.rows.toList();
  return reserves;
}

final reservesHomeProvider =
    StateNotifierProvider<ReservesNotifier, List<ReserveHome>>((ref) {
  Future<List<ReserveHome>> getReserves({int page = 0}) async {
    final response = await dio.get('reserves/admin-home', queryParameters: {
      'page': page,
    });
    return _jsonToReserves(response.data);
  }

  final fetchMoreReserves = getReserves;
  return ReservesNotifier(fetchMoreReserves: fetchMoreReserves);
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

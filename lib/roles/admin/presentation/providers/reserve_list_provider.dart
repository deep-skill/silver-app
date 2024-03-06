import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/config/dio/dio_request.dart';
import 'package:silverapp/providers/auth0_provider.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/reserve_list.dart';
import 'package:silverapp/roles/admin/infraestructure/models/reserves_list_response.dart';

List<ReserveList> _jsonToReserves(Map<String, dynamic> json) {
  final reserveListResponse = ReservesListResponse.fromJson(json);
  final List<ReserveList> reserves = reserveListResponse.rows.toList();
  return reserves;
}

final reservesListProvider =
    StateNotifierProvider<ReservesNotifier, List<ReserveList>>((ref) {
  Future<List<ReserveList>> getReserves({int page = 0}) async {
    Credentials? credentials = ref.watch(authProvider).credentials;
    final response = await dio(credentials!.accessToken)
        .get('reserves/admin-reserves', queryParameters: {
      'page': page,
    });
    return _jsonToReserves(response.data);
  }

  final fetchMoreReserves = getReserves;
  return ReservesNotifier(fetchMoreReserves: fetchMoreReserves);
});

typedef ReserveCallback = Future<List<ReserveList>> Function({int page});

class ReservesNotifier extends StateNotifier<List<ReserveList>> {
  int currentPage = 0;
  bool lastPage = false;
  bool isLoading = false;
  ReserveCallback fetchMoreReserves;

  ReservesNotifier({
    required this.fetchMoreReserves,
  }) : super([]);

  Future<void> loadNextPage() async {
    if (isLoading) return;
    if (lastPage) return;
    //print('Loading new pages');
    isLoading = true;
    final List<ReserveList> reserves =
        await fetchMoreReserves(page: currentPage);
    if(reserves.isEmpty) {
      lastPage = true;
    }
    currentPage++;
    state = [...state, ...reserves];
    await Future.delayed(const Duration(milliseconds: 400));
    isLoading = false;
  }

  Future<void> reloadData() async {
    if (isLoading) return;
    //print('Loading new pages');
    currentPage = 0;
    isLoading = true;
    final List<ReserveList> reserves =
        await fetchMoreReserves(page: currentPage);
    currentPage++;
    state = [];
    state = [...reserves];
    await Future.delayed(const Duration(milliseconds: 400));
    isLoading = false;
  }
}

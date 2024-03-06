import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/config/dio/dio_request.dart';
import 'package:silverapp/providers/auth0_provider.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_reserve_list.dart';
import 'package:silverapp/roles/driver/infraestructure/models/driver_reserves_list_response.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_info_provider.dart';

List<DriverReserveList> _jsonToReserves(Map<String, dynamic> json) {
  final driverReserveListResponse = DriverReservesListResponse.fromJson(json);
  final List<DriverReserveList> reserves =
      driverReserveListResponse.rows.toList();
  return reserves;
}

final driverReservesListProvider =
    StateNotifierProvider<DriverReservesNotifier, List<DriverReserveList>>(
        (ref) {
  Future<List<DriverReserveList>> getReserves({int page = 0}) async {
    final driverInfo = await ref.watch(driverInfoProvider.future);
    Credentials? credentials = ref.watch(authProvider).credentials;
    final response = await dio(credentials!.accessToken).get(
        'reserves/driver-reserves-list/${driverInfo?.id}',
        queryParameters: {
          'page': page,
        });
    return _jsonToReserves(response.data);
  }

  final fetchMoreReserves = getReserves;
  return DriverReservesNotifier(fetchMoreReserves: fetchMoreReserves);
});

typedef ReserveCallback = Future<List<DriverReserveList>> Function({int page});

class DriverReservesNotifier extends StateNotifier<List<DriverReserveList>> {
  int currentPage = 0;
  bool isLoading = false;
  ReserveCallback fetchMoreReserves;

  DriverReservesNotifier({
    required this.fetchMoreReserves,
  }) : super([]);

  Future<void> loadNextPage() async {
    if (isLoading) return;
    isLoading = true;
    final List<DriverReserveList> reserves =
        await fetchMoreReserves(page: currentPage);
    currentPage++;
    state = [...state, ...reserves];
    await Future.delayed(const Duration(milliseconds: 400));
    isLoading = false;
  }

  Future<void> reloadData() async {
    if (isLoading) return;
    currentPage = 0;
    isLoading = true;
    final List<DriverReserveList> reserves =
        await fetchMoreReserves(page: currentPage);
    currentPage++;
    state = [];
    state = [...reserves];
    await Future.delayed(const Duration(milliseconds: 400));
    isLoading = false;
  }
}

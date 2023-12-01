import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/config/dio/dio_request.dart';
import 'package:silverapp/providers/auth0_provider.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_reserve_home.dart';
import 'package:silverapp/roles/driver/infraestructure/models/driver_reserves_paginated_response.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_info_provider.dart';

List<DriverReserveHome> _jsonToReserves(Map<String, dynamic> json) {
  final driverReservesResponse = DriverReservesPaginatedResponse.fromJson(json);
  final List<DriverReserveHome> reserves = driverReservesResponse.rows.toList();
  return reserves;
}

final driverReservesHomeProvider =
    StateNotifierProvider<ReservesNotifier, List<DriverReserveHome>>((ref) {
  Credentials? credentials = ref.watch(authProvider).credentials;
  Future<List<DriverReserveHome>> getReserves({int page = 0}) async {
    final driverInfo = await ref.watch(driverInfoProvider.future);
    if (driverInfo?.id == null) {
      return _jsonToReserves({"count": 0, "rows": []});
    }
    try {
      final response = await dio(credentials!.accessToken)
          .get('reserves/driver-home/', queryParameters: {
        'id': driverInfo!.id,
        'page': page,
      });
      return _jsonToReserves(response.data);
    } catch (e) {
      print(e);
    }
    return _jsonToReserves({"count": 0, "rows": []});
  }

  final fetchMoreReserves = getReserves;
  return ReservesNotifier(fetchMoreReserves: fetchMoreReserves);
});

typedef ReserveCallback = Future<List<DriverReserveHome>> Function({int page});

class ReservesNotifier extends StateNotifier<List<DriverReserveHome>> {
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
    final List<DriverReserveHome> reserves = await fetchMoreReserves(
      page: currentPage,
    );
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
    final List<DriverReserveHome> reserves =
        await fetchMoreReserves(page: currentPage);
    currentPage++;
    state = [...reserves];
    await Future.delayed(const Duration(milliseconds: 400));
    isLoading = false;
  }
}

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/config/dio/dio_request.dart';
import 'package:silverapp/providers/auth0_provider.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_reserve_detail.dart';

final driverReserveDetailProvider = StateNotifierProvider<ReserveDetailNotifier,
    Map<String, DriverReserveDetail>>((ref) {
  Credentials? credentials = ref.watch(authProvider).credentials;
  Future<DriverReserveDetail> getReserveDetail(id) async {
    final response =
        await dio(credentials!.accessToken).get('reserves/driver-reserves/$id');
    return DriverReserveDetail.fromJson(response.data);
  }

  final fetchReserveDetail = getReserveDetail;
  return ReserveDetailNotifier(getReserveDetail: fetchReserveDetail);
});

typedef GetReserveDetailCallback = Future<DriverReserveDetail> Function(
    String reserveDetailId);

class ReserveDetailNotifier
    extends StateNotifier<Map<String, DriverReserveDetail>> {
  ReserveDetailNotifier({
    required this.getReserveDetail,
  }) : super({});

  GetReserveDetailCallback getReserveDetail;

  Future<void> loadReserveDetail(String reserveDetailId) async {
    if (state[reserveDetailId] != null) return;
    final reserveDetail = await getReserveDetail(reserveDetailId);
    state = {...state, reserveDetailId: reserveDetail};
  }
}

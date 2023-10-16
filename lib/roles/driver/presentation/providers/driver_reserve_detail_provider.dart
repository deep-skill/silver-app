import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/config/dio/dio.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_reserve_detail.dart';

final driverReserveDetailProvider = StateNotifierProvider<ReserveDetailNotifier,
    Map<String, DriverReserveDetail>>((ref) {
  Future<DriverReserveDetail> getReserveDetail(id) async {
    final response = await dio.get('reserves/admin-reserves/$id');
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

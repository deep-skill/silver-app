import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/config/dio/dio.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_reserve_id_detail.dart';
// Importa la nueva entidad

final driverReserveDetailProvider = StateNotifierProvider<ReserveDetailNotifier,
    Map<String, DriverReserveById>>((ref) {
  Future<DriverReserveById> getReserveDetail(id) async {
    final response = await dio.get('reserves/driver-reserves/$id');
    return DriverReserveById.fromJson(response.data);
  }

  final fetchReserveDetail = getReserveDetail;
  return ReserveDetailNotifier(getReserveDetail: fetchReserveDetail);
});

typedef GetReserveDetailCallback = Future<DriverReserveById> Function(
    String reserveDetailId);

class ReserveDetailNotifier
    extends StateNotifier<Map<String, DriverReserveById>> {
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

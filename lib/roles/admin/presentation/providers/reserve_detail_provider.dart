import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/config/dio/dio.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/reserve_detail.dart';

final reserveDetailProvider =
    StateNotifierProvider<ReserveDetailNotifier, Map<String, ReserveDetail>>(
        (ref) {
  Future<ReserveDetail> getReserveDetail(id) async {
    final response = await dio.get('reserves/admin-reserves/$id');
    return ReserveDetail.fromJson(response.data);
  }

  final fetchReserveDetail = getReserveDetail;
  return ReserveDetailNotifier(getReserveDetail: fetchReserveDetail);
});
Future<int> deleteReserve(String id) async {
  try {
    final response = await dio.delete('reserves/$id');
    if (response.statusCode == 204) return 204;
  } catch (e) {
    if (e is DioException) e.response?.statusCode ?? -1;
  }
  return -1;
}

typedef GetReserveDetailCallback = Future<ReserveDetail> Function(
    String reserveDetailId);

class ReserveDetailNotifier extends StateNotifier<Map<String, ReserveDetail>> {
  ReserveDetailNotifier({
    required this.getReserveDetail,
  }) : super({});

  GetReserveDetailCallback getReserveDetail;

  Future<void> loadReserveDetail(String reserveDetailId) async {
    if (state[reserveDetailId] != null) return;
    final reserveDetail = await getReserveDetail(reserveDetailId);
    state = {...state, reserveDetailId: reserveDetail};
  }

  Future<void> updateReserveDetail(String reserveDetailId) async {
    final reserveDetail = await getReserveDetail(reserveDetailId);
    state = {...state, reserveDetail.id.toString(): reserveDetail};
  }
}

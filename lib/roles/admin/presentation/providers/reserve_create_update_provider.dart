import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/config/dio/dio.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/create_reserve.dart';

final reserveCreateUpdateProvider = StateNotifierProvider.autoDispose
    .family<ReserveCreteUpdateNotifier, ReserveCreteUpdateState, String>(
        (ref, reserveId) {
  //TODO: update reserve
  Future<CreateReserve> getReserveById(String id) async {
    try {
      final response = await dio.get('/$id');
      final createReserve = CreateReserve.fromJson(response.data);
      return createReserve;
    } catch (e) {
      throw Exception(e);
    }
  }

  return ReserveCreteUpdateNotifier(
      getReserveById: getReserveById, reserveId: reserveId);
});

class ReserveCreteUpdateNotifier
    extends StateNotifier<ReserveCreteUpdateState> {
  final Future<CreateReserve> Function(String) getReserveById;

  ReserveCreteUpdateNotifier({
    required this.getReserveById,
    required String reserveId,
  }) : super(ReserveCreteUpdateState(id: reserveId)) {
    loadReserve();
  }

  CreateReserve newEmptyReserve() {
    return CreateReserve(
      id: 0,
      userId: 0,
      driverId: 0,
      userName: '',
      userLastName: '',
      enterpriseId: 0,
      tripType: '',
      serviceType: '',
      startTime: '',
      startDate: '',
      startAddress: '',
      price: 0,
      driverPercent: 0,
      silverPercent: 0,
    );
  }

  Future<void> loadReserve() async {
    try {
      if (state.id == 'new') {
        state = state.copyWith(
          isLoading: false,
          reserve: newEmptyReserve(),
        );
        return;
      }

      final reserve = await getReserveById(state.id);

      state = state.copyWith(isLoading: false, reserve: reserve);
    } catch (e) {
      print(e);
    }
  }
}

class ReserveCreteUpdateState {
  final String id;
  final CreateReserve? reserve;
  final bool isLoading;
  final bool isSaving;

  ReserveCreteUpdateState({
    required this.id,
    this.reserve,
    this.isLoading = true,
    this.isSaving = false,
  });

  ReserveCreteUpdateState copyWith({
    String? id,
    CreateReserve? reserve,
    bool? isLoading,
    bool? isSaving,
  }) =>
      ReserveCreteUpdateState(
        id: id ?? this.id,
        reserve: reserve ?? this.reserve,
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
      );
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/config/dio/dio.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/reserve_list.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_info_provider.dart';

final nearestReserveProvider = FutureProvider((
  ref,
) async {
  final driverInfo = await ref.watch(driverInfoProvider.future);
  if (driverInfo != null) {
    final response = await dio.get('reserves/driver-nearest/${driverInfo.id}');
    final ReserveList reserve = ReserveList.fromJson(response.data);

    return reserve;
  }
  return null;
});

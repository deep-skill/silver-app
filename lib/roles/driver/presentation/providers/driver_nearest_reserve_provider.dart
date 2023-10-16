import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/config/dio/dio.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_reserve_list.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_info_provider.dart';

final nearestReserveProvider = FutureProvider((
  ref,
) async {
  final driverInfo = await ref.watch(driverInfoProvider.future);
  if (driverInfo != null) {
    final response = await dio.get('reserves/driver-nearest/${driverInfo.id}');
    if (response.data != null) {
      final DriverReserveList reserve =
          DriverReserveList.fromJson(response.data);
      return reserve;
    }
  }
  return null;
});

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/config/dio/dio2.dart';
import 'package:silverapp/providers/auth0_provider.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_reserve_list.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_info_provider.dart';

final nearestReserveProvider = FutureProvider((
  ref,
) async {
  final driverInfo = await ref.watch(driverInfoProvider.future);
  Credentials? credentials = ref.watch(authProvider).credentials;

  try {
    if (driverInfo != null) {
      final response = await dio2(credentials!.accessToken)
          .get('reserves/driver-nearest/${driverInfo.id}');
      if (response.data != null) {
        final DriverReserveList reserve =
            DriverReserveList.fromJson(response.data);
        return reserve;
      }
    }
  } catch (e) {
    print(e);
  }
  return null;
});

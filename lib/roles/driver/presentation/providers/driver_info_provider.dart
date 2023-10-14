import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/config/dio/dio.dart';
import 'package:silverapp/providers/auth0_provider.dart';
import 'package:silverapp/roles/driver/infraestructure/models/driver_info_response.dart';

final driverInfoProvider = FutureProvider((ref) async {
  String? email = ref.watch(authProvider).user?.email;
  if (email != null) {
    final response = await dio.get('drivers/driver', queryParameters: {
      'query': email,
    });

    final DriverInfoResponse driverInfo =
        DriverInfoResponse.fromJson(response.data);
    return driverInfo;
  } else {
  return null;
  }
});

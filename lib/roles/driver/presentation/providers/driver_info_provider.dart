import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/config/dio/dio2.dart';
import 'package:silverapp/providers/auth0_provider.dart';
import 'package:silverapp/roles/driver/infraestructure/models/driver_info_response.dart';

final driverInfoProvider = FutureProvider((ref) async {
  String? email = ref.watch(authProvider).user?.email;
  Credentials? credentials = ref.watch(authProvider).credentials;
  if (email != null) {
    try {
      final response = await dio2(credentials!.accessToken)
          .get('drivers/driver', queryParameters: {
        'query': email,
      });

      final DriverInfoResponse driverInfo =
          DriverInfoResponse.fromJson(response.data);
      return driverInfo;
    } catch (e) {
      print(e);
    }
  } else {
    return null;
  }
});

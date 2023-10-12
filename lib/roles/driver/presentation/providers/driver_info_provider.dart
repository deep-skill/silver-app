import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/config/dio/dio.dart';
import 'package:silverapp/roles/driver/infraestructure/models/driver_info_response.dart';

final driverInfoProvider = FutureProvider.family((ref, String? email) async {
  final response = await dio.get('drivers/driver', queryParameters: {
    'query': email,
  });

  final DriverInfoResponse driverInfo =
      DriverInfoResponse.fromJson(response.data);
  return driverInfo;
});

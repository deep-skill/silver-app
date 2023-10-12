import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/roles/driver/infraestructure/models/driver_info_response.dart';

class CustomDriverName extends StatelessWidget {
  const CustomDriverName({
    super.key,
    required this.driverInfo,
  });
  final AsyncValue<DriverInfoResponse> driverInfo;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return driverInfo.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (err, stack) => Text('Error: $err'),
                  data: (driverInfo) {
                    return SizedBox(
                      width: size.width * .65,
                      child: Text('${driverInfo.name} ${driverInfo.lastName}',
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: Colors.black,
                            fontSize: 20,
                                  fontWeight: FontWeight.bold,
                          )),
                    );
                  },
                );
  }
}
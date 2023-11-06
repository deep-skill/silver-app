import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/roles/driver/infraestructure/models/driver_info_response.dart';
import 'package:silverapp/roles/driver/presentation/widgets/custom_driver_name.dart';

class CustomRowWidget extends StatelessWidget {
  final AsyncValue<DriverInfoResponse?> driverInfo;

  const CustomRowWidget({super.key, required this.driverInfo});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            SizedBox(
              child: Image.asset(
                "assets/images/app_logo.png",
                width: MediaQuery.of(context).size.width * 0.2,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.04,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '¡Hola!',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomDriverName(driverInfo: driverInfo),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

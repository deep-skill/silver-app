import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BoxStatusReserveDetail extends StatelessWidget {
  final String label;

  final String? tripStatus;

  const BoxStatusReserveDetail({
    super.key,
    required this.label,
    this.tripStatus,
  });

  @override
  Widget build(BuildContext context) {
    String textStatus;
    Color colorStatus;
    IconData iconStatus;
    if (tripStatus == null) {
      textStatus = 'Pendiente';
      colorStatus = Colors.red;
      iconStatus = Icons.cached;
    } else if (tripStatus == 'INPROGRESS') {
      textStatus = 'En progreso';
      colorStatus = Colors.blue;
      iconStatus = Icons.track_changes;
    } else if (tripStatus == 'CANCELED') {
      textStatus = 'Cancelado';
      colorStatus = Colors.red;
      iconStatus = Icons.cancel_outlined;
    } else if (tripStatus == 'COMPLETED') {
      textStatus = 'Completado';
      colorStatus = Colors.green;
      iconStatus = Icons.check;
    } else {
      textStatus = 'Estado Desconocido';
      colorStatus = Colors.red;
      iconStatus = Icons.cached;
    }

    return kIsWeb
        ? Row(
            children: [
              Icon(
                iconStatus,
              ),
              const SizedBox(width: 8.0),
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: Color(0xFF23A5CD),
                        fontFamily: "Montserrat-Medium",
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      textStatus,
                      style: TextStyle(
                        color: colorStatus,
                        fontFamily: "Montserrat-Medium",
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          )
        : Row(
            children: [
              Icon(
                iconStatus,
              ),
              const SizedBox(width: 8.0),
              SizedBox(
                width: MediaQuery.of(context).size.width * .30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                          color: Color(0xFF23A5CD),
                          fontFamily: "Montserrat-Medium",
                          fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      textStatus,
                      style: TextStyle(
                        color: colorStatus,
                        fontFamily: "Montserrat-Regular",
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Container(
                      height: 2.0,
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/config/dio/dio.dart';

class AlertTripEnd extends StatefulWidget {
  final int tripId;
  final VoidCallback reload;
  final String tripType;
  final DateTime? arrivedDriver;
  const AlertTripEnd({
    Key? key,
    required this.tripId,
    required this.reload,
    required this.tripType,
    required this.arrivedDriver,
  }) : super(key: key);
  @override
  State<AlertTripEnd> createState() => _AlertTripEndState();
}

class _AlertTripEndState extends State<AlertTripEnd> {
  double calculateFraction(int time) {
    double result = 0.0;
    int hourComplite = (time / 60).toInt();
    int minuteComplite = (time % 60).toInt();
    print("$hourComplite hora completa");
    print("$minuteComplite minutos extra");

    if (minuteComplite < 30) {
      result = hourComplite.toDouble() + 0.5;
    }
    if (minuteComplite >= 30) {
      result = hourComplite.toDouble() + 1.0;
    }
    print("$result este es el resultado");
    return result;
  }

  double totalPricePerHour(DateTime arrivedDriver) {
    final diferencia = DateTime.now()
        .difference(arrivedDriver.subtract(Duration(minutes: 130)));
    calculateFraction(diferencia.inMinutes);
    if (diferencia.inMinutes <= 60) {
      return 1;
    } else {
      return (diferencia.inMinutes - 60) / 30;
    }
  }

  void patchEndTripDrive(BuildContext context, int tripId) async {
    try {
      if (widget.tripType == "POR HORA") {
        totalPricePerHour(widget.arrivedDriver!);

/*         await dio.patch('trips/driver-trip/$tripId', data: {
        "endTime": DateTime.now().toIso8601String(),
        "status": "COMPLETED",  */
      } else {
        await dio.patch('trips/driver-trip/$tripId', data: {
          "endTime": DateTime.now().toIso8601String(),
          "status": "COMPLETED"
        });
      }
      widget.reload();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("¿Deseas finalizar viaje y enviar datos?"),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Luego no podras volver a editar datos"),
        ],
      ),
      actions: <Widget>[
        Row(children: [
          Expanded(
            child: TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(5)),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xFF23A5CD)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                onPressed: () {
                  patchEndTripDrive(context, widget.tripId);
                  context.pop();
                },
                child: const Text(
                  "Confirmar",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: "Monserrat"),
                )),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  side: MaterialStateProperty.all(
                      const BorderSide(color: Color(0xFF23A5CD)))),
              onPressed: () => context.pop(),
              child: const Text(
                'Cerrar',
                style: TextStyle(color: Color(0xFF23A5CD)),
              ),
            ),
          ),
        ])
      ],
    );
  }
}

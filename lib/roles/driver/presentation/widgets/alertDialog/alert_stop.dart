import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/google_maps/google_maps_screen.dart';
import 'package:silverapp/google_maps/location_data.dart';

class AlertStops extends StatelessWidget {
  const AlertStops(this.addStops, {super.key});
  final Function(String, double, double) addStops;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.add_location_alt_outlined),
          Text("Agregar Parada"),
        ],
      ),
      content:
          const Text('Busque correctamente la parada en el mapa para agregar'),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                final result = await Navigator.of(context).push<LocationData>(
                  MaterialPageRoute(builder: (context) => const MapGoogle()),
                );
                if (result != null) {
                  addStops(result.address, result.latitude, result.longitude);
                }
                if (context.mounted) {
                  context.pop();
                }
              },
              child: const Text('Buscar parada'),
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
          ],
        ),
      ],
    );
  }
}

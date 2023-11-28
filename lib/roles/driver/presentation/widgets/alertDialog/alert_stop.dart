import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:silverapp/position/determine_position_helper.dart';

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
      content: const Text('Busque correctamente la parada en el mapa para agregar'),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                determinePosition().then((position) => {
                      showModalBottomSheet<String>(
                          context: context,
                          builder: (BuildContext context) {
                            return OpenStreetMapSearchAndPick(
                                locationPinText: '',
                                center: LatLong(
                                    position.latitude, position.longitude),
                                buttonColor: Colors.blue,
                                buttonText: 'Seleccionar parada',
                                onPicked: (pickedData) async {
                                  addStops(
                                      pickedData.addressName,
                                      pickedData.latLong.latitude,
                                      pickedData.latLong.longitude);
                                  context.pop();
                                  context.pop();
                                });
                          })
                    });
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
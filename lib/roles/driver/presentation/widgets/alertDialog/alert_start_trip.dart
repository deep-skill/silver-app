import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/roles/driver/presentation/providers/driver_info_provider.dart';
import 'package:silverapp/roles/driver/presentation/widgets/async_buttons/async_driver_trip_button.dart';

class AlertStartTrip extends StatelessWidget {
  const AlertStartTrip({
    super.key,
    required this.ref,
    required this.createTrip,
    required this.nav,
    required this.id,
    required this.price,
  });
  final Function createTrip;
  final Function nav;
  final WidgetRef ref;
  final int id;
  final double price;

  Future<bool?> createAndStartTrip() async {
    try {
      final tripId = await createTrip(id, price);
      ref.invalidate(driverInfoProvider);
      nav(tripId);
      return true;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('¿Listo para ir al punto de recojo?',
          textAlign: TextAlign.center),
      content: const Text(
        'Selecciona solo si vas en camino al punto de recojo',
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        Row(
          children: [
            Expanded(
              child: ButtonAsyncDriverTrip(
                onPressed: createAndStartTrip,
              ),
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
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Color(0xFF23A5CD)),
                ),
                onPressed: () {
                  context.pop();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

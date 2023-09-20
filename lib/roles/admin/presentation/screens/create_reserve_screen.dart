import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/roles/admin/entities/search_passenger.dart';
import 'package:silverapp/roles/admin/presentation/delegates/search_passenger_delegate.dart';
import 'package:silverapp/roles/admin/presentation/providers/search_passenger_provider.dart';

class CreateReserveScreen extends StatelessWidget {
  const CreateReserveScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(title: const Text('Crear reserva')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CreateReserveView(size: size),
        ));
  }
}

class CreateReserveView extends ConsumerWidget {
  const CreateReserveView({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xffF2F3F7),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      height: size.height,
      width: size.width,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Datos del servicio'),
        const Divider(),
        TextFormField(
          onTap: () {
            final searchedPassengers = ref.read(searchedPassengersProvider);
            final searchQuery = ref.read(searchPassengersProvider);

            showSearch<SearchPassenger?>(
                    query: searchQuery,
                    context: context,
                    delegate: SearchPassengerDelegate(
                        initialPassengers: searchedPassengers,
                        searchPassengers: ref
                            .read(searchedPassengersProvider.notifier)
                            .searchMoviesByQuery))
                .then((passenger) {
              if (passenger == null) return;

              print('${passenger.id} acaa');

              /* context.push('/home/0/movie/${passenger.id}'); */
            });
          },
          style: const TextStyle(fontSize: 15, color: Colors.black54),
          decoration: const InputDecoration(
            floatingLabelStyle: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
            isDense: true,
            label: Text('Nombre del pasajero'),
            hintText: 'Ejem. Carla Peña Ramirez',
          ),
        )
      ]),
    );
  }
}

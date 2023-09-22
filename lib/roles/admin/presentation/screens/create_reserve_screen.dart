import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/create_reserve.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/search_passenger.dart';
import 'package:silverapp/roles/admin/presentation/delegates/search_passenger_delegate.dart';
import 'package:silverapp/roles/admin/presentation/providers/forms/reserve_form_provider.dart';
import 'package:silverapp/roles/admin/presentation/providers/reserve_create_update_provider.dart';
import 'package:silverapp/roles/admin/presentation/providers/search_passenger_provider.dart';
import 'package:silverapp/roles/admin/presentation/widgets/custom_form_field.dart';
import 'package:silverapp/roles/admin/presentation/widgets/full_screen_loader.dart';

class CreateReserveScreen extends ConsumerWidget {
  final String reserveId;

  const CreateReserveScreen({super.key, required this.reserveId});

  void showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Reserva Creada')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reserveState = ref.watch(reserveCreateUpdateProvider(reserveId));
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Crear reserva')),
      body: reserveState.isLoading
          ? const FullScreenLoader()
          : CreateReserveView(size: size, reserve: reserveState.reserve!),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (reserveState.reserve == null) return;

          ref
              .read(reserveFormProvider(reserveState.reserve!).notifier)
              .onFormSubmit()
              .then((value) {
            if (!value) return;
            showSnackbar(context);
          });
        },
        child: const Icon(Icons.save_as_outlined),
      ),
    );
  }
}

class CreateReserveView extends ConsumerWidget {
  const CreateReserveView({
    super.key,
    required this.size,
    required this.reserve,
  });

  final Size size;
  final CreateReserve reserve;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reserveForm = ref.watch(reserveFormProvider(reserve));
    final cyanColor = const Color(0xff23a5cd);
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xffF2F3F7),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      height: size.height,
      width: size.width,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Datos del servicio', style: TextStyle(color: cyanColor)),
          Divider(color: cyanColor),
          GestureDetector(
            child: Stack(children: [
              CustomFormField(
                label: 'Nombre del pasajero',
                isTopField: true,
                isBottomField: true,
                errorMessage: reserveForm.userId.errorMessage,
              ),
              TextButton(
                child: Text(
                    '${reserveForm.userId.value.toString()} ${reserveForm.userName} ${reserveForm.userLastName}'),
                onPressed: () async {
                  final searchedPassengers =
                      ref.read(searchedPassengersProvider);
                  final searchQuery = ref.read(searchPassengersProvider);
                  final changeCallback = ref
                      .read(reserveFormProvider(reserve).notifier)
                      .onUserIdChanged;

                  showSearch<SearchPassenger?>(
                          query: searchQuery,
                          context: context,
                          delegate: SearchPassengerDelegate(
                              callback: changeCallback,
                              initialPassengers: searchedPassengers,
                              searchPassengers: ref
                                  .read(searchedPassengersProvider.notifier)
                                  .searchMoviesByQuery))
                      .then((passenger) {});
                },
              ),
            ]),
          ),
          CustomFormField(
            isTopField: true,
            label: 'Punto de recojo',
            initialValue: reserveForm.startAddress.value,
            onChanged: ref
                .read(reserveFormProvider(reserve).notifier)
                .onStartAddressChanged,
            errorMessage: reserveForm.startAddress.errorMessage,
          ),
        ]),
      ),
    );
  }
}

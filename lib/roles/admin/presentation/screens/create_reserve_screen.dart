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
    const cyanColor = Color(0xff23a5cd);
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
          const Text('Datos del servicio', style: TextStyle(color: cyanColor)),
          const Divider(color: cyanColor),
          const SizedBox(height: 10),
          Stack(children: [
            CustomFormField(
              readOnly: true,
              label: 'Nombre del pasajero*',
              isTopField: true,
              isBottomField: true,
              errorMessage: reserveForm.userId.errorMessage,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(Icons.person_outlined),
                  TextButton(
                    style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        shadowColor:
                            MaterialStateProperty.all(Colors.transparent)),
                    child: Text(
                        '${reserveForm.userName} ${reserveForm.userLastName}',
                        style: reserveForm.userName == 'Ejem. Carla'
                            ? const TextStyle(color: Colors.grey, fontSize: 16)
                            : const TextStyle(
                                color: Colors.black, fontSize: 16)),
                    onPressed: () {
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
                ],
              ),
            ),
          ]),
          const SizedBox(
            height: 10,
          ),
          Stack(children: [
            CustomFormField(
              label: 'Tipo de servicio*',
              isTopField: true,
              isBottomField: true,
              errorMessage: reserveForm.serviceType.errorMessage,
              readOnly: true,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(Icons.business_center_outlined),
                  const SizedBox(
                    width: 10,
                  ),
                  DropdownButton<String>(
                    value: reserveForm.serviceType.value,
                    style: reserveForm.serviceType.value ==
                            'Seleccione el tipo de servicio'
                        ? const TextStyle(color: Colors.grey, fontSize: 16)
                        : const TextStyle(color: Colors.black, fontSize: 16),
                    items: [
                      'Empresarial',
                      'Personal',
                      'Seleccione el tipo de servicio'
                    ]
                        .map((option) => DropdownMenuItem(
                              value: option,
                              child: Text(
                                option,
                                style:
                                    option == 'Seleccione el tipo de servicio'
                                        ? const TextStyle(
                                            color: Colors.grey, fontSize: 16)
                                        : const TextStyle(
                                            color: Colors.black, fontSize: 16),
                              ),
                            ))
                        .toList(),
                    onChanged: (newValue) {
                      ref
                          .read(reserveFormProvider(reserve).notifier)
                          .onServiceTypeChanged(newValue!);
                    },
                    icon: const Icon(Icons.keyboard_arrow_down),
                  ),
                ],
              ),
            ),
          ]),
          const SizedBox(
            height: 10,
          ),
          const Text('Datos del viaje', style: TextStyle(color: cyanColor)),
          const Divider(color: cyanColor),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: size.width * .45,
                child: Stack(children: [
                  CustomFormField(
                    isTopField: true,
                    isBottomField: true,
                    label: 'Fecha de viaje*',
                    readOnly: true,
                    errorMessage: reserveForm.startDate.errorMessage,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.today_outlined),
                        GestureDetector(
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100));
                            if (pickedDate != null) {
                              ref
                                  .read(reserveFormProvider(reserve).notifier)
                                  .onStartDateChanged(
                                      pickedDate.toString().substring(0, 10));
                            } else {}
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                '${reserveForm.startDate.value.substring(8, 10)}/${reserveForm.startDate.value.substring(5, 7)}/${reserveForm.startDate.value.substring(0, 4)}',
                                style: reserveForm.startDate.value ==
                                        '2023-09-26'
                                    ? const TextStyle(
                                        color: Colors.grey, fontSize: 16)
                                    : const TextStyle(
                                        color: Colors.black, fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
              SizedBox(
                width: size.width * .45,
                child: Stack(children: [
                  CustomFormField(
                    isTopField: true,
                    isBottomField: true,
                    label: 'Hora del viaje*',
                    readOnly: true,
                    errorMessage: reserveForm.startTime.errorMessage,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.alarm),
                        GestureDetector(
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime:
                                    const TimeOfDay(hour: 00, minute: 00));

                            if (pickedTime != null) {
                              ref
                                  .read(reserveFormProvider(reserve).notifier)
                                  .onStartTimeChanged(
                                      '${pickedTime.toString().substring(10, 12)}:${pickedTime.toString().substring(13, 15)}');
                            } else {}
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(reserveForm.startTime.value,
                                style: reserveForm.startTime.value == '00:00'
                                    ? const TextStyle(
                                        color: Colors.grey, fontSize: 16)
                                    : const TextStyle(
                                        color: Colors.black, fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Stack(children: [
            CustomFormField(
              label: 'Tipo de viaje*',
              isTopField: true,
              isBottomField: true,
              errorMessage: reserveForm.tripType.errorMessage,
              readOnly: true,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(Icons.timeline_outlined),
                  const SizedBox(
                    width: 10,
                  ),
                  DropdownButton<String>(
                    value: reserveForm.tripType.value,
                    style: reserveForm.tripType.value ==
                            'Seleccione el tipo de viaje'
                        ? const TextStyle(color: Colors.grey, fontSize: 16)
                        : const TextStyle(color: Colors.black, fontSize: 16),
                    items: [
                      'Por punto',
                      'Por hora',
                      'Punto a punto',
                      'Seleccione el tipo de viaje'
                    ]
                        .map((option) => DropdownMenuItem(
                              value: option,
                              child: Text(
                                option,
                                style: option == 'Seleccione el tipo de viaje'
                                    ? const TextStyle(
                                        color: Colors.grey, fontSize: 16)
                                    : const TextStyle(
                                        color: Colors.black, fontSize: 16),
                              ),
                            ))
                        .toList(),
                    onChanged: (newValue) {
                      ref
                          .read(reserveFormProvider(reserve).notifier)
                          .onTripTypeChanged(newValue!);
                    },
                    icon: const Icon(Icons.keyboard_arrow_down),
                  ),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 10),
          CustomFormField(
            isTopField: true,
            isBottomField: true,
            label: 'Punto de recojo',
            hint: 'Selecciona el tipo de servicio',
            initialValue: reserveForm.startAddress.value,
            onChanged: ref
                .read(reserveFormProvider(reserve).notifier)
                .onStartAddressChanged,
            errorMessage: reserveForm.startAddress.errorMessage,
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(),
        ]),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:silverapp/position/determine_position_helper.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/create_reserve.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/search_car.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/search_driver.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/search_passenger.dart';
import 'package:silverapp/roles/admin/presentation/delegates/search_car_delegate.dart';
import 'package:silverapp/roles/admin/presentation/delegates/search_driver_delegate.dart';
import 'package:silverapp/roles/admin/presentation/delegates/search_passenger_delegate.dart';
import 'package:silverapp/roles/admin/presentation/providers/forms/reserve_form_provider.dart';
import 'package:silverapp/roles/admin/presentation/providers/reserve_create_update_provider.dart';
import 'package:silverapp/roles/admin/presentation/providers/search_car_provider.dart';
import 'package:silverapp/roles/admin/presentation/providers/search_driver_provider.dart';
import 'package:silverapp/roles/admin/presentation/providers/search_passenger_provider.dart';
import 'package:silverapp/roles/admin/presentation/widgets/custom_form_field.dart';
import 'package:silverapp/roles/admin/presentation/widgets/full_screen_loader.dart';

class CreateReserveScreen extends ConsumerWidget {
  final String reserveId;

  const CreateReserveScreen({super.key, required this.reserveId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reserveState = ref.watch(reserveCreateUpdateProvider(reserveId));
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Crear reserva')),
      body: reserveState.isLoading
          ? const FullScreenLoader()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  CreateReserveView(size: size, reserve: reserveState.reserve!),
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

  void showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Reserva Creada')));
  }

  final Size size;
  final CreateReserve reserve;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reserveForm = ref.watch(reserveFormProvider(reserve));
    const cyanColor = Color(0xff23a5cd);
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xffF2F3F7),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Datos del servicio',
                style: TextStyle(color: cyanColor)),
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
                              ? const TextStyle(
                                  color: Colors.grey, fontSize: 16)
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
                                        .read(
                                            searchedPassengersProvider.notifier)
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
                child: SizedBox(
                  width: size.width * .9,
                  child: Row(
                    children: [
                      const Icon(Icons.business_center_outlined),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: size.width * .75,
                        child: DropdownButton<String>(
                          isExpanded: true,
                          iconSize: 40,
                          value: reserveForm.serviceType.value,
                          style: reserveForm.serviceType.value ==
                                  'Seleccione el tipo de servicio'
                              ? const TextStyle(
                                  color: Colors.grey, fontSize: 16)
                              : const TextStyle(
                                  color: Colors.black, fontSize: 16),
                          items: [
                            'Empresarial',
                            'Personal',
                            'Seleccione el tipo de servicio'
                          ]
                              .map((option) => DropdownMenuItem(
                                    value: option,
                                    child: Text(
                                      option,
                                      style: option ==
                                              'Seleccione el tipo de servicio'
                                          ? const TextStyle(
                                              color: Colors.grey, fontSize: 16)
                                          : const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
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
                      ),
                    ],
                  ),
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
                child: SizedBox(
                  width: size.width * .9,
                  child: Row(
                    children: [
                      const Icon(Icons.timeline_outlined),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: size.width * .75,
                        child: DropdownButton<String>(
                          iconSize: 40,
                          isExpanded: true,
                          value: reserveForm.tripType.value,
                          style: reserveForm.tripType.value ==
                                  'Seleccione el tipo de viaje'
                              ? const TextStyle(
                                  color: Colors.grey, fontSize: 16)
                              : const TextStyle(
                                  color: Colors.black, fontSize: 16),
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
                                      style: option ==
                                              'Seleccione el tipo de viaje'
                                          ? const TextStyle(
                                              color: Colors.grey, fontSize: 16)
                                          : const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
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
                      ),
                    ],
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 10),
            Stack(
              children: [
                CustomFormField(
                  readOnly: true,
                  isTopField: true,
                  isBottomField: true,
                  label: 'Punto de recojo*',
                  errorMessage: reserveForm.startAddress.errorMessage,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_outlined),
                      TextButton(
                        style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          shadowColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        child: SizedBox(
                          width: size.width * .7,
                          child: Text(reserveForm.startAddress.value,
                              overflow: TextOverflow.ellipsis,
                              style: reserveForm.startAddress.value ==
                                      'Seleccione el punto de recojo'
                                  ? const TextStyle(
                                      color: Colors.grey, fontSize: 16)
                                  : const TextStyle(
                                      color: Colors.black, fontSize: 16)),
                        ),
                        onPressed: () async {
                          determinePosition().then((position) => {
                                showModalBottomSheet<String>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return OpenStreetMapSearchAndPick(
                                          locationPinText: '',
                                          center: LatLong(position.latitude,
                                              position.longitude),
                                          buttonColor: Colors.blue,
                                          buttonText:
                                              'Seleccionar punto de recojo',
                                          onPicked: (pickedData) async {
                                            ref
                                                .read(
                                                    reserveFormProvider(reserve)
                                                        .notifier)
                                                .onStartAddressChanged(
                                                    '${pickedData.addressName}, Lat: ${pickedData.latLong.latitude}, Long: ${pickedData.latLong.longitude}');
                                            context.pop();
                                          });
                                    })
                              });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            if (reserveForm.tripType.value == 'Punto a punto')
              Stack(
                children: [
                  CustomFormField(
                    readOnly: true,
                    isTopField: true,
                    isBottomField: true,
                    label: 'Punto de destino*',
                    errorMessage: reserveForm.endAddress!.errorMessage,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.trip_origin_outlined),
                        TextButton(
                          style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                            shadowColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                          child: SizedBox(
                            width: size.width * .7,
                            child: Text(reserveForm.endAddress!.value,
                                overflow: TextOverflow.ellipsis,
                                style: reserveForm.endAddress!.value ==
                                        'Seleccione el punto de destino'
                                    ? const TextStyle(
                                        color: Colors.grey, fontSize: 16)
                                    : const TextStyle(
                                        color: Colors.black, fontSize: 16)),
                          ),
                          onPressed: () async {
                            determinePosition().then((position) => {
                                  showModalBottomSheet<String>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return OpenStreetMapSearchAndPick(
                                            locationPinText: '',
                                            center: LatLong(position.latitude,
                                                position.longitude),
                                            buttonColor: Colors.blue,
                                            buttonText:
                                                'Seleccionar punto de recojo',
                                            onPicked: (pickedData) async {
                                              ref
                                                  .read(reserveFormProvider(
                                                          reserve)
                                                      .notifier)
                                                  .onEndAddressChanged(
                                                      '${pickedData.addressName}, Lat: ${pickedData.latLong.latitude}, Long: ${pickedData.latLong.longitude}');
                                              context.pop();
                                            });
                                      })
                                });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            const Text('Datos del conductor y vehículo',
                style: TextStyle(color: cyanColor)),
            const Divider(color: cyanColor),
            const SizedBox(height: 10),
            Stack(children: [
              const CustomFormField(
                readOnly: true,
                label: 'Nombre del conductor',
                isTopField: true,
                isBottomField: true,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(Icons.car_rental),
                    TextButton(
                      style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          shadowColor:
                              MaterialStateProperty.all(Colors.transparent)),
                      child: Text(
                          '${reserveForm.driverName} ${reserveForm.driverLastName}',
                          style: reserveForm.driverName == 'Ejem. Luis'
                              ? const TextStyle(
                                  color: Colors.grey, fontSize: 16)
                              : const TextStyle(
                                  color: Colors.black, fontSize: 16)),
                      onPressed: () {
                        final searchedDrivers =
                            ref.read(searchedDriversProvider);
                        final searchQuery = ref.read(searchDriversProvider);
                        final changeCallback = ref
                            .read(reserveFormProvider(reserve).notifier)
                            .onDriverIdChanged;
                        showSearch<SearchDriver?>(
                                query: searchQuery,
                                context: context,
                                delegate: SearchDriverDelegate(
                                    callback: changeCallback,
                                    initialDrivers: searchedDrivers,
                                    searchDrivers: ref
                                        .read(searchedDriversProvider.notifier)
                                        .searchDriversByQuery))
                            .then((driver) {});
                      },
                    ),
                  ],
                ),
              ),
            ]),
            const SizedBox(height: 10),
            Stack(children: [
              const CustomFormField(
                readOnly: true,
                label: 'Vehículo (Marca, Modelo, Color, Placa)',
                isTopField: true,
                isBottomField: true,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(Icons.local_taxi_outlined),
                    TextButton(
                      style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          shadowColor:
                              MaterialStateProperty.all(Colors.transparent)),
                      child: Text(
                          '${reserveForm.brand}, ${reserveForm.model}, ${reserveForm.color}, ${reserveForm.licensePlate}',
                          style: reserveForm.brand == 'Ejem. Toyota'
                              ? const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.grey,
                                  fontSize: 16)
                              : const TextStyle(
                                  color: Colors.black, fontSize: 16)),
                      onPressed: () {
                        final searchedCars = ref.read(searchedCarsProvider);
                        final searchQuery = ref.read(searchCarsProvider);
                        final changeCallback = ref
                            .read(reserveFormProvider(reserve).notifier)
                            .onCarIdChanged;

                        showSearch<SearchCar?>(
                                query: searchQuery,
                                context: context,
                                delegate: SearchCarDelegate(
                                    callback: changeCallback,
                                    initialCars: searchedCars,
                                    searchCars: ref
                                        .read(searchedCarsProvider.notifier)
                                        .searchCarsByQuery))
                            .then((driver) {});
                      },
                    ),
                  ],
                ),
              ),
            ]),
            const Text('Tarifa', style: TextStyle(color: cyanColor)),
            const Divider(color: cyanColor),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: size.width * .45,
                  child: Stack(children: [
                    CustomFormField(
                      initialValue: reserveForm.price.value,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      isTopField: true,
                      isBottomField: true,
                      label: reserveForm.tripType.value == 'Por hora'
                          ? 'Tarifa base x hora'
                          : 'Tarifa base',
                      hint: 'S/ 00.00',
                      errorMessage: reserveForm.price.errorMessage,
                      prefixIcon:
                          const Icon(Icons.monetization_on_outlined, size: 25),
                      onChanged: ref
                          .read(reserveFormProvider(reserve).notifier)
                          .onPriceChanged,
                    ),
                  ]),
                ),
                SizedBox(
                  width: size.width * .45,
                  child: CustomFormField(
                    initialValue: reserveForm.silverPercent.value == 0
                        ? ''
                        : reserveForm.silverPercent.value,
                    keyboardType: const TextInputType.numberWithOptions(),
                    isTopField: true,
                    isBottomField: true,
                    label: '% Silver',
                    hint: '20%',
                    errorMessage: reserveForm.silverPercent.errorMessage,
                    prefixIcon: const Icon(Icons.percent, size: 25),
                    onChanged: ref
                        .read(reserveFormProvider(reserve).notifier)
                        .onSilverPercentChanged,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: TextButton(
                onPressed: () {
                  print('on pressed crear ${reserve.toString()}');
                  ref
                      .read(reserveFormProvider(reserve).notifier)
                      .onFormSubmit()
                      .then((value) {
                    if (!value) return;
                    showSnackbar(context);
                    context.pop();
                  });
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
                  fixedSize: MaterialStateProperty.all(
                      Size(size.width * .8, size.height * .07)),
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFF23A5CD)),
                ),
                child: const Text('Crear',
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

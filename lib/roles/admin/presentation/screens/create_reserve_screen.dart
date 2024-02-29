import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/google_maps/google_maps_screen.dart';
import 'package:silverapp/google_maps/google_post_routes.dart';
import 'package:silverapp/google_maps/location_data.dart';
import 'package:silverapp/providers/auth0_provider.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/create_reserve.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/search_car.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/search_driver.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/search_passenger.dart';
import 'package:silverapp/roles/admin/presentation/delegates/search_car_delegate.dart';
import 'package:silverapp/roles/admin/presentation/delegates/search_driver_delegate.dart';
import 'package:silverapp/roles/admin/presentation/delegates/search_passenger_delegate.dart';
import 'package:silverapp/roles/admin/presentation/providers/forms/reserve_form_provider.dart';
import 'package:silverapp/roles/admin/presentation/providers/reserve_create_update_provider.dart';
import 'package:silverapp/roles/admin/presentation/providers/reserve_detail_provider.dart';
import 'package:silverapp/roles/admin/presentation/providers/reserve_list_home_provider.dart';
import 'package:silverapp/roles/admin/presentation/providers/reserve_list_provider.dart';
import 'package:silverapp/roles/admin/presentation/providers/search_car_provider.dart';
import 'package:silverapp/roles/admin/presentation/providers/search_driver_provider.dart';
import 'package:silverapp/roles/admin/presentation/providers/search_passenger_provider.dart';
import 'package:silverapp/roles/admin/presentation/providers/trip_detail_provider.dart';
import 'package:silverapp/roles/admin/presentation/widgets/custom_form_field.dart';
import 'package:silverapp/roles/admin/presentation/widgets/full_screen_loader.dart';

class CreateReserveScreen extends ConsumerWidget {
  final String reserveId;
  final DateTime screenLoadTime = DateTime.now();
  CreateReserveScreen({super.key, required this.reserveId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reserveState = ref.watch(reserveCreateUpdateProvider(reserveId));
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xffF2F3F7),
          centerTitle: true,
          title: Text(reserveId == 'new' ? "Crear Reserva" : "Editar Reserva")),
      body: reserveState.isLoading
          ? const FullScreenLoader()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: CreateReserveView(
                  size: size,
                  reserve: reserveState.reserve!,
                  screenLoadTime: screenLoadTime),
            ),
      backgroundColor: const Color(0xffF2F3F7),
    );
  }
}

String getDifferenceBetweenTimes(DateTime screenLoad, DateTime reserveCreated) {
  Duration difference = reserveCreated.difference(screenLoad);
  int minutes = difference.inMinutes;
  int seconds = difference.inSeconds % 60;
  String formattedMinutes = minutes.toString().padLeft(2, '0');
  String formattedSeconds = seconds.toString().padLeft(2, '0');
  return '$formattedMinutes:$formattedSeconds';
}

class CreateReserveView extends ConsumerWidget {
  const CreateReserveView(
      {super.key,
      required this.size,
      required this.reserve,
      required this.screenLoadTime});

  void showSnackbar(BuildContext context, int method) {
    final String snackBarText =
        method == 0 ? "Reserva Creada" : "Reserva Editada";
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(snackBarText)));
  }

  final Size size;
  final CreateReserve reserve;
  final DateTime screenLoadTime;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reserveForm = ref.watch(reserveFormProvider(reserve));
    const cyanColor = Color(0xff23a5cd);
    //analytics
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    analytics.setAnalyticsCollectionEnabled(true);

    Credentials? credentials = ref.watch(authProvider).credentials;
    final String? adminEmail = credentials?.user.email;
    void sendEventCreatedReserve(
        {String? adminEmail,
        required String amountMinutesCreating,
        required int driverId,
        required int userId,
        required String serviceType,
        required String tripType,
        required String reservePrice,
        required String silverPercent}) {
      analytics.logEvent(
        name: 'admin_create_reserve',
        parameters: <String, dynamic>{
          'admin_email': adminEmail,
          'amount_minutes_creating': amountMinutesCreating,
          'driver_id': driverId,
          'user_id': userId,
          'service_type': serviceType,
          'trip_type': tripType,
          'reserve_price': reservePrice,
          'silver_percent': silverPercent == '' ? 20 : silverPercent
        },
      );
    }

    return kIsWeb
        ? Center(
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                width: size.width * 0.75,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Datos del servicio',
                            style: TextStyle(color: cyanColor)),
                        const Divider(color: cyanColor),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: size.width * 0.34,
                              child: Stack(children: [
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
                                      Expanded(
                                        child: TextButton(
                                          style: ButtonStyle(
                                              overlayColor:
                                                  MaterialStateProperty.all(
                                                      Colors.transparent),
                                              shadowColor:
                                                  MaterialStateProperty.all(
                                                      Colors.transparent)),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                '${reserveForm.userName} ${reserveForm.userLastName}',
                                                style: reserveForm.userName ==
                                                        'Ejem. Carla'
                                                    ? const TextStyle(
                                                        color:
                                                            Color(0xffB5B9C2),
                                                        fontSize: 16,
                                                        fontFamily:
                                                            'Montserrat-Regular')
                                                    : const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16)),
                                          ),
                                          onPressed: () {
                                            final searchedPassengers = ref.read(
                                                searchedPassengersProvider);
                                            final searchQuery = ref
                                                .read(searchPassengersProvider);
                                            final changeCallback = ref
                                                .read(
                                                    reserveFormProvider(reserve)
                                                        .notifier)
                                                .onUserIdChanged;

                                            showSearch<SearchPassenger?>(
                                                    query: searchQuery,
                                                    context: context,
                                                    delegate: SearchPassengerDelegate(
                                                        callback:
                                                            changeCallback,
                                                        initialPassengers:
                                                            searchedPassengers,
                                                        searchPassengers: ref
                                                            .read(
                                                                searchedPassengersProvider
                                                                    .notifier)
                                                            .searchMoviesByQuery))
                                                .then((passenger) {});
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            SizedBox(
                              width: size.width * 0.36,
                              child: Stack(children: [
                                CustomFormField(
                                  label: 'Tipo de servicio*',
                                  isTopField: true,
                                  isBottomField: true,
                                  errorMessage:
                                      reserveForm.serviceType.errorMessage,
                                  readOnly: true,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(
                                          Icons.business_center_outlined),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          iconSize: 40,
                                          value: reserveForm.serviceType.value,
                                          style: reserveForm
                                                      .serviceType.value ==
                                                  'Seleccione el tipo de servicio'
                                              ? const TextStyle(
                                                  color: Color(0xffB5B9C2),
                                                  fontSize: 16,
                                                  fontFamily:
                                                      'Montserrat-Regular')
                                              : const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16),
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
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 16)
                                                          : const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16),
                                                    ),
                                                  ))
                                              .toList(),
                                          onChanged: (newValue) {
                                            ref
                                                .read(
                                                    reserveFormProvider(reserve)
                                                        .notifier)
                                                .onServiceTypeChanged(
                                                    newValue!);
                                          },
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                              width: size.width * 0.36,
                              child: Stack(children: [
                                CustomFormField(
                                  label: 'Tipo de vehículo',
                                  isTopField: true,
                                  isBottomField: true,
                                  errorMessage:
                                      reserveForm.serviceCarType.errorMessage,
                                  readOnly: true,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(
                                          Icons.business_center_outlined),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          iconSize: 40,
                                          value: reserveForm.serviceCarType.value,
                                          style: reserveForm
                                                      .serviceCarType.value ==
                                                  'Seleccione el tipo de vehículo'
                                              ? const TextStyle(
                                                  color: Color(0xffB5B9C2),
                                                  fontSize: 16,
                                                  fontFamily:
                                                      'Montserrat-Regular')
                                              : const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16),
                                          items: [
                                            'Auto',
                                            'Camioneta',
                                            'Van',
                                            'Seleccione el tipo de vehículo'
                                          ]
                                              .map((option) => DropdownMenuItem(
                                                    value: option,
                                                    child: Text(
                                                      option,
                                                      style: option ==
                                                              'Seleccione el tipo de vehículo'
                                                          ? const TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 16)
                                                          : const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16),
                                                    ),
                                                  ))
                                              .toList(),
                                          onChanged: (newValue) {
                                            ref
                                                .read(
                                                    reserveFormProvider(reserve)
                                                        .notifier)
                                                .onServiceCarTypeChanged(
                                                    newValue!);
                                          },
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                            const SizedBox(
                          height: 20,
                        ),
                        const Text('Datos del viaje',
                            style: TextStyle(color: cyanColor)),
                        const Divider(color: cyanColor),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: size.width * .17,
                              child: Stack(children: [
                                CustomFormField(
                                  isTopField: true,
                                  isBottomField: true,
                                  label: 'Fecha de viaje*',
                                  readOnly: true,
                                  errorMessage:
                                      reserveForm.startDate.errorMessage,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.today_outlined),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () async {
                                            DateTime? pickedDate =
                                                await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime.now(),
                                                    lastDate: DateTime(2100));
                                            if (pickedDate != null) {
                                              ref
                                                  .read(reserveFormProvider(
                                                          reserve)
                                                      .notifier)
                                                  .onStartDateChanged(pickedDate
                                                      .toString()
                                                      .substring(0, 10));
                                            } else {}
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                '${reserveForm.startDate.value.substring(8, 10)}/${reserveForm.startDate.value.substring(5, 7)}/${reserveForm.startDate.value.substring(0, 4)}',
                                                style: reserveForm
                                                            .startDate.value ==
                                                        '2023-09-26'
                                                    ? const TextStyle(
                                                        color:
                                                            Color(0xffB5B9C2),
                                                        fontSize: 16,
                                                        fontFamily:
                                                            'Montserrat-Regular')
                                                    : const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                            SizedBox(
                              width: size.width * .16,
                              child: Stack(children: [
                                CustomFormField(
                                  isTopField: true,
                                  isBottomField: true,
                                  label: 'Hora del viaje*',
                                  readOnly: true,
                                  errorMessage:
                                      reserveForm.startTime.errorMessage,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.alarm),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () async {
                                            TimeOfDay? pickedTime =
                                                await showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        const TimeOfDay(
                                                            hour: 00,
                                                            minute: 00));

                                            if (pickedTime != null) {
                                              ref
                                                  .read(reserveFormProvider(
                                                          reserve)
                                                      .notifier)
                                                  .onStartTimeChanged(
                                                      '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}');
                                            } else {}
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                reserveForm.startTime.value,
                                                style: reserveForm
                                                            .startTime.value ==
                                                        '00:00'
                                                    ? const TextStyle(
                                                        color:
                                                            Color(0xffB5B9C2),
                                                        fontSize: 16,
                                                        fontFamily:
                                                            'Montserrat-Regular')
                                                    : const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                            const SizedBox(width: 20),
                            SizedBox(
                              width: size.width * 0.36,
                              child: Stack(children: [
                                CustomFormField(
                                  label: 'Tipo de viaje*',
                                  isTopField: true,
                                  isBottomField: true,
                                  errorMessage:
                                      reserveForm.tripType.errorMessage,
                                  readOnly: true,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.timeline_outlined),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: DropdownButton<String>(
                                          iconSize: 40,
                                          isExpanded: true,
                                          value: reserveForm.tripType.value,
                                          style: reserveForm.tripType.value ==
                                                  'Seleccione el tipo de viaje'
                                              ? const TextStyle(
                                                  color: Color(0xffB5B9C2),
                                                  fontSize: 16,
                                                  fontFamily:
                                                      'Montserrat-Regular')
                                              : const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16),
                                          items: [
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
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 16)
                                                          : const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16),
                                                    ),
                                                  ))
                                              .toList(),
                                          onChanged: (newValue) {
                                            ref
                                                .read(
                                                    reserveFormProvider(reserve)
                                                        .notifier)
                                                .onTripTypeChanged(newValue!);
                                          },
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: size.width * 0.8,
                          child: Stack(
                            children: [
                              CustomFormField(
                                readOnly: true,
                                isTopField: true,
                                isBottomField: true,
                                label: 'Punto de recojo*',
                                errorMessage:
                                    reserveForm.startAddress.errorMessage,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.location_on_outlined),
                                    Expanded(
                                      child: TextButton(
                                        style: ButtonStyle(
                                          overlayColor:
                                              MaterialStateProperty.all(
                                                  Colors.transparent),
                                          shadowColor:
                                              MaterialStateProperty.all(
                                                  Colors.transparent),
                                        ),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                              reserveForm.startAddress.value,
                                              overflow: TextOverflow.ellipsis,
                                              style: reserveForm
                                                          .startAddress.value ==
                                                      'Seleccione el punto de recojo'
                                                  ? const TextStyle(
                                                      color: Color(0xffB5B9C2),
                                                      fontSize: 16,
                                                      fontFamily:
                                                          'Montserrat-Regular')
                                                  : const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16)),
                                        ),
                                        onPressed: () async {
                                          final result =
                                              await Navigator.of(context)
                                                  .push<LocationData>(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const MapGoogle()),
                                          );
                                          if (result != null) {
                                            ref
                                                .read(
                                                    reserveFormProvider(reserve)
                                                        .notifier)
                                                .onStartAddressChanged(
                                                    result.address,
                                                    result.latitude,
                                                    result.longitude);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 17,
                        ),
                        if (reserveForm.tripType.value == 'Punto a punto')
                          SizedBox(
                            width: size.width * 0.8,
                            child: Stack(
                              children: [
                                CustomFormField(
                                  readOnly: true,
                                  isTopField: true,
                                  isBottomField: true,
                                  label: 'Punto de destino*',
                                  errorMessage:
                                      reserveForm.endAddress!.errorMessage,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.trip_origin_outlined),
                                      Expanded(
                                        child: TextButton(
                                          style: ButtonStyle(
                                            overlayColor:
                                                MaterialStateProperty.all(
                                                    Colors.transparent),
                                            shadowColor:
                                                MaterialStateProperty.all(
                                                    Colors.transparent),
                                          ),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                reserveForm.endAddress!.value,
                                                overflow: TextOverflow.ellipsis,
                                                style: reserveForm.endAddress!
                                                            .value ==
                                                        'Seleccione el punto de destino'
                                                    ? const TextStyle(
                                                        color:
                                                            Color(0xffB5B9C2),
                                                        fontSize: 16,
                                                        fontFamily:
                                                            'Montserrat-Regular')
                                                    : const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16)),
                                          ),
                                          onPressed: () async {
                                            final result =
                                                await Navigator.of(context)
                                                    .push<LocationData>(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const MapGoogle()),
                                            );
                                            if (result != null) {
                                              ref
                                                  .read(reserveFormProvider(
                                                          reserve)
                                                      .notifier)
                                                  .onEndAddressChanged(
                                                      result.address,
                                                      result.latitude,
                                                      result.longitude);
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              print(reserveForm.startAddressLat);
                              print(reserveForm.startAddressLon);

                              var distance = await getGoogleRoute(
                                reserveForm.startAddressLat,
                                reserveForm.startAddressLon,
                                reserveForm.endAddressLat,
                                reserveForm.endAddressLon,
                              );

                              print(
                                  distance.routes[0].distanceMeters.toString());
                              print(distance.routes[0].distanceMeters / 1000);
                              print(distance.routes[0].duration.toString());
                              print(distance.routes[0].duration);
                            } catch (e) {
                              print("Error al calcular la ruta: $e");
                            }
                          },
                          child: const Text("Calcular Ruta"),
                        ),
                        const SizedBox(height: 16),
                        const SizedBox(height: 16),
                        const Text('Datos del conductor y vehículo',
                            style: TextStyle(color: cyanColor)),
                        const Divider(color: cyanColor),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: size.width * 0.34,
                              child: Stack(children: [
                                const CustomFormField(
                                  readOnly: true,
                                  label: 'Nombre del conductor',
                                  isTopField: true,
                                  isBottomField: true,
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Icon(Icons.car_rental),
                                          SizedBox(
                                            width: size.width * .3,
                                            child: TextButton(
                                              style: ButtonStyle(
                                                  overlayColor:
                                                      MaterialStateProperty.all(
                                                          Colors.transparent),
                                                  shadowColor:
                                                      MaterialStateProperty.all(
                                                          Colors.transparent)),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    '${reserveForm.driverName} ${reserveForm.driverLastName}',
                                                    style: reserveForm
                                                                .driverName ==
                                                            'Ejem. Luis'
                                                        ? const TextStyle(
                                                            color: Color(
                                                                0xffB5B9C2),
                                                            fontSize: 16,
                                                            fontFamily:
                                                                'Montserrat-Regular')
                                                        : const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16)),
                                              ),
                                              onPressed: () {
                                                final searchedDrivers = ref.read(
                                                    searchedDriversProvider);
                                                final searchQuery = ref.read(
                                                    searchDriversProvider);
                                                final changeCallback = ref
                                                    .read(reserveFormProvider(
                                                            reserve)
                                                        .notifier)
                                                    .onDriverIdChanged;
                                                showSearch<SearchDriver?>(
                                                        query: searchQuery,
                                                        context: context,
                                                        delegate: SearchDriverDelegate(
                                                            callback:
                                                                changeCallback,
                                                            initialDrivers:
                                                                searchedDrivers,
                                                            searchDrivers: ref
                                                                .read(searchedDriversProvider
                                                                    .notifier)
                                                                .searchDriversByQuery))
                                                    .then((driver) {});
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                            ),
                            SizedBox(
                              width: size.width * 0.36,
                              child: Stack(children: [
                                const CustomFormField(
                                  readOnly: true,
                                  label:
                                      'Vehículo (Marca, Modelo, Color, Placa)',
                                  isTopField: true,
                                  isBottomField: true,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.local_taxi_outlined),
                                      Expanded(
                                        child: TextButton(
                                          style: ButtonStyle(
                                              overlayColor:
                                                  MaterialStateProperty.all(
                                                      Colors.transparent),
                                              shadowColor:
                                                  MaterialStateProperty.all(
                                                      Colors.transparent)),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                '${reserveForm.brand}, ${reserveForm.model}, ${reserveForm.color}, ${reserveForm.licensePlate}',
                                                style: reserveForm.brand ==
                                                        'Ejem. Toyota'
                                                    ? const TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        color:
                                                            Color(0xffB5B9C2),
                                                        fontSize: 16,
                                                        fontFamily:
                                                            'Montserrat-Regular')
                                                    : const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16)),
                                          ),
                                          onPressed: () {
                                            final searchedCars =
                                                ref.read(searchedCarsProvider);
                                            final searchQuery =
                                                ref.read(searchCarsProvider);
                                            final changeCallback = ref
                                                .read(
                                                    reserveFormProvider(reserve)
                                                        .notifier)
                                                .onCarIdChanged;

                                            showSearch<SearchCar?>(
                                                    query: searchQuery,
                                                    context: context,
                                                    delegate: SearchCarDelegate(
                                                        callback:
                                                            changeCallback,
                                                        initialCars:
                                                            searchedCars,
                                                        searchCars: ref
                                                            .read(
                                                                searchedCarsProvider
                                                                    .notifier)
                                                            .searchCarsByQuery))
                                                .then((driver) {});
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        const Text('Tarifa',
                            style: TextStyle(color: cyanColor)),
                        const Divider(color: cyanColor),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            SizedBox(
                              width: size.width * .17,
                              child: Stack(children: [
                                CustomFormField(
                                  initialValue: reserveForm.price.value,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  isTopField: true,
                                  isBottomField: true,
                                  label:
                                      reserveForm.tripType.value == 'Por hora'
                                          ? 'Tarifa base x hora*'
                                          : 'Tarifa base*',
                                  hint: 'S/ 00.00',
                                  errorMessage: reserveForm.price.errorMessage,
                                  prefixIcon: const Icon(
                                      Icons.monetization_on_outlined,
                                      size: 25),
                                  onChanged: ref
                                      .read(
                                          reserveFormProvider(reserve).notifier)
                                      .onPriceChanged,
                                ),
                              ]),
                            ),
                            const SizedBox(width: 18),
                            SizedBox(
                              width: size.width * .16,
                              child: CustomFormField(
                                initialValue:
                                    reserveForm.silverPercent.value == '0'
                                        ? ''
                                        : reserveForm.silverPercent.value,
                                keyboardType:
                                    const TextInputType.numberWithOptions(),
                                isTopField: true,
                                isBottomField: true,
                                label: '% Silver',
                                hint: '20%',
                                errorMessage:
                                    reserveForm.silverPercent.errorMessage,
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
                            onPressed: () async {
                              ref
                                  .read(reserveFormProvider(reserve).notifier)
                                  .onFormSubmit(reserve.id!, reserve.tripId)
                                  .then((value) {
                                if (!value) return;
                                if (reserve.id! != 0) {
                                  ref
                                      .read(reserveDetailProvider.notifier)
                                      .updateReserveDetail(
                                          reserve.id!.toString());
                                  if (reserve.tripId != null) {
                                    ref
                                        .read(tripAdminStatusProvider.notifier)
                                        .updateTripStatus(
                                            reserve.tripId!.toString());
                                  }
                                } else {
                                  final String time = getDifferenceBetweenTimes(
                                      screenLoadTime, DateTime.now());
                                  sendEventCreatedReserve(
                                      adminEmail: adminEmail,
                                      amountMinutesCreating: time,
                                      driverId:
                                          reserveForm.driverId?.value ?? 0,
                                      serviceType:
                                          reserveForm.serviceType.value,
                                      tripType: reserveForm.tripType.value,
                                      userId: reserveForm.userId.value,
                                      reservePrice: reserveForm.price.value,
                                      silverPercent:
                                          reserveForm.silverPercent.value == ''
                                              ? '20'
                                              : reserveForm
                                                  .silverPercent.value);
                                }
                                showSnackbar(context, reserve.id!);

                                ref
                                    .read(reservesHomeProvider.notifier)
                                    .reloadData();
                                ref
                                    .read(reservesListProvider.notifier)
                                    .reloadData();

                                context.pop();
                              });
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              )),
                              fixedSize: MaterialStateProperty.all(
                                  Size(size.width * .20, size.height * .05)),
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xFF03132A)),
                            ),
                            child: Text(
                                reserve.id == 0 ? "Crear" : "Guardar cambios",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Raleway-Semi-Bold',
                                    fontSize: 16)),
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          )
        : SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              width: size.width,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                              Expanded(
                                child: TextButton(
                                  style: ButtonStyle(
                                      overlayColor: MaterialStateProperty.all(
                                          Colors.transparent),
                                      shadowColor: MaterialStateProperty.all(
                                          Colors.transparent)),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        '${reserveForm.userName} ${reserveForm.userLastName}',
                                        style: reserveForm.userName ==
                                                'Ejem. Carla'
                                            ? const TextStyle(
                                                color: Color(0xffB5B9C2),
                                                fontSize: 16,
                                                fontFamily:
                                                    'Montserrat-Regular')
                                            : const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16)),
                                  ),
                                  onPressed: () {
                                    final searchedPassengers =
                                        ref.read(searchedPassengersProvider);
                                    final searchQuery =
                                        ref.read(searchPassengersProvider);
                                    final changeCallback = ref
                                        .read(reserveFormProvider(reserve)
                                            .notifier)
                                        .onUserIdChanged;

                                    showSearch<SearchPassenger?>(
                                            query: searchQuery,
                                            context: context,
                                            delegate: SearchPassengerDelegate(
                                                callback: changeCallback,
                                                initialPassengers:
                                                    searchedPassengers,
                                                searchPassengers: ref
                                                    .read(
                                                        searchedPassengersProvider
                                                            .notifier)
                                                    .searchMoviesByQuery))
                                        .then((passenger) {});
                                  },
                                ),
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
                                Expanded(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    iconSize: 40,
                                    value: reserveForm.serviceType.value,
                                    style: reserveForm.serviceType.value ==
                                            'Seleccione el tipo de servicio'
                                        ? const TextStyle(
                                            color: Color(0xffB5B9C2),
                                            fontSize: 16,
                                            fontFamily: 'Montserrat-Regular')
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
                                                        color: Colors.grey,
                                                        fontSize: 16)
                                                    : const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16),
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: (newValue) {
                                      ref
                                          .read(reserveFormProvider(reserve)
                                              .notifier)
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
                      const Text('Datos del viaje',
                          style: TextStyle(color: cyanColor)),
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
                                errorMessage:
                                    reserveForm.startDate.errorMessage,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.today_outlined),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () async {
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime(2100));
                                          if (pickedDate != null) {
                                            ref
                                                .read(
                                                    reserveFormProvider(reserve)
                                                        .notifier)
                                                .onStartDateChanged(pickedDate
                                                    .toString()
                                                    .substring(0, 10));
                                          } else {}
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              '${reserveForm.startDate.value.substring(8, 10)}/${reserveForm.startDate.value.substring(5, 7)}/${reserveForm.startDate.value.substring(0, 4)}',
                                              style: reserveForm
                                                          .startDate.value ==
                                                      '2023-09-26'
                                                  ? const TextStyle(
                                                      color: Color(0xffB5B9C2),
                                                      fontSize: 16,
                                                      fontFamily:
                                                          'Montserrat-Regular')
                                                  : const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16)),
                                        ),
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
                                errorMessage:
                                    reserveForm.startTime.errorMessage,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.alarm),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () async {
                                          TimeOfDay? pickedTime =
                                              await showTimePicker(
                                                  context: context,
                                                  initialTime: const TimeOfDay(
                                                      hour: 00, minute: 00));

                                          if (pickedTime != null) {
                                            ref
                                                .read(
                                                    reserveFormProvider(reserve)
                                                        .notifier)
                                                .onStartTimeChanged(
                                                    '${pickedTime.toString().substring(10, 12)}:${pickedTime.toString().substring(13, 15)}');
                                          } else {}
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              reserveForm.startTime.value,
                                              style: reserveForm
                                                          .startTime.value ==
                                                      '00:00'
                                                  ? const TextStyle(
                                                      color: Color(0xffB5B9C2),
                                                      fontSize: 16,
                                                      fontFamily:
                                                          'Montserrat-Regular')
                                                  : const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16)),
                                        ),
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
                                Expanded(
                                  child: DropdownButton<String>(
                                    iconSize: 40,
                                    isExpanded: true,
                                    value: reserveForm.tripType.value,
                                    style: reserveForm.tripType.value ==
                                            'Seleccione el tipo de viaje'
                                        ? const TextStyle(
                                            color: Color(0xffB5B9C2),
                                            fontSize: 16,
                                            fontFamily: 'Montserrat-Regular')
                                        : const TextStyle(
                                            color: Colors.black, fontSize: 16),
                                    items: [
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
                                                        color: Colors.grey,
                                                        fontSize: 16)
                                                    : const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16),
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: (newValue) {
                                      ref
                                          .read(reserveFormProvider(reserve)
                                              .notifier)
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
                                Expanded(
                                  child: TextButton(
                                    style: ButtonStyle(
                                      overlayColor: MaterialStateProperty.all(
                                          Colors.transparent),
                                      shadowColor: MaterialStateProperty.all(
                                          Colors.transparent),
                                    ),
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                          reserveForm.startAddress.value,
                                          overflow: TextOverflow.ellipsis,
                                          style: reserveForm
                                                      .startAddress.value ==
                                                  'Seleccione el punto de recojo'
                                              ? const TextStyle(
                                                  color: Color(0xffB5B9C2),
                                                  fontSize: 16,
                                                  fontFamily:
                                                      'Montserrat-Regular')
                                              : const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16)),
                                    ),
                                    onPressed: () async {
                                      final result = await Navigator.of(context)
                                          .push<LocationData>(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MapGoogle()),
                                      );
                                      if (result != null) {
                                        ref
                                            .read(reserveFormProvider(reserve)
                                                .notifier)
                                            .onStartAddressChanged(
                                                result.address,
                                                result.latitude,
                                                result.longitude);
                                      }
                                    },
                                  ),
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
                              errorMessage:
                                  reserveForm.endAddress!.errorMessage,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.trip_origin_outlined),
                                  Expanded(
                                    child: TextButton(
                                      style: ButtonStyle(
                                        overlayColor: MaterialStateProperty.all(
                                            Colors.transparent),
                                        shadowColor: MaterialStateProperty.all(
                                            Colors.transparent),
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            reserveForm.endAddress!.value,
                                            overflow: TextOverflow.ellipsis,
                                            style: reserveForm
                                                        .endAddress!.value ==
                                                    'Seleccione el punto de destino'
                                                ? const TextStyle(
                                                    color: Color(0xffB5B9C2),
                                                    fontSize: 16,
                                                    fontFamily:
                                                        'Montserrat-Regular')
                                                : const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16)),
                                      ),
                                      onPressed: () async {
                                        final result =
                                            await Navigator.of(context)
                                                .push<LocationData>(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MapGoogle()),
                                        );
                                        if (result != null) {
                                          ref
                                              .read(reserveFormProvider(reserve)
                                                  .notifier)
                                              .onEndAddressChanged(
                                                  result.address,
                                                  result.latitude,
                                                  result.longitude);
                                        }
                                      },
                                    ),
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
                              Expanded(
                                child: TextButton(
                                  style: ButtonStyle(
                                      overlayColor: MaterialStateProperty.all(
                                          Colors.transparent),
                                      shadowColor: MaterialStateProperty.all(
                                          Colors.transparent)),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        '${reserveForm.driverName} ${reserveForm.driverLastName}',
                                        style: reserveForm.driverName ==
                                                'Ejem. Luis'
                                            ? const TextStyle(
                                                color: Color(0xffB5B9C2),
                                                fontSize: 16,
                                                fontFamily:
                                                    'Montserrat-Regular')
                                            : const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16)),
                                  ),
                                  onPressed: () {
                                    final searchedDrivers =
                                        ref.read(searchedDriversProvider);
                                    final searchQuery =
                                        ref.read(searchDriversProvider);
                                    final changeCallback = ref
                                        .read(reserveFormProvider(reserve)
                                            .notifier)
                                        .onDriverIdChanged;
                                    showSearch<SearchDriver?>(
                                            query: searchQuery,
                                            context: context,
                                            delegate: SearchDriverDelegate(
                                                callback: changeCallback,
                                                initialDrivers: searchedDrivers,
                                                searchDrivers: ref
                                                    .read(
                                                        searchedDriversProvider
                                                            .notifier)
                                                    .searchDriversByQuery))
                                        .then((driver) {});
                                  },
                                ),
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
                              Expanded(
                                child: TextButton(
                                  style: ButtonStyle(
                                      overlayColor: MaterialStateProperty.all(
                                          Colors.transparent),
                                      shadowColor: MaterialStateProperty.all(
                                          Colors.transparent)),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        '${reserveForm.brand}, ${reserveForm.model}, ${reserveForm.color}, ${reserveForm.licensePlate}',
                                        style: reserveForm.brand ==
                                                'Ejem. Toyota'
                                            ? const TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                color: Color(0xffB5B9C2),
                                                fontSize: 16,
                                                fontFamily:
                                                    'Montserrat-Regular')
                                            : const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16)),
                                  ),
                                  onPressed: () {
                                    final searchedCars =
                                        ref.read(searchedCarsProvider);
                                    final searchQuery =
                                        ref.read(searchCarsProvider);
                                    final changeCallback = ref
                                        .read(reserveFormProvider(reserve)
                                            .notifier)
                                        .onCarIdChanged;
                                    showSearch<SearchCar?>(
                                            query: searchQuery,
                                            context: context,
                                            delegate: SearchCarDelegate(
                                                callback: changeCallback,
                                                initialCars: searchedCars,
                                                searchCars: ref
                                                    .read(searchedCarsProvider
                                                        .notifier)
                                                    .searchCarsByQuery))
                                        .then((driver) {});
                                  },
                                ),
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
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                isTopField: true,
                                isBottomField: true,
                                label: reserveForm.tripType.value == 'Por hora'
                                    ? 'Tarifa base x hora*'
                                    : 'Tarifa base*',
                                hint: 'S/ 00.00',
                                errorMessage: reserveForm.price.errorMessage,
                                prefixIcon: const Icon(
                                    Icons.monetization_on_outlined,
                                    size: 25),
                                onChanged: ref
                                    .read(reserveFormProvider(reserve).notifier)
                                    .onPriceChanged,
                              ),
                            ]),
                          ),
                          SizedBox(
                            width: size.width * .45,
                            child: CustomFormField(
                              initialValue:
                                  reserveForm.silverPercent.value == '0'
                                      ? ''
                                      : reserveForm.silverPercent.value,
                              keyboardType:
                                  const TextInputType.numberWithOptions(),
                              isTopField: true,
                              isBottomField: true,
                              label: '% Silver',
                              hint: '20%',
                              errorMessage:
                                  reserveForm.silverPercent.errorMessage,
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
                          onPressed: () async {
                            ref
                                .read(reserveFormProvider(reserve).notifier)
                                .onFormSubmit(reserve.id!, reserve.tripId)
                                .then((value) {
                              if (!value) return;
                              if (reserve.id! != 0) {
                                ref
                                    .read(reserveDetailProvider.notifier)
                                    .updateReserveDetail(
                                        reserve.id!.toString());
                                if (reserve.tripId != null) {
                                  ref
                                      .read(tripAdminStatusProvider.notifier)
                                      .updateTripStatus(
                                          reserve.tripId!.toString());
                                }
                              } else {
                                final String time = getDifferenceBetweenTimes(
                                    screenLoadTime, DateTime.now());
                                sendEventCreatedReserve(
                                    adminEmail: adminEmail,
                                    amountMinutesCreating: time,
                                    driverId: reserveForm.driverId?.value ?? 0,
                                    serviceType: reserveForm.serviceType.value,
                                    tripType: reserveForm.tripType.value,
                                    userId: reserveForm.userId.value,
                                    reservePrice: reserveForm.price.value,
                                    silverPercent:
                                        reserveForm.silverPercent.value == ''
                                            ? '20'
                                            : reserveForm.silverPercent.value);
                              }
                              showSnackbar(context, reserve.id!);

                              ref
                                  .read(reservesHomeProvider.notifier)
                                  .reloadData();
                              ref
                                  .read(reservesListProvider.notifier)
                                  .reloadData();

                              context.pop();
                            });
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                            fixedSize: MaterialStateProperty.all(
                                Size(size.width * .8, size.height * .07)),
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xFF23A5CD)),
                          ),
                          child: Text(
                              reserve.id == 0 ? "Crear" : "Guardar cambios",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat-Bold',
                                  fontSize: 16)),
                        ),
                      ),
                    ]),
              ),
            ),
          );
  }
}

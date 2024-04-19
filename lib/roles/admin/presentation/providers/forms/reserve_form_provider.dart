import 'dart:convert';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';
import 'package:silverapp/config/dio/dio_request.dart';
import 'package:silverapp/google_maps/google_post_routes.dart';
import 'package:silverapp/providers/auth0_provider.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/create_reserve.dart';
import 'package:silverapp/roles/admin/infraestructure/inputs/car_id.dart';
import 'package:silverapp/roles/admin/infraestructure/inputs/driver_id.dart';
import 'package:silverapp/roles/admin/infraestructure/inputs/service_car_type.dart';
import 'package:silverapp/roles/admin/infraestructure/inputs/silver_percent.dart';
import 'package:silverapp/roles/admin/infraestructure/inputs/end_address.dart';
import 'package:silverapp/roles/admin/infraestructure/inputs/enterprise_id.dart';
import 'package:silverapp/roles/admin/infraestructure/inputs/price.dart';
import 'package:silverapp/roles/admin/infraestructure/inputs/service_type.dart';
import 'package:silverapp/roles/admin/infraestructure/inputs/start_address.dart';
import 'package:silverapp/roles/admin/infraestructure/inputs/start_date.dart';
import 'package:silverapp/roles/admin/infraestructure/inputs/start_time.dart';
import 'package:silverapp/roles/admin/infraestructure/inputs/suggested_price.dart';
import 'package:silverapp/roles/admin/infraestructure/inputs/trip_type.dart';
import 'package:silverapp/roles/admin/infraestructure/inputs/user_id.dart';

final reserveFormProvider = StateNotifierProvider.autoDispose
    .family<ReserveFormNotifier, ReserveFormState, CreateReserve>(
        (ref, reserve) {
  Future<bool> createCallback(Map<String, dynamic> reserveLike) async {
    if (reserveLike['trip_id'] != 'null' && reserveLike['id'] != 'null') {
      try {
        final String? tripId = reserveLike['trip_id'];
        Credentials? credentials = ref.watch(authProvider).credentials;
        await dio(credentials!.accessToken).patch(
            '/trips/admin-trip-total-price/$tripId',
            data: {"total_price": reserveLike['price']});
      } catch (e) {
        print(e);
      }
    }
    try {
      final String? reserveId = reserveLike['id'];
      final String method = (reserveId == null) ? 'POST' : 'PATCH';
      final String url =
          (reserveId == null) ? '/reserves/' : '/reserves/$reserveId';
      Credentials? credentials = ref.watch(authProvider).credentials;
      reserveLike.remove('id');
      final response = await dio(credentials!.accessToken).request(url,
          data: jsonEncode(reserveLike), options: Options(method: method));
      final status = response.statusCode;
      return status == 201 || status == 200 ? true : false;
    } catch (e) {
      throw Exception();
    }
  }

  return ReserveFormNotifier(
    reserve: reserve,
    onSubmitCallback: createCallback,
  );
});

class ReserveFormNotifier extends StateNotifier<ReserveFormState> {
  final Future<bool> Function(Map<String, dynamic> reserveLike)?
      onSubmitCallback;

  ReserveFormNotifier({
    this.onSubmitCallback,
    required CreateReserve reserve,
  }) : super(ReserveFormState(
            userId: reserve.userId == 0
                ? const UserId.pure()
                : UserId.dirty(reserve.userId),
            userName: reserve.userId == 0 ? 'Ejem. Carla' : reserve.userName,
            userLastName:
                reserve.userId == 0 ? 'Peña Ramirez' : reserve.userLastName,
            startDate: reserve.startDate == ''
                ? const StartDate.pure()
                : StartDate.dirty(reserve.startDate),
            startTime: reserve.startTime == ''
                ? const StartTime.pure()
                : StartTime.dirty(reserve.startTime),
            tripType: reserve.tripType == ''
                ? const TripType.pure()
                : TripType.dirty(reserve.tripType[0].toUpperCase() +
                    reserve.tripType.substring(1).toLowerCase()),
            //serviceType: reserve.serviceType ==  ''  ? const ServiceType.pure() : ServiceType.dirty(reserve.serviceType[0].toUpperCase() + reserve.serviceType.substring(1).toLowerCase()),
            serviceType: (reserve.serviceType == ''
                ? const ServiceType.pure()
                : reserve.serviceType == 'ENTERPRISE'
                    ? const ServiceType.dirty('Empresarial')
                    : const ServiceType.dirty('Personal')),
            serviceCarType: (reserve.serviceCarType == ''
                ? const ServiceCarType.pure()
                : reserve.serviceCarType == 'CAR'
                    ? const ServiceCarType.dirty('Auto')
                    : reserve.serviceCarType == 'TRUCK'
                        ? const ServiceCarType.dirty('Camioneta')
                        : const ServiceCarType.dirty('Van')),
            startAddress: reserve.startAddress == ''
                ? const StartAddress.pure()
                : StartAddress.dirty(reserve.startAddress),
            startAddressLat: reserve.startAddressLat,
            startAddressLon: reserve.startAddressLon,
            endAddress: (reserve.endAddress == '' || reserve.endAddress == null)
                ? const EndAddress.pure()
                : EndAddress.dirty(reserve.endAddress!),
            endAddressLat: reserve.endAddressLat,
            endAddressLon: reserve.endAddressLon,
            enterpriseId: reserve.enterpriseId == null
                ? const EnterpriseId.pure()
                : EnterpriseId.dirty(reserve.enterpriseId!),
            driverId: reserve.driverId == null
                ? const DriverId.pure()
                : DriverId.dirty(reserve.driverId!),
            driverName: (reserve.driverId == 0 || reserve.driverId == null)
                ? 'Ejem. Luis'
                : reserve.driverName!,
            driverLastName: (reserve.driverId == 0 || reserve.driverId == null)
                ? 'Perez'
                : reserve.driverLastName!,
            carId: (reserve.carId == 0 || reserve.carId == null)
                ? const CarId.pure()
                : CarId.dirty(reserve.carId!),
            licensePlate: (reserve.carId == 0 || reserve.carId == null)
                ? 'A1R610'
                : reserve.licensePlate!,
            brand: (reserve.carId == 0 || reserve.carId == null)
                ? 'Ejem. Toyota'
                : reserve.brand!,
            model: (reserve.carId == 0 || reserve.carId == null)
                ? 'Corolla'
                : reserve.model!,
            color: (reserve.carId == 0 || reserve.carId == null)
                ? 'Gris'
                : reserve.color!,
            price: reserve.price == ''
                ? const Price.pure()
                : Price.dirty(reserve.tripId == null
                  ? reserve.price.toString()
                : reserve.tripTotalPrice.toString()),
            silverPercent: reserve.silverPercent == ''
                ? const SilverPercent.pure()
                : SilverPercent.dirty(reserve.silverPercent.toString()),
            suggestedPrice: reserve.suggestedPrice == null
                ? const SuggestedPrice.pure()
                : SuggestedPrice.dirty(reserve.suggestedPrice.toString()),
            polyline: reserve.polyline));

  Future<bool> onFormSubmit(int id, [int? tripId]) async {
    _touchedEverything();
    if (!state.isFormValid) return false;

    if (onSubmitCallback == null) return false;
    final Map<String, dynamic> reserveLike = {
      "enterprise_id":
          state.enterpriseId?.value == 0 ? null : state.enterpriseId?.value,
      "user_id": state.userId.value,
      "trip_type": state.tripType.value.toUpperCase(),
      "service_type": state.serviceType.value == 'Empresarial'
          ? 'ENTERPRISE'
          : state.serviceType.value.toUpperCase(),
      "service_car_type": state.serviceCarType.value == 'Auto'
          ? 'CAR'
          : state.serviceCarType.value == 'Camioneta'
              ? 'TRUCK'
              : 'VAN',
      "start_time":
          '${state.startDate.value}T${state.startTime.value}:00-05:00',
      "start_address": state.startAddress.value,
      "start_address_lat": state.startAddressLat,
      "start_address_lon": state.startAddressLon,
      if (tripId == null) "end_address": state.tripType.value != 'Punto a punto'
        ? null
        : state.endAddress?.value,
      if (tripId == null) "end_address_lat": state.tripType.value != 'Punto a punto'
        ? null
        : state.endAddressLat,
      if (tripId == null) "end_address_lon": state.tripType.value != 'Punto a punto'
        ? null
        : state.endAddressLon,
      if (tripId != null) "end_address": state.endAddress?.value,
      if (tripId != null) "end_address_lat": state.endAddressLat,
      if (tripId != null) "end_address_lon": state.endAddressLon,
      "driver_id": state.driverId?.value == 0 || state.driverId?.value == null
          ? null
          : state.driverId?.value,
      "car_id": state.carId?.value == 0 ? null : state.carId?.value,
      "price": state.price.value,
      "suggested_price":
          state.suggestedPrice.value == '' ? null : state.suggestedPrice.value,
      "reserve_polyline": state.polyline == '' ? null : state.polyline,
      if (state.silverPercent.value != '')
        "silver_percent": state.silverPercent.value,
      if (id != 0) "id": id.toString(),
      if (tripId != 0) "trip_id": tripId.toString(),
    };
    try {
      return await onSubmitCallback!(reserveLike);
    } catch (e) {
      return false;
    }
  }

  void _touchedEverything() {
    state = state.copyWith(
      userId: UserId.dirty(state.userId.value),
      enterpriseId: EnterpriseId.dirty(state.enterpriseId!.value),
      serviceType: ServiceType.dirty(state.serviceType.value),
      startDate: StartDate.dirty(state.startDate.value),
      startTime: StartTime.dirty(state.startTime.value),
      tripType: TripType.dirty(state.tripType.value),
      serviceCarType: ServiceCarType.dirty(state.serviceCarType.value),
      startAddress: StartAddress.dirty(state.startAddress.value),
      price: Price.dirty(state.price.value),
      silverPercent: SilverPercent.dirty(state.silverPercent.value),
      endAddress: EndAddress.dirty(state.endAddress!.value),
      isFormValid: Formz.validate([
        UserId.dirty(state.userId.value),
        EnterpriseId.dirty(state.enterpriseId!.value),
        TripType.dirty(state.tripType.value),
        ServiceCarType.dirty(state.serviceCarType.value),
        ServiceType.dirty(state.serviceType.value),
        StartTime.dirty(state.startTime.value),
        StartDate.dirty(state.startDate.value),
        StartAddress.dirty(state.startAddress.value),
        Price.dirty(state.price.value),
        SilverPercent.dirty(state.silverPercent.value),
        if (state.tripType.value == 'Punto a punto')
          EndAddress.dirty(state.endAddress!.value),
      ]),
    );
  }

  void onUserIdChanged(
      int value, String userName, String userLastName, int? enterpriseId) {
    state = state.copyWith(
        userId: UserId.dirty(value),
        enterpriseId:
            enterpriseId == null ? null : EnterpriseId.dirty(enterpriseId),
        userName: userName,
        userLastName: userLastName,
        isFormValid: Formz.validate([
          UserId.dirty(value),
          EnterpriseId.dirty(state.enterpriseId!.value),
          TripType.dirty(state.tripType.value),
          ServiceType.dirty(state.serviceType.value),
          ServiceCarType.dirty(state.serviceCarType.value),
          StartTime.dirty(state.startTime.value),
          StartDate.dirty(state.startDate.value),
          StartAddress.dirty(state.startAddress.value),
          state.endAddress ?? EndAddress.dirty(state.endAddress!.value),
          Price.dirty(state.price.value),
          SilverPercent.dirty(state.silverPercent.value),
        ]));
  }

  void onDriverIdChanged(
      int value,
      String driverName,
      String driverLastName,
      int? carId,
      String? brand,
      String? model,
      String? color,
      String? licensePlate) {
    if (carId != null) {
      onCarIdChanged(carId, brand!, model!, color!, licensePlate!);
    }
    state = state.copyWith(
        driverId: DriverId.dirty(value),
        driverName: driverName,
        driverLastName: driverLastName,
        isFormValid: Formz.validate([
          DriverId.dirty(value),
          UserId.dirty(state.userId.value),
          EnterpriseId.dirty(state.enterpriseId!.value),
          TripType.dirty(state.tripType.value),
          ServiceType.dirty(state.serviceType.value),
          ServiceCarType.dirty(state.serviceCarType.value),
          StartTime.dirty(state.startTime.value),
          StartDate.dirty(state.startDate.value),
          StartAddress.dirty(state.startAddress.value),
          state.endAddress ?? EndAddress.dirty(state.endAddress!.value),
          Price.dirty(state.price.value),
          SilverPercent.dirty(state.silverPercent.value),
        ]));
  }

  void onCarIdChanged(int value, String brand, String model, String color,
      String licensePlate) {
    state = state.copyWith(
        carId: CarId.dirty(value),
        licensePlate: licensePlate,
        brand: brand,
        model: model,
        color: color,
        isFormValid: Formz.validate([
          DriverId.dirty(value),
          UserId.dirty(state.userId.value),
          EnterpriseId.dirty(state.enterpriseId!.value),
          TripType.dirty(state.tripType.value),
          ServiceType.dirty(state.serviceType.value),
          ServiceCarType.dirty(state.serviceCarType.value),
          StartTime.dirty(state.startTime.value),
          StartDate.dirty(state.startDate.value),
          StartAddress.dirty(state.startAddress.value),
          state.endAddress ?? EndAddress.dirty(state.endAddress!.value),
          Price.dirty(state.price.value),
          SilverPercent.dirty(state.silverPercent.value),
        ]));
  }

  void onTripTypeChanged(String value) {
    state = state.copyWith(
        tripType: TripType.dirty(value),
        isFormValid: Formz.validate([
          TripType.dirty(value),
          UserId.dirty(state.userId.value),
          EnterpriseId.dirty(state.enterpriseId!.value),
          ServiceType.dirty(state.serviceType.value),
          StartTime.dirty(state.startTime.value),
          StartDate.dirty(state.startDate.value),
          StartAddress.dirty(state.startAddress.value),
          ServiceCarType.dirty(state.serviceCarType.value),
          EndAddress.dirty(state.endAddress!.value),
          Price.dirty(state.price.value),
          SilverPercent.dirty(state.silverPercent.value),
        ]));
  }

  void onServiceTypeChanged(String value) {
    state = state.copyWith(
        serviceType: ServiceType.dirty(value),
        isFormValid: Formz.validate([
          ServiceType.dirty(value),
          UserId.dirty(state.userId.value),
          EnterpriseId.dirty(state.enterpriseId!.value),
          TripType.dirty(state.tripType.value),
          StartTime.dirty(state.startTime.value),
          ServiceCarType.dirty(state.serviceCarType.value),
          StartDate.dirty(state.startDate.value),
          StartAddress.dirty(state.startAddress.value),
          state.endAddress ?? EndAddress.dirty(state.endAddress!.value),
          Price.dirty(state.price.value),
          SilverPercent.dirty(state.silverPercent.value),
        ]));
  }

  void onServiceCarTypeChanged(String value) {
    state = state.copyWith(
        serviceCarType: ServiceCarType.dirty(value),
        isFormValid: Formz.validate([
          ServiceType.dirty(value),
          UserId.dirty(state.userId.value),
          EnterpriseId.dirty(state.enterpriseId!.value),
          TripType.dirty(state.tripType.value),
          StartTime.dirty(state.startTime.value),
          ServiceCarType.dirty(state.serviceCarType.value),
          StartDate.dirty(state.startDate.value),
          ServiceType.dirty(state.serviceType.value),
          StartAddress.dirty(state.startAddress.value),
          state.endAddress ?? EndAddress.dirty(state.endAddress!.value),
          Price.dirty(state.price.value),
          SilverPercent.dirty(state.silverPercent.value),
        ]));
  }

  void onSuggestedPriceChanged() async {
    if (state.startAddressLat == 0 ||
        state.startAddressLon == 0 ||
        state.endAddressLat == null ||
        state.endAddressLon == null ||
        state.serviceCarType.value == 'Seleccione el tipo de vehículo' ||
        state.startDate.value == '2023-09-26' ||
        state.startTime.value == '00 : 00' ||
        state.tripType.value == 'Seleccione el tipo de viaje' ||
        state.tripType.value == 'Por hora') {
      state = state.copyWith(
        suggestedPrice: const SuggestedPrice.pure(),
      );
      return;
    }
    try {
      String startDate = state.startDate.value;
      String startTime = state.startTime.value;
      String dateTimeString = "$startDate $startTime";
      DateTime dateTime = DateTime.parse(dateTimeString);
      dateTime = dateTime.add(const Duration(hours: 6));
      String formattedDateTime =
          DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(dateTime);
      var distance = await getGoogleRoute(
        state.startAddressLat,
        state.startAddressLon,
        state.endAddressLat,
        state.endAddressLon,
        "${formattedDateTime}Z",
      );
      var basePrice = calculateBasePrice(
              distance.routes[0].distanceMeters,
              distance.routes[0].getDurationInSeconds(),
              state.serviceCarType.value,
              isInDesiredTimeRange(state.startTime.value))
          .toStringAsFixed(2);
      state = state.copyWith(
        suggestedPrice: SuggestedPrice.dirty(basePrice),
        polyline: distance.routes[0].polyline,
      );
    } catch (e) {
      print("Error al calcular la ruta: $e");
    }
  }

  void onStartTimeChanged(String value) {
    state = state.copyWith(
        startTime: StartTime.dirty(value),
        isFormValid: Formz.validate([
          StartTime.dirty(value),
          StartDate.dirty(state.startDate.value),
          UserId.dirty(state.userId.value),
          EnterpriseId.dirty(state.enterpriseId!.value),
          TripType.dirty(state.tripType.value),
          ServiceCarType.dirty(state.serviceCarType.value),
          ServiceType.dirty(state.serviceType.value),
          StartAddress.dirty(state.startAddress.value),
          state.endAddress ?? EndAddress.dirty(state.endAddress!.value),
          Price.dirty(state.price.value),
          SilverPercent.dirty(state.silverPercent.value),
        ]));
  }

  void onStartDateChanged(String value) {
    state = state.copyWith(
        startDate: StartDate.dirty(value),
        isFormValid: Formz.validate([
          StartDate.dirty(value),
          UserId.dirty(state.userId.value),
          EnterpriseId.dirty(state.enterpriseId!.value),
          TripType.dirty(state.tripType.value),
          ServiceType.dirty(state.serviceType.value),
          ServiceCarType.dirty(state.serviceCarType.value),
          StartAddress.dirty(state.startAddress.value),
          state.endAddress ?? EndAddress.dirty(state.endAddress!.value),
          Price.dirty(state.price.value),
          SilverPercent.dirty(state.silverPercent.value),
        ]));
  }

  void onStartAddressChanged(String value, double lat, double lon) {
    state = state.copyWith(
        startAddress: StartAddress.dirty(value),
        startAddressLat: lat,
        startAddressLon: lon,
        isFormValid: Formz.validate([
          StartAddress.dirty(value),
          UserId.dirty(state.userId.value),
          EnterpriseId.dirty(state.enterpriseId!.value),
          TripType.dirty(state.tripType.value),
          ServiceCarType.dirty(state.serviceCarType.value),
          ServiceType.dirty(state.serviceType.value),
          StartTime.dirty(state.startTime.value),
          state.endAddress ?? EndAddress.dirty(state.endAddress!.value),
          StartDate.dirty(state.startDate.value),
          Price.dirty(state.price.value),
          SilverPercent.dirty(state.silverPercent.value),
        ]));
  }

  void onEndAddressChanged(String value, double lat, double lon) {
    state = state.copyWith(
        endAddress: EndAddress.dirty(value),
        endAddressLat: lat,
        endAddressLon: lon,
        isFormValid: Formz.validate([
          EndAddress.dirty(value),
          UserId.dirty(state.userId.value),
          EnterpriseId.dirty(state.enterpriseId!.value),
          TripType.dirty(state.tripType.value),
          ServiceCarType.dirty(state.serviceCarType.value),
          ServiceType.dirty(state.serviceType.value),
          StartTime.dirty(state.startTime.value),
          StartDate.dirty(state.startDate.value),
          StartAddress.dirty(state.startAddress.value),
          Price.dirty(state.price.value),
          SilverPercent.dirty(state.silverPercent.value),
        ]));
  }

  void onPriceChanged(String value) {
    state = state.copyWith(
        price: Price.dirty(value),
        isFormValid: Formz.validate([
          Price.dirty(value),
          UserId.dirty(state.userId.value),
          EnterpriseId.dirty(state.enterpriseId!.value),
          TripType.dirty(state.tripType.value),
          ServiceCarType.dirty(state.serviceCarType.value),
          ServiceType.dirty(state.serviceType.value),
          StartTime.dirty(state.startTime.value),
          StartDate.dirty(state.startDate.value),
          StartAddress.dirty(state.startAddress.value),
          SilverPercent.dirty(state.silverPercent.value),
          if (state.tripType.value == 'Punto a punto')
            EndAddress.dirty(state.endAddress!.value),
        ]));
  }

  void onSilverPercentChanged(String value) {
    state = state.copyWith(
        silverPercent: SilverPercent.dirty(value),
        isFormValid: Formz.validate([
          SilverPercent.dirty(value),
          UserId.dirty(state.userId.value),
          EnterpriseId.dirty(state.enterpriseId!.value),
          TripType.dirty(state.tripType.value),
          ServiceCarType.dirty(state.serviceCarType.value),
          ServiceType.dirty(state.serviceType.value),
          StartTime.dirty(state.startTime.value),
          StartDate.dirty(state.startDate.value),
          StartAddress.dirty(state.startAddress.value),
          EndAddress.dirty(state.endAddress!.value),
          Price.dirty(state.price.value),
        ]));
  }
}

class ReserveFormState {
  final bool isFormValid;
  final UserId userId;
  final ServiceType serviceType;
  final String userName;
  final String userLastName;
  final DriverId? driverId;
  final String? driverName;
  final String? driverLastName;
  final EnterpriseId? enterpriseId;
  final CarId? carId;
  final String? licensePlate;
  final String? brand;
  final String? model;
  final String? color;
  final TripType tripType;
  final ServiceCarType serviceCarType;
  final StartTime startTime;
  final StartDate startDate;
  final StartAddress startAddress;
  final double startAddressLat;
  final double startAddressLon;
  final EndAddress? endAddress;
  final double? endAddressLat;
  final double? endAddressLon;
  final Price price;
  final SuggestedPrice suggestedPrice;
  final SilverPercent silverPercent;
  final String? polyline;

  ReserveFormState({
    this.isFormValid = false,
    this.userId = const UserId.pure(),
    this.serviceType = const ServiceType.pure(),
    this.userName = 'Ejem. Carla',
    this.userLastName = 'Peña Ramirez',
    this.driverName = 'Ejem. Luis',
    this.driverLastName = 'Perez',
    this.startDate = const StartDate.pure(),
    this.startTime = const StartTime.pure(),
    this.tripType = const TripType.pure(),
    this.serviceCarType = const ServiceCarType.pure(),
    this.startAddress = const StartAddress.pure(),
    this.startAddressLat = 0,
    this.startAddressLon = 0,
    this.endAddress = const EndAddress.pure(),
    this.endAddressLat,
    this.endAddressLon,
    this.enterpriseId = const EnterpriseId.dirty(0),
    this.carId = const CarId.dirty(0),
    this.licensePlate = 'A1R610',
    this.brand = 'Ejem. Toyota',
    this.model = 'Corolla',
    this.color = 'Gris',
    this.driverId = const DriverId.pure(),
    this.price = const Price.pure(),
    this.suggestedPrice = const SuggestedPrice.pure(),
    this.silverPercent = const SilverPercent.pure(),
    this.polyline = '',
  });

  ReserveFormState copyWith(
          {final bool? isFormValid,
          final UserId? userId,
          final String? userName,
          final String? userLastName,
          final EnterpriseId? enterpriseId,
          final CarId? carId,
          final String? licensePlate,
          final String? brand,
          final String? model,
          final String? color,
          final DriverId? driverId,
          final String? driverName,
          final String? driverLastName,
          final TripType? tripType,
          final ServiceCarType? serviceCarType,
          final ServiceType? serviceType,
          final StartTime? startTime,
          final StartDate? startDate,
          final StartAddress? startAddress,
          final double? startAddressLat,
          final double? startAddressLon,
          final EndAddress? endAddress,
          final double? endAddressLat,
          final double? endAddressLon,
          final Price? price,
          final SuggestedPrice? suggestedPrice,
          final SilverPercent? silverPercent,
          final String? polyline}) =>
      ReserveFormState(
          isFormValid: isFormValid ?? this.isFormValid,
          userId: userId ?? this.userId,
          userName: userName ?? this.userName,
          userLastName: userLastName ?? this.userLastName,
          driverName: driverName ?? this.driverName,
          driverLastName: driverLastName ?? this.driverLastName,
          enterpriseId: enterpriseId ?? this.enterpriseId,
          carId: carId ?? this.carId,
          licensePlate: licensePlate ?? this.licensePlate,
          brand: brand ?? this.brand,
          model: model ?? this.model,
          color: color ?? this.color,
          driverId: driverId ?? this.driverId,
          serviceType: serviceType ?? this.serviceType,
          tripType: tripType ?? this.tripType,
          serviceCarType: serviceCarType ?? this.serviceCarType,
          startTime: startTime ?? this.startTime,
          startDate: startDate ?? this.startDate,
          startAddress: startAddress ?? this.startAddress,
          startAddressLat: startAddressLat ?? this.startAddressLat,
          startAddressLon: startAddressLon ?? this.startAddressLon,
          endAddress: endAddress ?? this.endAddress,
          endAddressLat: endAddressLat ?? this.endAddressLat,
          endAddressLon: endAddressLon ?? this.endAddressLon,
          price: price ?? this.price,
          suggestedPrice: suggestedPrice ?? this.suggestedPrice,
          silverPercent: silverPercent ?? this.silverPercent,
          polyline: polyline ?? this.polyline);
}

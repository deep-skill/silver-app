import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:silverapp/config/dio/dio.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/create_reserve.dart';
import 'package:silverapp/roles/admin/infraestructure/inputs/car_id.dart';
import 'package:silverapp/roles/admin/infraestructure/inputs/driver_id.dart';
import 'package:silverapp/roles/admin/infraestructure/inputs/silver_percent.dart';
import 'package:silverapp/roles/admin/infraestructure/inputs/end_address.dart';
import 'package:silverapp/roles/admin/infraestructure/inputs/enterprise_id.dart';
import 'package:silverapp/roles/admin/infraestructure/inputs/price.dart';
import 'package:silverapp/roles/admin/infraestructure/inputs/service_type.dart';
import 'package:silverapp/roles/admin/infraestructure/inputs/start_address.dart';
import 'package:silverapp/roles/admin/infraestructure/inputs/start_date.dart';
import 'package:silverapp/roles/admin/infraestructure/inputs/start_time.dart';
import 'package:silverapp/roles/admin/infraestructure/inputs/trip_type.dart';
import 'package:silverapp/roles/admin/infraestructure/inputs/user_id.dart';

final reserveFormProvider = StateNotifierProvider.autoDispose
    .family<ReserveFormNotifier, ReserveFormState, CreateReserve>(
        (ref, reserve) {
  // final createUpdateCallback = ref.watch( productsRepositoryProvider ).createUpdateProduct;
  Future<bool> createCallback(Map<String, dynamic> reserveLike) async {
    try {
      final String? reserveId = reserveLike['id'];
      final String method = (reserveId == null) ? 'POST' : 'PATCH';
      final String url =
          (reserveId == null) ? '/reserves/' : '/reserves/$reserveId';

      reserveLike.remove('id');

      final response = await dio.post(url,
          data: jsonEncode(reserveLike), options: Options(method: method));
      final status = response.statusCode;
      return status == 201 ? true : false;
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
          userId: const UserId.pure(),
          serviceType: const ServiceType.pure(),
          startDate: const StartDate.pure(),
          startTime: const StartTime.pure(),
          tripType: const TripType.pure(),
          startAddress: const StartAddress.pure(),
          endAddress: const EndAddress.pure(),
          enterpriseId: const EnterpriseId.pure(),
          carId: const CarId.pure(),
          driverId: const DriverId.pure(),
          price: const Price.pure(),
          silverPercent: const SilverPercent.pure(),
        ));

  Future<bool> onFormSubmit() async {
    _touchedEverything();
    if (!state.isFormValid) return false;

    if (onSubmitCallback == null) return false;

    final Map<String, dynamic> reserveLike = {
      "enterprise_id": state.enterpriseId?.value == 0 ||
              state.serviceType.value != 'Empresarial'
          ? null
          : state.enterpriseId?.value,
      "user_id": state.userId.value,
      "trip_type": state.tripType.value.toUpperCase(),
      "service_type": state.serviceType.value == 'Empresarial'
          ? 'ENTERPRISE'
          : state.serviceType.value.toUpperCase(),
      "start_time": '${state.startDate.value}T${state.startTime.value}:00-05:00',
      "start_address": state.startAddress.value,
      "end_address":
          state.endAddress?.value == 'Seleccione el punto de destino' ||
                  state.tripType.value != 'Punto a punto'
              ? null
              : state.endAddress?.value,
      "driver_id": state.driverId?.value == 0 ? null : state.driverId?.value,
      "car_id": state.carId?.value == 0 ? null : state.carId?.value,
      "price": state.price.value,
      if (state.silverPercent.value == '0')
        "silver_percent": state.silverPercent.value,
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
      startAddress: StartAddress.dirty(state.startAddress.value),
      price: Price.dirty(state.price.value),
      silverPercent: SilverPercent.dirty(state.silverPercent.value),
      endAddress: EndAddress.dirty(state.endAddress!.value),
      isFormValid: Formz.validate([
        UserId.dirty(state.userId.value),
        EnterpriseId.dirty(state.enterpriseId!.value),
        TripType.dirty(state.tripType.value),
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
          StartTime.dirty(state.startTime.value),
          StartDate.dirty(state.startDate.value),
          StartAddress.dirty(state.startAddress.value),
          state.endAddress ?? EndAddress.dirty(state.endAddress!.value),
          Price.dirty(state.price.value),
          SilverPercent.dirty(state.silverPercent.value),
        ]));
  }

  void onDriverIdChanged(int value, String driverName, String driverLastName, int? carId, String? brand, String? model, String? color, String? licensePlate) {
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
          StartTime.dirty(state.startTime.value),
          StartDate.dirty(state.startDate.value),
          StartAddress.dirty(state.startAddress.value),
          state.endAddress ?? EndAddress.dirty(state.endAddress!.value),
          Price.dirty(state.price.value),
          SilverPercent.dirty(state.silverPercent.value),
        ]));
  }
  void onCarIdChanged(int value, String brand, String model, String color, String licensePlate) {
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
          StartDate.dirty(state.startDate.value),
          StartAddress.dirty(state.startAddress.value),
          state.endAddress ?? EndAddress.dirty(state.endAddress!.value),
          Price.dirty(state.price.value),
          SilverPercent.dirty(state.silverPercent.value),
        ]));
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
          StartAddress.dirty(state.startAddress.value),
          state.endAddress ?? EndAddress.dirty(state.endAddress!.value),
          Price.dirty(state.price.value),
          SilverPercent.dirty(state.silverPercent.value),
        ]));
  }

  void onStartAddressChanged(String value) {
    state = state.copyWith(
        startAddress: StartAddress.dirty(value),
        isFormValid: Formz.validate([
          StartAddress.dirty(value),
          UserId.dirty(state.userId.value),
          EnterpriseId.dirty(state.enterpriseId!.value),
          TripType.dirty(state.tripType.value),
          ServiceType.dirty(state.serviceType.value),
          StartTime.dirty(state.startTime.value),
          state.endAddress ?? EndAddress.dirty(state.endAddress!.value),
          StartDate.dirty(state.startDate.value),
          Price.dirty(state.price.value),
          SilverPercent.dirty(state.silverPercent.value),
        ]));
  }

  void onEndAddressChanged(String value) {
    state = state.copyWith(
        endAddress: EndAddress.dirty(value),
        isFormValid: Formz.validate([
          EndAddress.dirty(value),
          UserId.dirty(state.userId.value),
          EnterpriseId.dirty(state.enterpriseId!.value),
          TripType.dirty(state.tripType.value),
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
  final StartTime startTime;
  final StartDate startDate;
  final StartAddress startAddress;
  final EndAddress? endAddress;
  final Price price;
  final SilverPercent silverPercent;

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
    this.startAddress = const StartAddress.pure(),
    this.endAddress = const EndAddress.pure(),
    this.enterpriseId = const EnterpriseId.dirty(0),
    this.carId  = const CarId.dirty(0),
    this.licensePlate = 'A1R610',
    this.brand = 'Ejem. Toyota',
    this.model = 'Corolla',
    this.color = 'Gris',
    this.driverId = const DriverId.pure(),
    this.price = const Price.pure(),
    this.silverPercent = const SilverPercent.pure(),
  });

  ReserveFormState copyWith({
    final bool? isFormValid,
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
    final ServiceType? serviceType,
    final StartTime? startTime,
    final StartDate? startDate,
    final StartAddress? startAddress,
    final EndAddress? endAddress,
    final Price? price,
    final SilverPercent? silverPercent,
  }) =>
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
        startTime: startTime ?? this.startTime,
        startDate: startDate ?? this.startDate,
        startAddress: startAddress ?? this.startAddress,
        endAddress: endAddress ?? this.endAddress,
        price: price ?? this.price,
        silverPercent: silverPercent ?? this.silverPercent,
      );
}
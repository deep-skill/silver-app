import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:silverapp/config/dio/dio.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/create_reserve.dart';
import 'package:silverapp/roles/admin/infraestructure/inputs/driver_percent.dart';
import 'package:silverapp/roles/admin/infraestructure/inputs/enterprise_id.dart';
import 'package:silverapp/roles/admin/infraestructure/inputs/price.dart';
import 'package:silverapp/roles/admin/infraestructure/inputs/service_type.dart';
import 'package:silverapp/roles/admin/infraestructure/inputs/start_adress.dart';
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
          (reserveId == null) ? '/products' : '/products/$reserveId';

      reserveLike.remove('id');

      final response = await dio.request(url,
          data: reserveLike, options: Options(method: method));

      //final product = ProductMapper.jsonToEntity(response.data);
      final product = response.data;
      return product;
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
          userId: UserId.dirty(reserve.userId),
          enterpriseId: EnterpriseId.dirty(reserve.enterpriseId),
          carId: reserve.carId,
          driverId: reserve.driverId,
          tripType: TripType.dirty(reserve.tripType),
          serviceType: ServiceType.dirty(reserve.serviceType),
          startTime: StartTime.dirty(reserve.startTime),
          startAddress: StartAddress.dirty(reserve.startAddress),
          endAddress: reserve.endAddress,
          price: Price.dirty(reserve.price),
          driverPercent: DriverPercent.dirty(reserve.driverPercent),
          silverPercent: reserve.silverPercent,
        ));

  Future<bool> onFormSubmit() async {
    _touchedEverything();
    if (!state.isFormValid) return false;

    // TODO: regresar
    if (onSubmitCallback == null) return false;

    final reserveLike = {
      "user_id": state.userId.value,
      "enterprise_id": state.enterpriseId.value,
      "car_id": state.carId,
      "driver_id": state.driverId,
      "trip_type": state.tripType.value,
      "service_type": state.serviceType.value,
      "start_time": state.startTime.value,
      "start_address": state.startAddress.value,
      "end_address": state.endAddress,
      "price": state.price.value,
      "driver_percent": state.driverPercent.value,
      "silver_percent": state.silverPercent
    };

    try {
      return await onSubmitCallback!(reserveLike);
    } catch (e) {
      return false;
    }
  }

  void _touchedEverything() {
    state = state.copyWith(
      isFormValid: Formz.validate([
        UserId.dirty(state.userId.value),
        EnterpriseId.dirty(state.enterpriseId.value),
        TripType.dirty(state.tripType.value),
        ServiceType.dirty(state.serviceType.value),
        StartTime.dirty(state.startTime.value),
        StartAddress.dirty(state.startAddress.value),
        Price.dirty(state.price.value),
        DriverPercent.dirty(state.driverPercent.value),
      ]),
    );
  }

  void onUserIdChanged(int value, String userName, String userLastName) {
    state = state.copyWith(
        userId: UserId.dirty(value),
        userName: userName,
        userLastName: userLastName,
        isFormValid: Formz.validate([
          UserId.dirty(value),
          EnterpriseId.dirty(state.enterpriseId.value),
          TripType.dirty(state.tripType.value),
          ServiceType.dirty(state.serviceType.value),
          StartTime.dirty(state.startTime.value),
          StartAddress.dirty(state.startAddress.value),
          Price.dirty(state.price.value),
          DriverPercent.dirty(state.driverPercent.value),
        ]));
  }

  void onEnterpriseIdChanged(int value) {
    state = state.copyWith(
        enterpriseId: EnterpriseId.dirty(value),
        isFormValid: Formz.validate([
          EnterpriseId.dirty(value),
          UserId.dirty(state.userId.value),
          TripType.dirty(state.tripType.value),
          ServiceType.dirty(state.serviceType.value),
          StartTime.dirty(state.startTime.value),
          StartAddress.dirty(state.startAddress.value),
          Price.dirty(state.price.value),
          DriverPercent.dirty(state.driverPercent.value),
        ]));
  }

  void onTripTypeChanged(String value) {
    state = state.copyWith(
        tripType: TripType.dirty(value),
        isFormValid: Formz.validate([
          TripType.dirty(value),
          UserId.dirty(state.userId.value),
          EnterpriseId.dirty(state.enterpriseId.value),
          ServiceType.dirty(state.serviceType.value),
          StartTime.dirty(state.startTime.value),
          StartAddress.dirty(state.startAddress.value),
          Price.dirty(state.price.value),
          DriverPercent.dirty(state.driverPercent.value),
        ]));
  }

  void onServiceTypeChanged(String value) {
    state = state.copyWith(
        serviceType: ServiceType.dirty(value),
        isFormValid: Formz.validate([
          ServiceType.dirty(value),
          UserId.dirty(state.userId.value),
          EnterpriseId.dirty(state.enterpriseId.value),
          TripType.dirty(state.tripType.value),
          StartTime.dirty(state.startTime.value),
          StartAddress.dirty(state.startAddress.value),
          Price.dirty(state.price.value),
          DriverPercent.dirty(state.driverPercent.value),
        ]));
  }

  void onStartTimeChanged(String value) {
    state = state.copyWith(
        startTime: StartTime.dirty(value),
        isFormValid: Formz.validate([
          StartTime.dirty(value),
          UserId.dirty(state.userId.value),
          EnterpriseId.dirty(state.enterpriseId.value),
          TripType.dirty(state.tripType.value),
          ServiceType.dirty(state.serviceType.value),
          StartAddress.dirty(state.startAddress.value),
          Price.dirty(state.price.value),
          DriverPercent.dirty(state.driverPercent.value),
        ]));
  }

  void onStartAddressChanged(String value) {
    state = state.copyWith(
        startAddress: StartAddress.dirty(value),
        isFormValid: Formz.validate([
          StartAddress.dirty(value),
          UserId.dirty(state.userId.value),
          EnterpriseId.dirty(state.enterpriseId.value),
          TripType.dirty(state.tripType.value),
          ServiceType.dirty(state.serviceType.value),
          StartTime.dirty(state.startTime.value),
          Price.dirty(state.price.value),
          DriverPercent.dirty(state.driverPercent.value),
        ]));
  }

  void onPriceChanged(double value) {
    state = state.copyWith(
        price: Price.dirty(value),
        isFormValid: Formz.validate([
          Price.dirty(value),
          UserId.dirty(state.userId.value),
          EnterpriseId.dirty(state.enterpriseId.value),
          TripType.dirty(state.tripType.value),
          ServiceType.dirty(state.serviceType.value),
          StartTime.dirty(state.startTime.value),
          StartAddress.dirty(state.startAddress.value),
          DriverPercent.dirty(state.driverPercent.value),
        ]));
  }

  void onDriverPercentChanged(int value) {
    state = state.copyWith(
        driverPercent: DriverPercent.dirty(value),
        isFormValid: Formz.validate([
          DriverPercent.dirty(value),
          UserId.dirty(state.userId.value),
          EnterpriseId.dirty(state.enterpriseId.value),
          TripType.dirty(state.tripType.value),
          ServiceType.dirty(state.serviceType.value),
          StartTime.dirty(state.startTime.value),
          StartAddress.dirty(state.startAddress.value),
          Price.dirty(state.price.value),
        ]));
  }

  void onCarIdChanged(int carId) {
    state = state.copyWith(carId: carId);
  }

  void onDriverIdChanged(int driverId) {
    state = state.copyWith(driverId: driverId);
  }

  void onGenderChanged(String endAddress) {
    state = state.copyWith(endAddress: endAddress);
  }

  void onSilverPercentChanged(int silverPercent) {
    state = state.copyWith(silverPercent: silverPercent);
  }
}

class ReserveFormState {
  final bool isFormValid;
  final UserId userId;
  final String userName;
  final String userLastName;
  final EnterpriseId enterpriseId;
  final int? carId;
  final int? driverId;
  final TripType tripType;
  final ServiceType serviceType;
  final StartTime startTime;
  final StartAddress startAddress;
  final String? endAddress;
  final Price price;
  final DriverPercent driverPercent;
  final int? silverPercent;

  ReserveFormState({
    this.isFormValid = false,
    this.userId = const UserId.dirty(0),
    this.userName = 'Ejem. Carla',
    this.userLastName = 'Peña Ramirez',
    this.enterpriseId = const EnterpriseId.dirty(0),
    this.carId,
    this.driverId,
    this.tripType = const TripType.dirty(''),
    this.serviceType = const ServiceType.dirty(''),
    this.startTime = const StartTime.dirty(''),
    this.startAddress = const StartAddress.dirty(''),
    this.endAddress,
    this.price = const Price.dirty(0),
    this.driverPercent = const DriverPercent.dirty(0),
    this.silverPercent,
  });

  ReserveFormState copyWith({
    final bool? isFormValid,
    final UserId? userId,
    final String? userName,
    final String? userLastName,
    final EnterpriseId? enterpriseId,
    final int? carId,
    final int? driverId,
    final TripType? tripType,
    final ServiceType? serviceType,
    final StartTime? startTime,
    final StartAddress? startAddress,
    final String? endAddress,
    final Price? price,
    final DriverPercent? driverPercent,
    final int? silverPercent,
  }) =>
      ReserveFormState(
        isFormValid: isFormValid ?? this.isFormValid,
        userId: userId ?? this.userId,
        userName: userName ?? this.userName,
        userLastName: userLastName ?? this.userLastName,
        enterpriseId: enterpriseId ?? this.enterpriseId,
        carId: carId ?? this.carId,
        driverId: driverId ?? this.driverId,
        serviceType: serviceType ?? this.serviceType,
        startTime: startTime ?? this.startTime,
        startAddress: startAddress ?? this.startAddress,
        endAddress: endAddress ?? this.endAddress,
        price: price ?? this.price,
        driverPercent: driverPercent ?? this.driverPercent,
        silverPercent: silverPercent ?? this.silverPercent,
      );
}

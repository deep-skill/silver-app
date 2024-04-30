double calculateWaitingAmount(
    DateTime? arrivedDriver, DateTime? startTime, DateTime reserveStartTime) {
  DateTime calculateDifferenceTime = reserveStartTime;

  Duration driverDelay = reserveStartTime.difference(arrivedDriver!);
  if (driverDelay.inMinutes < 0) {
    calculateDifferenceTime = arrivedDriver;
  }
  Duration difference = startTime!.difference(calculateDifferenceTime);

  if (difference.inMinutes >= 15) {
    return (difference.inMinutes.toDouble() - 15) * 0.5;
  }
  return 0.0;
}

double calculateFraction(int time) {
  double result = 0.0;
  int hourComplete = time ~/ 60;
  int minuteComplete = (time % 60).toInt();
  if (minuteComplete <= 15) {
    result = hourComplete.toDouble();
  } else if (minuteComplete >= 45) {
    result = hourComplete.toDouble() + 1.0;
  } else {
    result = hourComplete.toDouble() + 0.5;
  }
  return result;
}

double totalPricePerHour(
    DateTime arrivedDriver, DateTime reserveStartTime, String serviceCarType) {
  //We take as initial value the time indicated in the reservation
  DateTime calculateDifferenceTime = reserveStartTime;
  //We check if the driver was late
  Duration driverDelay = reserveStartTime.difference(arrivedDriver);
  //If there is a difference we use arrivedDriver to calculate it
  if (driverDelay.inMinutes < 0) {
    calculateDifferenceTime = arrivedDriver;
  }

  final diferencia = DateTime.now().difference(calculateDifferenceTime);
  //We verify if the difference is greater than the minimum
  //Otherwise we calculate the difference
  if (serviceCarType == "VAN") {
    if (diferencia.inMinutes <= 240) {
      return 4;
    } else {
      return calculateFraction(diferencia.inMinutes);
    }
  }
  if (diferencia.inMinutes <= 120) {
    return 2;
  } else {
    return calculateFraction(diferencia.inMinutes);
  }
}

double calculateDistance(int distanceMeters) {
  return distanceMeters / 1000;
}

double calculateTime(int durationSeconds) {
  return durationSeconds / 60;
}

int calculateBasePriceDriver(
  int distanceMeters,
  int durationSeconds,
  String type,
  bool additional,
) {
  double distanceKilometers = calculateDistance(distanceMeters);
  double timeMinutes = calculateTime(durationSeconds);

  if (type == 'TRUCK' || type == 'VAN') {
    double truckBasePrice = 5 + 3.32 * distanceKilometers + 0.20 * timeMinutes;
    if (type == 'VAN' || truckBasePrice < 90) truckBasePrice = 90;
    if (type == 'TRUCK' || truckBasePrice < 25) truckBasePrice = 25;
    if (additional) truckBasePrice = (truckBasePrice * 1.1);
    return truckBasePrice.round();
  }
  double basePrice = 4 + 1.95 * distanceKilometers + 0.14 * timeMinutes;
  if (basePrice < 20) basePrice = 20;
  if (additional) return (basePrice * 1.1).round();
  return basePrice.round();
}

bool calculateInRushHour(DateTime? stringTime) {
  if (stringTime != null) {
    int hour = stringTime.hour;
    return (hour >= 7 && hour <= 10) || (hour >= 17 && hour <= 20);
  }
  return false;
}

double calculateBasePriceCustomer(
    double totalPrice, String serviceCarType, DateTime reserveStartTime) {
  switch (serviceCarType) {
    case "VAN":
      if (calculateInRushHour(reserveStartTime)) {
        if (totalPrice < 99.0) return 99.0;
        return totalPrice;
      }
      if (totalPrice < 90.0) return 90.0;
      return totalPrice;

    case "TRUCK":
      if (calculateInRushHour(reserveStartTime)) {
        if (totalPrice < 27.5) return 27.5;
        return totalPrice;
      }
      if (totalPrice < 25.0) return 25.0;
      return totalPrice;

    default:
      if (calculateInRushHour(reserveStartTime)) {
        if (totalPrice < 22.0) return 22.0;
        return totalPrice;
      }
      if (totalPrice < 20.0) return 20.0;
      return totalPrice;
  }
}

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

String getDifferenceBetweenTimes(DateTime arrivedDriver, DateTime tripEnded) {
  Duration difference = tripEnded.difference(arrivedDriver);
  int minutes = difference.inMinutes;
  int seconds = difference.inSeconds % 60;
  String formattedMinutes = minutes.toString().padLeft(2, '0');
  String formattedSeconds = seconds.toString().padLeft(2, '0');
  return '$formattedMinutes:$formattedSeconds';
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

import 'package:silverapp/roles/admin/entities/search_passenger.dart';

class SerchPassengerResponse {
  SerchPassengerResponse({
    required this.passengers,
  });

  final List<SearchPassenger> passengers;

  factory SerchPassengerResponse.fromJson(List json) => SerchPassengerResponse(
        passengers: List<SearchPassenger>.from(
            json.map((x) => SearchPassenger.fromJson(x))),
      );
}

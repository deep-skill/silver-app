import 'package:silverapp/roles/admin/infraestructure/entities/search_passenger.dart';

class SearchPassengerResponse {
  SearchPassengerResponse({
    required this.passengers,
  });

  final List<SearchPassenger> passengers;

  factory SearchPassengerResponse.fromJson(List json) => SearchPassengerResponse(
        passengers: List<SearchPassenger>.from(
            json.map((x) => SearchPassenger.fromJson(x))),
      );
}

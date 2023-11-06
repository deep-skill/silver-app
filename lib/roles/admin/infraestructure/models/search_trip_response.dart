import 'package:silverapp/roles/admin/infraestructure/entities/trip_list.dart';

class SearchTripResponse {
  SearchTripResponse({
    required this.trips,
  });

  final List<TripList> trips;

  factory SearchTripResponse.fromJson(List json) => SearchTripResponse(
        trips: List<TripList>.from(json.map((x) => TripList.fromJson(x))),
      );
}

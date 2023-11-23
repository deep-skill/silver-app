import 'package:silverapp/roles/driver/infraestructure/entities/driver_trip_list.dart';

class SearchDriverTripResponse {
  SearchDriverTripResponse({
    required this.trips,
  });

  final List<DriverTripList> trips;

  factory SearchDriverTripResponse.fromJson(List json) =>
      SearchDriverTripResponse(
        trips: List<DriverTripList>.from(
            json.map((x) => DriverTripList.fromJson(x))),
      );
}

class TripsSummaryDriverResponse {
  TripsSummaryDriverResponse({
    required this.trips,
    required this.revenue,
  });

  final int trips;
  final double revenue;

  factory TripsSummaryDriverResponse.fromJson(Map<String, dynamic> json) =>
      TripsSummaryDriverResponse(
        trips: json["trips"],
        revenue: json["revenue"].toDouble(),
      );
}

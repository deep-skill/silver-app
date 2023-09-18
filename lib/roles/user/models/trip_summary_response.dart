class TripsSummaryResponse {
  TripsSummaryResponse({
    required this.trips,
    required this.income,
    required this.revenue,
  });

  final int trips;
  final double income;
  final double revenue;

  factory TripsSummaryResponse.fromJson(Map<String, dynamic> json) =>
      TripsSummaryResponse(
        trips: json["trips"],
        income: json["income"].toDouble(),
        revenue: json["revenue"].toDouble(),
      );
}

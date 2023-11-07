class SearchDriver {
  final int id;
  final String name;
  final String lastName;
  final int? carId;
  final String? licensePlate;
  final String? brand;
  final String? model;
  final String? color;

  SearchDriver({
    required this.id,
    required this.name,
    required this.lastName,
    this.carId,
    this.licensePlate,
    this.brand,
    this.model,
    this.color,
  });
  factory SearchDriver.fromJson(Map<String, dynamic> json) =>
      SearchDriver(
        id: json['id'],
        name: json['name'],
        lastName: json['lastName'],
        carId: json['Car'] == null ? null : json['Car']['id'],
        licensePlate: json['Car'] == null ? null : json['Car']['licensePlate'],
        brand: json['Car'] == null ? null : json['Car']['brand'],
        model: json['Car'] == null ? null : json['Car']['model'],
        color: json['Car'] == null ? null : json['Car']['color'],
      );
}

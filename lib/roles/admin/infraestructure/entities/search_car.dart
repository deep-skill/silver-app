class SearchCar {
  final int id;
  final String licensePlate;
  final String brand;
  final String model;
  final String color;

  SearchCar({
    required this.id,
    required this.licensePlate,
    required this.brand,
    required this.model,
    required this.color,
  });
  factory SearchCar.fromJson(Map<String, dynamic> json) =>
      SearchCar(
        id: json['id'],
        licensePlate: json['licensePlate'],
        brand: json['brand'],
        model: json['model'],
        color: json['color'],
      );
}

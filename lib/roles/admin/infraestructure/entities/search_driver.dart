class SearchDriver {
  final int id;
  final String name;
  final String lastName;

  SearchDriver({
    required this.id,
    required this.name,
    required this.lastName,
  });
  factory SearchDriver.fromJson(Map<String, dynamic> json) =>
      SearchDriver(
        id: json['id'],
        name: json['name'],
        lastName: json['lastName'],
      );
}

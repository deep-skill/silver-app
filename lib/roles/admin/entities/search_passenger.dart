class SearchPassenger {
  final int id;
  final String name;
  final String lastName;

  SearchPassenger({
    required this.id,
    required this.name,
    required this.lastName,
  });
  factory SearchPassenger.fromJson(Map<String, dynamic> json) =>
      SearchPassenger(
        id: json['id'],
        name: json['name'],
        lastName: json['lastName'],
      );
}

class SearchPassenger {
  final int id;
  final String name;
  final String lastName;
  final int? enterpriseId;

  SearchPassenger({
    required this.id,
    required this.name,
    required this.lastName,
    this.enterpriseId,
  });
  factory SearchPassenger.fromJson(Map<String, dynamic> json) =>
      SearchPassenger(
        id: json['id'],
        name: json['name'],
        lastName: json['lastName'],
        enterpriseId: json['Enterprise'] == null ? null : json['Enterprise']['id'],
      );
}

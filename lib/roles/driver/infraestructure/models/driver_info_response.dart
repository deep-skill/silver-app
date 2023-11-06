class DriverInfoResponse {
  DriverInfoResponse({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
  });

  final int id;
  final String name;
  final String lastName;
  final String email;

  factory DriverInfoResponse.fromJson(Map<String, dynamic> json) =>
      DriverInfoResponse(
        id: json["id"],
        name: json["name"],
        lastName: json["lastName"],
        email: json["email"],
      );
}
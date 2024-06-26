import 'dart:convert';

GoogleRoutes googleRoutesFromJson(String str) =>
    GoogleRoutes.fromJson(json.decode(str));

String googleRoutesToJson(GoogleRoutes data) => json.encode(data.toJson());

class GoogleRoutes {
  List<Route> routes;

  GoogleRoutes({
    required this.routes,
  });

  factory GoogleRoutes.fromJson(Map<String, dynamic> json) => GoogleRoutes(
        routes: List<Route>.from(json["routes"].map((x) => Route.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "routes": List<dynamic>.from(routes.map((x) => x.toJson())),
      };
}

class Route {
  int distanceMeters;
  String duration;
  String polyline;

  Route({
    required this.distanceMeters,
    required this.duration,
    required this.polyline,
  });

  factory Route.fromJson(Map<String, dynamic> json) => Route(
      distanceMeters: json["distanceMeters"],
      duration: json["duration"],
      polyline: json["polyline"]["encodedPolyline"]);

  Map<String, dynamic> toJson() => {
        "distanceMeters": distanceMeters,
        "duration": duration,
        "polyline": polyline,
      };
  int getDurationInSeconds() {
    final secondsString = RegExp(r'\d+').firstMatch(duration)?.group(0);
    return secondsString != null ? int.parse(secondsString) : 0;
  }
}

class Polyline {
  String encodedPolyline;

  Polyline({
    required this.encodedPolyline,
  });

  factory Polyline.fromJson(Map<String, dynamic> json) => Polyline(
        encodedPolyline: json["encodedPolyline"],
      );

  Map<String, dynamic> toJson() => {
        "encodedPolyline": encodedPolyline,
      };
}

class ResponseRoute {
  int distance;
  int time;
  String encodedPolyline;
  ResponseRoute(
      {required this.distance,
      required this.time,
      required this.encodedPolyline});
}

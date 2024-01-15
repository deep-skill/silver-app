import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:silverapp/google_maps/location_data.dart';

class MapGoogle extends StatefulWidget {
  const MapGoogle({super.key});

  @override
  State<MapGoogle> createState() => MapGoogleState();
}

class MapGoogleState extends State<MapGoogle> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final TextEditingController _searchController = TextEditingController();
  Set<Marker> _markers = {};
  List<dynamic> searchResults = [];
  String? selectedLocation;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-12.04967738829701, -77.09668506723912),
    zoom: 14.4746,
  );

  Future<void> _searchAndNavigate(String address) async {
    try {
      var response = await Dio().get(
        'https://maps.googleapis.com/maps/api/geocode/json',
        queryParameters: {
          'address': address,
          'components': 'locality:Lima|country:PE',
          'key': 'AIzaSyAA6KXYXkm6KJ84V1apLQguQKXBoKx0NtE',
        },
      );
      if (response.statusCode == 200 && response.data['results'].length > 0) {
        setState(() {
          searchResults = response.data['results'];
        });
        _showSearchResults();
      }
    } catch (e) {
      print(e);
    }
  }

  void _showSearchResults() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Seleccione una Ubicación"),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: searchResults.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(searchResults[index]['formatted_address']),
                  onTap: () {
                    Navigator.of(context).pop();
                    double lat =
                        searchResults[index]['geometry']['location']['lat'];
                    double lng =
                        searchResults[index]['geometry']['location']['lng'];
                    String addressName =
                        searchResults[index]['formatted_address'];
                    LatLng location = LatLng(lat, lng);
                    _updateMapLocation(location, addressName);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _updateMapLocation(LatLng location, String addressName) {
    setState(() {
      selectedLocation =
          '${location.latitude}, ${location.longitude}, $addressName';
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId(location.toString()),
          position: location,
          infoWindow: InfoWindow(
            title: 'Ubicación Seleccionada',
            snippet: addressName,
          ),
        ),
      );
    });
    _controller.future.then((controller) =>
        controller.animateCamera(CameraUpdate.newLatLng(location)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Ingrese una dirección',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchAndNavigate(_searchController.text),
                ),
              ),
            ),
          ),
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              markers: _markers,
              onMapCreated: (controller) => _controller.complete(controller),
            ),
          ),
          ElevatedButton(
            onPressed: selectedLocation != null
                ? () {
                    List<String> locationParts = selectedLocation!.split(', ');
                    double lat = double.parse(locationParts[0]);
                    double lng = double.parse(locationParts[1]);
                    String address = locationParts.sublist(2).join(', ');

                    Navigator.of(context).pop(LocationData(
                      latitude: lat,
                      longitude: lng,
                      address: address,
                    ));
                  }
                : null,
            child: const Text('Confirmar Ubicación'),
          ),
        ],
      ),
    );
  }
}

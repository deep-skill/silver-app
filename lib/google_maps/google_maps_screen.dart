import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:silverapp/env/env.dart';
import 'package:silverapp/google_maps/location_data.dart';
import 'package:silverapp/position/determine_position_helper.dart';

class MapGoogle extends StatefulWidget {
  const MapGoogle({super.key});

  @override
  State<MapGoogle> createState() => MapGoogleState();
}

class MapGoogleState extends State<MapGoogle> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final TextEditingController _searchController = TextEditingController();
  final Set<Marker> _markers = {};
  List<dynamic> searchResults = [];
  String? selectedLocation;
  bool showSearchResults = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        setState(() {
          showSearchResults = false;
          searchResults = [];
        });
      }
      _searchAndNavigate(_searchController.text);
    });
    if (!kIsWeb) _initMapLocation();
    if (kIsWeb) setState(() => loading = false);
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-12.04967738829701, -77.09668506723912),
    zoom: kIsWeb ? 17.0 : 15.00,
  );

  Future<void> _searchAndNavigate(String address) async {
    if (address.isNotEmpty) {
      try {
        var response = await Dio().get(
          'https://maps.googleapis.com/maps/api/geocode/json',
          queryParameters: {
            'address': address,
            'components': 'locality:Lima|country:PE',
            'key': kIsWeb ? Env.webApi : Env.androidApi,
          },
        );
        if (response.statusCode == 200 && response.data['results'].length > 0) {
          setState(() {
            searchResults = response.data['results'];
            showSearchResults = true;
          });
        }
      } catch (e) {
        print(e);
      }
    } else {
      setState(() {
        searchResults = [];
        showSearchResults = false;
      });
    }
  }

  void _initMapLocation() async {
    Position initialPosition = await determinePosition();
    LatLng location =
        LatLng(initialPosition.latitude, initialPosition.longitude);
    String? addressName;
    try {
      var response = await Dio().get(
        'https://maps.googleapis.com/maps/api/geocode/json',
        queryParameters: {
          'latlng': '${location.latitude}, ${location.longitude}',
          'key': kIsWeb ? Env.webApi : Env.androidApi,
        },
      );

      if (response.statusCode == 200 && response.data['results'].length > 0) {
        addressName = response.data['results'][0]['formatted_address'];
      } else {
        addressName = 'Ubicación tomada por defecto';
      }
    } catch (e) {
      print(e);
    }

    setState(() {
      showSearchResults = true;
      selectedLocation =
          '${initialPosition.latitude}, ${initialPosition.longitude}, $addressName';
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId(location.toString()),
          position: location,
          infoWindow: const InfoWindow(
            title: 'Ubicación Seleccionada',
            snippet: 'Ubicación actual',
          ),
        ),
      );
      loading = false;
    });
    _controller.future.then((controller) =>
        controller.animateCamera(CameraUpdate.newLatLng(location)));
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
      body: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xffFFFFFF),
        ),
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              markers: _markers,
              onMapCreated: (controller) => _controller.complete(controller),
            ),
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(4.0),
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Color(0xffFFFFFF),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Ingrese una dirección',
                        contentPadding: EdgeInsets.all(5),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (showSearchResults)
                  Container(
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    height: searchResults.isNotEmpty
                        ? (searchResults.length * 50.0)
                        : 0,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: searchResults.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                searchResults[index]['formatted_address'],
                                style: const TextStyle(
                                    fontFamily: "Monserrat",
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                          onTap: () {
                            double lat = searchResults[index]['geometry']
                                ['location']['lat'];
                            double lng = searchResults[index]['geometry']
                                ['location']['lng'];
                            String addressName =
                                searchResults[index]['formatted_address'];
                            LatLng location = LatLng(lat, lng);
                            _updateMapLocation(location, addressName);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Ubicación: $addressName',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            );
                            setState(() {
                              showSearchResults = false;
                              _searchController.text = "";
                            });
                          },
                        );
                      },
                    ),
                  ),
                const Spacer(),
                if (selectedLocation != null)
                  Container(
                    margin: const EdgeInsets.all(35.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(5)),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF031329)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      onPressed: selectedLocation != null
                          ? () {
                              List<String> locationParts =
                                  selectedLocation!.split(', ');
                              double lat = double.parse(locationParts[0]);
                              double lng = double.parse(locationParts[1]);
                              String address =
                                  locationParts.sublist(2).join(', ');

                              Navigator.of(context).pop(LocationData(
                                latitude: lat,
                                longitude: lng,
                                address: address,
                              ));
                            }
                          : null,
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        padding: const EdgeInsets.all(2),
                        child: const Text('Confirmar Ubicación',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: "Monserrat")),
                      ),
                    ),
                  )
                else
                  const SizedBox(),
              ],
            ),
            loading
                ? Positioned(
                    top: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffFFFFFF).withOpacity(0.6),
                      ),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF031329),
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/trip_list.dart';
import 'package:silverapp/roles/admin/presentation/widgets/slides/admin_trip_slide_app.dart';
import 'package:silverapp/roles/admin/presentation/widgets/slides/admin_trip_slide_web.dart';

typedef SearchTripsCallback = Future<List<TripList>> Function(String query);

class SearchTripDelegate extends SearchDelegate<TripList?> {
  final SearchTripsCallback searchTrips;
  List<TripList> initialTrips;
  StreamController<List<TripList>> debouncedTrips =
      StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  //Timeout
  Timer? _debouceTimer;

  SearchTripDelegate({
    required this.searchTrips,
    required this.initialTrips,
  });

  void clearStreams() {
    _debouceTimer!.cancel();
    debouncedTrips.close();
  }

  void _onQueryChanged(String query) {
    isLoadingStream.add(true);

    if (_debouceTimer?.isActive ?? false) _debouceTimer!.cancel();
    _debouceTimer = Timer(const Duration(milliseconds: 800), () async {
      final trips = await searchTrips(query);
      initialTrips = trips;
      if (debouncedTrips.isClosed) return;
      debouncedTrips.add(trips);
      isLoadingStream.add(false);
    });
  }

  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
      initialData: initialTrips,
      stream: debouncedTrips.stream,
      builder: (context, snapshot) {
        final trips = snapshot.data ?? [];
        return kIsWeb
            ? Container(
                height: 1000,
                decoration: const BoxDecoration(
                  color: Color(0xffF2F3F7),
                ),
                child: GridView.count(
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 40,
                    childAspectRatio: MediaQuery.of(context).size.width < 1400
                        ? (400 / 150)
                        : (500 / 200),
                    shrinkWrap: true,
                    crossAxisCount:
                        MediaQuery.of(context).size.width < 1400 ? 2 : 3,
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 20),
                    children: List.generate(trips.length, (index) {
                      return _TripItem(
                        trip: trips[index],
                        onTripSelected: (context, trip) {
                          clearStreams();
                          close(context, trip);
                        },
                      );
                    })),
              )
            : ListView.builder(
                itemCount: trips.length,
                itemBuilder: (context, index) {
                  final trip = trips[index];
                  return _TripItem(
                    trip: trip,
                    onTripSelected: (context, trip) {
                      clearStreams();
                      close(context, trip);
                    },
                  );
                },
              );
      },
    );
  }

  @override
  String get searchFieldLabel => 'Buscar Viaje';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(12.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return SpinPerfect(
              duration: const Duration(seconds: 20),
              spins: 10,
              infinite: true,
              child: IconButton(
                onPressed: () => query = '',
                icon: const Icon(Icons.refresh_rounded),
              ),
            );
          }
          return FadeIn(
            animate: query.isNotEmpty,
            duration: const Duration(milliseconds: 200),
            child: IconButton(
              onPressed: () {
                query = '';
              },
              icon: const Icon(Icons.cancel_outlined),
            ),
          );
        },
      ),
      Image.asset(
        'assets/images/silver-logo_white_font-color.png',
        color: const Color(0xFF03132A),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        clearStreams();
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    return buildResultsAndSuggestions();
  }
}

class _TripItem extends StatelessWidget {
  const _TripItem({
    required this.trip,
    required this.onTripSelected,
  });
  final TripList trip;
  final Function onTripSelected;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: kIsWeb
          ? AdminTripSlideWeb(trip: trip)
          : AdminTripSlideApp(trip: trip),
    );
  }
}

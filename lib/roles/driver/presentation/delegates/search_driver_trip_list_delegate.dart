import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_trip_list.dart';
import 'package:silverapp/roles/driver/presentation/widgets/driver_trips_list/driver_custom_trip_slide.dart';

typedef SearchTripsCallback = Future<List<DriverTripList>> Function(
    String query);

class SearchDriverTripDelegate extends SearchDelegate<DriverTripList?> {
  final SearchTripsCallback searchTrips;
  List<DriverTripList> initialTrips;
  StreamController<List<DriverTripList>> debouncedTrips =
      StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  Timer? _debouceTimer;

  SearchDriverTripDelegate({
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
        return ListView.builder(
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
  final DriverTripList trip;
  final Function onTripSelected;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTripSelected(context, trip);
        //context.push('/admin/reserves/detail/${trip.id}');
      },
      child: CustomTripSlide(
        trip: trip,
      ),
    );
  }
}

import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/search_passenger.dart';

typedef SearchPassengersCallback = Future<List<SearchPassenger>> Function(
    String query);

class SearchPassengerDelegate extends SearchDelegate<SearchPassenger?> {
  final SearchPassengersCallback searchPassengers;
  final Function callback;
  List<SearchPassenger> initialPassengers;
  StreamController<List<SearchPassenger>> debouncedPassengers =
      StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  //Timeout
  Timer? _debouceTimer;

  SearchPassengerDelegate(
      {required this.searchPassengers,
      required this.initialPassengers,
      required this.callback});

  void clearStreams() {
    _debouceTimer!.cancel();
    debouncedPassengers.close();
  }

  void _onQueryChanged(String query) {
    isLoadingStream.add(true);

    if (_debouceTimer?.isActive ?? false) _debouceTimer!.cancel();
    _debouceTimer = Timer(const Duration(milliseconds: 800), () async {
      final passengers = await searchPassengers(query);
      initialPassengers = passengers;
      if (debouncedPassengers.isClosed) return;
      debouncedPassengers.add(passengers);
      isLoadingStream.add(false);
    });
  }

  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
      initialData: initialPassengers,
      stream: debouncedPassengers.stream,
      builder: (context, snapshot) {
        final passengers = snapshot.data ?? [];
        return ListView.builder(
          itemCount: passengers.length,
          itemBuilder: (context, index) {
            final passenger = passengers[index];
            return _PassengerItem(
              callback: callback,
              passenger: passenger,
              onPassengerSelected: (context, passenger) {
                clearStreams();
                close(context, passenger);
              },
            );
          },
        );
      },
    );
  }

  @override
  String get searchFieldLabel => 'Buscar Pasajero';

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
        callback(0, 'Ejem. Carla', 'Peña Ramirez', null);
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

class _PassengerItem extends StatelessWidget {
  const _PassengerItem(
      {required this.passenger,
      required this.onPassengerSelected,
      required this.callback});
  final SearchPassenger passenger;
  final Function onPassengerSelected;
  final Function callback;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPassengerSelected(context, passenger);
        callback(passenger.id, passenger.name, passenger.lastName,
            passenger.enterpriseId);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text('${passenger.name} ${passenger.lastName}'),
      ),
    );
  }
}

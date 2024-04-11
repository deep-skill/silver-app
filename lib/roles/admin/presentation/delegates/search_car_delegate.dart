import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/search_car.dart';

typedef SearchCarsCallback = Future<List<SearchCar>> Function(String query);

class SearchCarDelegate extends SearchDelegate<SearchCar?> {
  final SearchCarsCallback searchCars;
  final Function callback;
  List<SearchCar> initialCars;
  StreamController<List<SearchCar>> debouncedCars =
      StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  //Timeout
  Timer? _debouceTimer;

  SearchCarDelegate(
      {required this.searchCars,
      required this.initialCars,
      required this.callback});

  void clearStreams() {
    _debouceTimer!.cancel();
    debouncedCars.close();
  }

  void _onQueryChanged(String query) {
    isLoadingStream.add(true);

    if (_debouceTimer?.isActive ?? false) _debouceTimer!.cancel();
    _debouceTimer = Timer(const Duration(milliseconds: 800), () async {
      final cars = await searchCars(query);
      initialCars = cars;
      if (debouncedCars.isClosed) return;
      debouncedCars.add(cars);
      isLoadingStream.add(false);
    });
  }

  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
      initialData: initialCars,
      stream: debouncedCars.stream,
      builder: (context, snapshot) {
        final cars = snapshot.data ?? [];
        return ListView.builder(
          itemCount: cars.length,
          itemBuilder: (context, index) {
            final car = cars[index];
            return _CarItem(
              callback: callback,
              car: car,
              onCarSelected: (context, car) {
                clearStreams();
                close(context, car);
              },
            );
          },
        );
      },
    );
  }

  @override
  String get searchFieldLabel => 'Buscar vehículo';

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
        callback(0, 'Ejem. Toyota', 'Corolla', 'Gris', 'A1R610');
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

class _CarItem extends StatelessWidget {
  const _CarItem(
      {required this.car, required this.onCarSelected, required this.callback});
  final SearchCar car;
  final Function onCarSelected;
  final Function callback;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onCarSelected(context, car);
        callback(
          car.id,
          car.brand,
          car.model,
          car.color,
          car.licensePlate,
        );
      },
      style: ElevatedButton.styleFrom(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        foregroundColor: Colors.black,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child:
            Text('${car.licensePlate} ${car.brand} ${car.model} ${car.color}'),
      ),
    );
  }
}

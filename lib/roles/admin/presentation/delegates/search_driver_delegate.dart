import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/search_driver.dart';

typedef SearchDriversCallback = Future<List<SearchDriver>> Function(
    String query);

class SearchDriverDelegate extends SearchDelegate<SearchDriver?> {
  final SearchDriversCallback searchDrivers;
  final Function callback;
  List<SearchDriver> initialDrivers;
  StreamController<List<SearchDriver>> debouncedDrivers =
      StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  //Timeout
  Timer? _debouceTimer;

  SearchDriverDelegate(
      {required this.searchDrivers,
      required this.initialDrivers,
      required this.callback});

  void clearStreams() {
    _debouceTimer!.cancel();
    debouncedDrivers.close();
  }

  void _onQueryChanged(String query) {
    isLoadingStream.add(true);

    if (_debouceTimer?.isActive ?? false) _debouceTimer!.cancel();
    _debouceTimer = Timer(const Duration(milliseconds: 800), () async {
      final drivers = await searchDrivers(query);
      initialDrivers = drivers;
      if (debouncedDrivers.isClosed) return;
      debouncedDrivers.add(drivers);
      isLoadingStream.add(false);
    });
  }

  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
      initialData: initialDrivers,
      stream: debouncedDrivers.stream,
      builder: (context, snapshot) {
        final drivers = snapshot.data ?? [];
        return ListView.builder(
          itemCount: drivers.length,
          itemBuilder: (context, index) {
            final driver = drivers[index];
            return _DriverItem(
              callback: callback,
              driver: driver,
              onDriverSelected: (context, driver) {
                clearStreams();
                close(context, driver);
              },
            );
          },
        );
      },
    );
  }

  @override
  String get searchFieldLabel => 'Buscar Conductor';

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
        callback(0, 'Ejem. Luis', 'Perez');
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

class _DriverItem extends StatelessWidget {
  const _DriverItem(
      {required this.driver,
      required this.onDriverSelected,
      required this.callback});
  final SearchDriver driver;
  final Function onDriverSelected;
  final Function callback;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onDriverSelected(context, driver);
        callback(driver.id, driver.name, driver.lastName);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text('${driver.name} ${driver.lastName}'),
      ),
    );
  }
}

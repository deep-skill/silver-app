import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/reserve_list.dart';
import 'package:silverapp/roles/admin/presentation/widgets/custom_slide.dart';

typedef SearchReservesCallback = Future<List<ReserveList>> Function(
    String query);

class SearchReserveDelegate extends SearchDelegate<ReserveList?> {
  final SearchReservesCallback searchReserves;
  List<ReserveList> initialReserves;
  StreamController<List<ReserveList>> debouncedReserves =
      StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  //Timeout
  Timer? _debouceTimer;

  SearchReserveDelegate({
    required this.searchReserves,
    required this.initialReserves,
  });

  void clearStreams() {
    _debouceTimer!.cancel();
    debouncedReserves.close();
  }

  void _onQueryChanged(String query) {
    isLoadingStream.add(true);

    if (_debouceTimer?.isActive ?? false) _debouceTimer!.cancel();
    _debouceTimer = Timer(const Duration(milliseconds: 800), () async {
      final reserves = await searchReserves(query);
      initialReserves = reserves;
      if (debouncedReserves.isClosed) return;
      debouncedReserves.add(reserves);
      isLoadingStream.add(false);
    });
  }

  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
      initialData: initialReserves,
      stream: debouncedReserves.stream,
      builder: (context, snapshot) {
        final reserves = snapshot.data ?? [];
        return ListView.builder(
          itemCount: reserves.length,
          itemBuilder: (context, index) {
            final reserve = reserves[index];
            return _ReserveItem(
              reserve: reserve,
              onReserveSelected: (context, reserve) {
                clearStreams();
                close(context, reserve);
              },
            );
          },
        );
      },
    );
  }

  @override
  String get searchFieldLabel => 'Buscar Reserva';

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

class _ReserveItem extends StatelessWidget {
  const _ReserveItem({
    required this.reserve,
    required this.onReserveSelected,
  });
  final ReserveList reserve;
  final Function onReserveSelected;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:8.0),
      child: ElevatedButton(
        onPressed: () {
          onReserveSelected(context, reserve);
          context.push('/admin/reserves/detail/${reserve.id}');
        },
          style: ElevatedButton.styleFrom(
             padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            foregroundColor: Colors.black,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        child: CustomSlide(reserve: reserve),
      ),
    );
  }
}

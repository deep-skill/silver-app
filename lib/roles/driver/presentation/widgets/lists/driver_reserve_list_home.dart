import 'package:flutter/material.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_reserve_home.dart';
import 'package:silverapp/roles/driver/presentation/widgets/slides/driver_custom_slide_home_list.dart';

class DriverReservesListHome extends StatefulWidget {
  const DriverReservesListHome(
      {super.key, required this.reserves, required this.loadNextPage});

  final List<DriverReserveHome> reserves;
  final VoidCallback? loadNextPage;

  @override
  State<DriverReservesListHome> createState() => _DriverReservesListHomeState();
}

class _DriverReservesListHomeState extends State<DriverReservesListHome> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;
      if (scrollController.position.pixels + 1 >=
          scrollController.position.maxScrollExtent) {
        widget.loadNextPage!();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    // isMounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: widget.reserves.isEmpty
          ? const Text('No hay reservas del día')
          : ListView.builder(
              controller: scrollController,
              itemCount: widget.reserves.length,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (contex, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DriverCustomSlideHomeList(reserve: widget.reserves[index]),
                );
              },
            ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_reserve_list.dart';
import 'package:silverapp/roles/driver/presentation/widgets/driver_custom_slide.dart';

class DriverReservesList extends StatefulWidget {
  const DriverReservesList(
      {super.key, required this.reserves, required this.loadNextPage});

  final List<DriverReserveList> reserves;
  final VoidCallback? loadNextPage;

  @override
  State<DriverReservesList> createState() => _ReservesListState();
}

class _ReservesListState extends State<DriverReservesList> {
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
      child: ListView.builder(
        controller: scrollController,
        itemCount: widget.reserves.length,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (contex, index) {
          return DriverCustomSlide(reserve: widget.reserves[index], isNearest: false,);
        },
      ),
    );
  }
}

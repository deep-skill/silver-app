import 'package:flutter/material.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_trip_list.dart';
import 'package:silverapp/roles/driver/presentation/widgets/driver_trips_list/box_list_trip.dart';

class DriverTripsList extends StatefulWidget {
  const DriverTripsList(
      {super.key, required this.trips, required this.loadNextPage});

  final List<DriverTripList> trips;
  final VoidCallback? loadNextPage;
  @override
  State<DriverTripsList> createState() => _TripsListState();
}

class _TripsListState extends State<DriverTripsList> {
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
    final trip = widget.trips;

    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        itemCount: widget.trips.length,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (contex, index) {
          return BoxTripList(
            trip: trip[index],
          );
        },
      ),
    );
  }
}

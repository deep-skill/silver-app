import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/trip_list.dart';
import 'package:silverapp/roles/admin/presentation/widgets/slides/admin_trip_slide_app.dart';
import 'package:silverapp/roles/admin/presentation/widgets/slides/admin_trip_slide_web.dart';

class TripsListTripScreen extends StatefulWidget {
  const TripsListTripScreen(
      {super.key, required this.trips, required this.loadNextPage});

  final List<TripList> trips;
  final VoidCallback? loadNextPage;

  @override
  State<TripsListTripScreen> createState() => _TripsListState();
}

class _TripsListState extends State<TripsListTripScreen> {
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
    return kIsWeb
        ? Expanded(
            child: GridView.count(
            mainAxisSpacing: 5,
            crossAxisSpacing: 40,
            childAspectRatio: 3.2,
            shrinkWrap: true,
            crossAxisCount: 2,
            controller: scrollController,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            children: List.generate(widget.trips.length, (index) {
              return AdminTripSlideWeb(trip: widget.trips[index]);
            }),
          ))
        : Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.trips.length,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (contex, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: AdminTripSlideApp(trip: widget.trips[index]),
                );
              },
            ),
          );
  }
}

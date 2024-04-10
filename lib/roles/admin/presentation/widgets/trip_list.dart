import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/trip_list.dart';
import 'package:silverapp/roles/admin/presentation/widgets/trip_slide.dart';
import 'package:silverapp/roles/admin/presentation/widgets/trip_slide_web.dart';

class TripsList extends StatefulWidget {
  const TripsList({super.key, required this.trips, required this.loadNextPage});

  final List<TripList> trips;
  final VoidCallback? loadNextPage;

  @override
  State<TripsList> createState() => _TripsListState();
}

class _TripsListState extends State<TripsList> {
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
              return ElevatedButton(
                  onPressed: () => context
                      .push('/admin/trips/detail/${widget.trips[index].id}'),
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    foregroundColor: Colors.black,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  child: TripSlideWeb(trip: widget.trips[index]));
            }),
          ))
        : Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.trips.length,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (contex, index) {
                return TripSlide(trip: widget.trips[index]);
              },
            ),
          );
  }
}

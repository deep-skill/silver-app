import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/reserve_list.dart';
import 'package:silverapp/roles/admin/presentation/widgets/slides/admin_reserves_slide_app.dart';
import 'package:silverapp/roles/admin/presentation/widgets/slides/admin_reserves_slide_web.dart';

class ReservesListReserveScreen extends StatefulWidget {
  const ReservesListReserveScreen(
      {super.key, required this.reserves, required this.loadNextPage});

  final List<ReserveList> reserves;
  final VoidCallback? loadNextPage;

  @override
  State<ReservesListReserveScreen> createState() => _ReservesListState();
}

class _ReservesListState extends State<ReservesListReserveScreen> {
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
            children: List.generate(widget.reserves.length, (index) {
              return AdminReservesSlideWeb(reserve: widget.reserves[index]);
            }),
          ))
        : Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.reserves.length,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (contex, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: AdminReservesSlideApp(reserve: widget.reserves[index]),
                );
              },
            ),
          );
  }
}

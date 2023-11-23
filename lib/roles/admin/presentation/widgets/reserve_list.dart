import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/reserve_list.dart';
import 'package:silverapp/roles/admin/presentation/widgets/custom_slide.dart';
import 'package:silverapp/roles/admin/presentation/widgets/custom_slide_web.dart';

class ReservesList extends StatefulWidget {
  const ReservesList(
      {super.key, required this.reserves, required this.loadNextPage});

  final List<ReserveList> reserves;
  final VoidCallback? loadNextPage;

  @override
  State<ReservesList> createState() => _ReservesListState();
}

class _ReservesListState extends State<ReservesList> {
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
            childAspectRatio: 5.1,
            shrinkWrap: true,
            crossAxisCount: 2,
            controller: scrollController,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            children: List.generate(widget.reserves.length, (index) {
              return SlideWeb(reserve: widget.reserves[index]);
            }),
          ))
        : Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.reserves.length,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (contex, index) {
                return CustomSlide(reserve: widget.reserves[index]);
              },
            ),
          );
  }
}

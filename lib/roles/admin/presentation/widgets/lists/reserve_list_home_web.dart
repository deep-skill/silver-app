import 'package:flutter/material.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/reserve_home.dart';
import 'package:silverapp/roles/admin/presentation/widgets/slides/admin_home_slide_web.dart';

class ReservesListHomeWeb extends StatefulWidget {
  const ReservesListHomeWeb(
      {super.key,
      required this.reserves,
      required this.loadNextPage,
      required this.size});

  final List<ReserveHome> reserves;
  final VoidCallback? loadNextPage;
  final Size size;

  @override
  State<ReservesListHomeWeb> createState() => _ReservesListHomeWebState();
}

class _ReservesListHomeWebState extends State<ReservesListHomeWeb> {
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
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.size.width * .1),
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
          return AdminHomeSlideWeb(reserve: widget.reserves[index]);
        }),
      ),
    ));
  }
}

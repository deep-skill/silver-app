import 'package:flutter/material.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/reserve_home.dart';
import 'package:silverapp/roles/admin/presentation/widgets/slides/admin_home_slide_app.dart';

class ReservesListHomeApp extends StatefulWidget {
  const ReservesListHomeApp(
      {super.key, required this.reserves, required this.loadNextPage});

  final List<ReserveHome> reserves;
  final VoidCallback? loadNextPage;

  @override
  State<ReservesListHomeApp> createState() => _ReservesListHomeState();
}

class _ReservesListHomeState extends State<ReservesListHomeApp> {
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
          ? const Text('No hay reservas')
          : ListView.builder(
              controller: scrollController,
              itemCount: widget.reserves.length,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (contex, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: AdminHomeSlideApp(reserve: widget.reserves[index]),
                );
              },
            ),
    );
  }
}

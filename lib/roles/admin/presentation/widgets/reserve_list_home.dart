import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/reserve_home.dart';

class ReservesListHome extends StatefulWidget {
  const ReservesListHome(
      {super.key, required this.reserves, required this.loadNextPage});

  final List<ReserveHome> reserves;
  final VoidCallback? loadNextPage;

  @override
  State<ReservesListHome> createState() => _ReservesListHomeState();
}

class _ReservesListHomeState extends State<ReservesListHome> {
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
                return _Slide(reserve: widget.reserves[index]);
              },
            ),
    );
  }
}

class _Slide extends StatelessWidget {
  final ReserveHome reserve;
  const _Slide({required this.reserve});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const months = [
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dec'
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: size.height * .16,
        decoration: BoxDecoration(
          color: const Color(0xffFFFFFF),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: 120,
                decoration: const BoxDecoration(
                  color: Color(0xffF2F3F7),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: const Center(
                    child: Text(
                  'Sin conductor',
                  style:
                      TextStyle(fontSize: 12, fontFamily: 'Montserrat-Regular'),
                ))),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.hail,
                        size: 20,
                      ),
                      Text(
                        '${reserve.name} ${reserve.lastName}',
                        style: const TextStyle(
                            fontSize: 17, fontFamily: 'Montserrat-Bold'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  Row(
                    children: [
                      const Icon(
                        Icons.account_balance_outlined,
                        size: 20,
                      ),
                      Text(
                        ' ${reserve.entrepriseName}',
                        style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Montserrat-Medium',
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.event_available_outlined,
                        size: 20,
                      ),
                      Text(
                        ' ${reserve.startTime.day} ${months[reserve.startTime.month - 1]} ${reserve.startTime.year} | ${reserve.startTime.hour}:${reserve.startTime.minute}',
                        style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Montserrat-Medium',
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.timeline,
                        size: 20,
                      ),
                      Text(
                        ' ${reserve.tripType[0].toUpperCase()}${reserve.tripType.substring(1).toLowerCase()}',
                        style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Montserrat-Medium',
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => context.push('/admin/reserves/detail/${reserve.id}'),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

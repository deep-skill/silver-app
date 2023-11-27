import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_reserve_home.dart';

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
                return _Slide(reserve: widget.reserves[index]);
              },
            ),
    );
  }
}

class _Slide extends StatelessWidget {
  final DriverReserveHome reserve;
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
        height: size.height * .13,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              blurRadius: 4,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                width: size.width * .30,
                decoration: const BoxDecoration(
                  color: Color(0xffF2F3F7),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: const Center(
                    child: Text(
                  'Sin conductor',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ))),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: size.width * .5,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.hail,
                          size: 20,
                        ),
                        Text(
                          '${reserve.name} ${reserve.lastName}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'Montserrat-Bold',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: size.width * .5,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.account_balance_outlined,
                          size: 20,
                        ),
                        Text(
                          ' ${reserve.entrepriseName}',
                          style: const TextStyle(
                              fontSize: 12, fontFamily: 'Montserrat-Medium'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: size.width * .5,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.event_available_outlined,
                          size: 20,
                        ),
                        Text(
                          ' ${reserve.startTime.day} ${months[reserve.startTime.month - 1]} ${reserve.startTime.year} | ${reserve.startTime.hour}:${reserve.startTime.minute}',
                          style: const TextStyle(
                              fontSize: 12, fontFamily: 'Montserrat-Medium'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () =>
                  context.push('/driver/reserves/detail/${reserve.id}'),
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

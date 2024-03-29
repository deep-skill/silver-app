import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/reserve_home.dart';

class ReservesListHomeWeb extends StatefulWidget {
  const ReservesListHomeWeb(
      {super.key, required this.reserves, required this.loadNextPage});

  final List<ReserveHome> reserves;
  final VoidCallback? loadNextPage;

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
        return _Slide(reserve: widget.reserves[index]);
      }),
    ));
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
        decoration: BoxDecoration(
          color: const Color(0xffFFFFFF),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 10,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: size.width * .10,
                decoration: const BoxDecoration(
                  color: Color(0xffF2F3F7),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: const Center(
                    child: Text(
                  'Sin conductor',
                  style: TextStyle(
                    fontFamily: 'Montserrat-Regular',
                    fontSize: 12,
                  ),
                ))),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                  SizedBox(
                    width: size.width * .1,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.account_balance_outlined,
                          size: 20,
                        ),
                        Expanded(
                          child: Text(
                            ' ${reserve.entrepriseName}',
                            style: const TextStyle(
                                fontFamily: 'Montserrat-Medium',
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.event_available_outlined,
                        size: 20,
                      ),
                      Text(
                        ' ${reserve.startTime.day} ${months[reserve.startTime.month - 1]} ${reserve.startTime.year} | ${reserve.startTime.hour}:${reserve.startTime.minute}',
                        style: const TextStyle(
                            fontFamily: 'Montserrat-Medium',
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.timeline,
                        size: 20,
                      ),
                      Text(
                        ' ${reserve.tripType[0].toUpperCase()}${reserve.tripType.substring(1).toLowerCase()}',
                        style: const TextStyle(
                            fontFamily: 'Montserrat-Medium',
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
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

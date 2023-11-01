import 'package:flutter/material.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/trip_list.dart';

class TripSlide extends StatelessWidget {
  final TripList trip;
  const TripSlide({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
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
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: size.height * .15,
        decoration: BoxDecoration(
          color: const Color(0xffF2F3F7),
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                width: 100,
                height: 110,
                decoration: const BoxDecoration(
                  color: Color(0xff031329),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: trip.driverName != '' || trip.driverName != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '${trip.driverName} ${trip.driverLastName}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Stack(children: [
                            ClipOval(
                                child: Image.asset(
                                    'assets/images/driver_img_example.png')),
                          ]),
                        ],
                      )
                    : const Center(
                        child: Text(
                        'Sin conductor',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
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
                        '${trip.userName} ${trip.userLastname}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: size.width * .5,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.account_balance_outlined,
                          size: 20,
                        ),
                        Expanded(
                          child: Text(
                            trip.enterpriseName != null
                                ? ' ${trip.enterpriseName}'
                                : 'No enterprise name',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
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
                        ' ${trip.onWayDriver.day} ${months[trip.onWayDriver.month - 1]} ${trip.onWayDriver.year} | ${trip.onWayDriver.hour}:${trip.onWayDriver.minute}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text('Tarifa Total'),
                      Text(
                        'S/ ${trip.totalPrice}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [Text(trip.status)],
                  )
                ],
              ),
            ),
            GestureDetector(
              // onTap: () => context.push('/admin/reserves/detail/${reserve.id}'),
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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/trip_list.dart';

class TripSlideWeb extends StatelessWidget {
  final TripList trip;
  const TripSlideWeb({super.key, required this.trip});

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
    final Text tripStatus;
    if (trip.status == "INPROGRESS") {
      tripStatus = const Text(
        'En progreso',
        style: TextStyle(
            color: Color(0xff23A5CD),
            fontSize: 10,
            fontFamily: 'Montserrat-Bold'),
      );
    } else if (trip.status == "CANCELED") {
      tripStatus = const Text(
        'Cancelado',
        style: TextStyle(
            color: Colors.red, fontSize: 10, fontFamily: 'Montserrat-Bold'),
      );
    } else if (trip.status == "COMPLETED") {
      tripStatus = const Text(
        'Finalizado',
        style: TextStyle(
            color: Colors.green, fontSize: 10, fontFamily: 'Montserrat-Bold'),
      );
    } else {
      tripStatus = const Text(
        'no info status',
        style: TextStyle(
            color: Colors.red, fontSize: 10, fontFamily: 'Montserrat-Bold'),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: size.height * .18,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              blurRadius: 4,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: size.width * .11,
                decoration: const BoxDecoration(
                  color: Color(0xff03132A),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      topLeft: Radius.circular(8)),
                ),
                child: trip.driverName != '' || trip.driverName != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              '${trip.driverName} ${trip.driverLastName}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'Montserrat-Bold',
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Stack(children: [
                            ClipOval(
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 5.0, // Ancho del borde blanco
                                  ),
                                ),
                                child: Image.asset(
                                  'assets/images/driver_img_example.png',
                                  scale: 0.8,
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: -4,
                                left: -12,
                                child: Image.asset(
                                  'assets/images/vehiculo_home_admin.png',
                                  scale: 1,
                                ))
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                      const SizedBox(width: 10),
                      Text(
                        '${trip.userName} ${trip.userLastName}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontFamily: 'Montserrat-Bold',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            trip.enterpriseName != null
                                ? ' ${trip.enterpriseName}'
                                : 'Viaje Personal',
                            style: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'Montserrat-Medium',
                                fontWeight: FontWeight.w700),
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
                      const SizedBox(width: 9),
                      Text(
                        ' ${trip.startTime.day} ${months[trip.startTime.month - 1]} ${trip.startTime.year} | ${trip.startTime.hour.toString().padLeft(2, '0')}:${trip.startTime.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Montserrat-Medium',
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        'Tarifa Total',
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Montserrat-Bold',
                            color: Color(0xff03132A)),
                      ),
                      SizedBox(
                        width: size.width * .02,
                      ),
                      Text(
                        'S/${trip.totalPrice}',
                        style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Montserrat-Bold',
                            color: Color(0xff03132A)),
                      ),
                    ],
                  ),
                  Row(
                    children: [tripStatus],
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () => context.push('/admin/trips/detail/${trip.id}'),
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

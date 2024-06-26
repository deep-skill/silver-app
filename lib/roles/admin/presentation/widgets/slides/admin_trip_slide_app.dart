import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/trip_list.dart';

class AdminTripSlideApp extends StatelessWidget {
  final TripList trip;
  const AdminTripSlideApp({super.key, required this.trip});

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
    return SizedBox(
      height: size.height * .15,
      child: ElevatedButton(
        onPressed: () => context.push('/admin/trips/detail/${trip.id}'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          foregroundColor: Colors.black,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: size.width * .30,
                decoration: const BoxDecoration(
                  color: Color(0xff03132A),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
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
                            height: 8,
                          ),
                          Stack(children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 0,
                                ),
                              ),
                              child: SizedBox(
                                width: size.width * .20,
                                height: size.width * .20,
                                child: ClipOval(
                                    child: trip.driverImageUrl != null
                                        ? Image.network(
                                            trip.driverImageUrl!,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            'assets/images/driver_img_example.png',
                                            fit: BoxFit.cover,
                                          )),
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
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.hail,
                        size: 20,
                      ),
                      SizedBox(
                        width: size.width * .4,
                        child: Text(
                          '${trip.userName} ${trip.userLastName}',
                          style: const TextStyle(
                            fontSize: 17,
                            fontFamily: 'Montserrat-Bold',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                    width: size.width * .4,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.account_balance_outlined,
                          size: 20,
                        ),
                        Expanded(
                          child: Text(
                            trip.serviceType == 'PERSONAL'
                          ? 'Viaje personal'
                          : trip.enterpriseName,
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
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.event_available_outlined,
                        size: 20,
                      ),
                      SizedBox(
                        width: size.width * .4,
                        child: Text(
                          ' ${trip.onWayDriver.day} ${months[trip.onWayDriver.month - 1]} ${trip.onWayDriver.year} | ${trip.onWayDriver.hour.toString().padLeft(2, '0')}:${trip.onWayDriver.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'Montserrat-Medium',
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                    width: size.width * .4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tarifa Total',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Montserrat-Bold',
                              color: Color(0xff03132A)),
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
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [tripStatus],
                  )
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}

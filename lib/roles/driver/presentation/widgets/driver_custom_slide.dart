import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_reserve_list.dart';

class DriverCustomSlide extends StatelessWidget {
  final DriverReserveList reserve;
  const DriverCustomSlide({super.key, required this.reserve});

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
        height: size.height * .15,
        decoration: const BoxDecoration(
          color: Color(0xffF2F3F7),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: 100,
                decoration: const BoxDecoration(
                  color: Color(0xff031329),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  image: DecorationImage(
                    opacity: 50,
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/enterprise_logo.png'),
                  ),
                ),
                child: reserve.entrepriseName != ''
                    ? Center(
                        child: reserve.entrepriseName != null
                            ? Text(
                                reserve.entrepriseName!,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Viaje Personal',
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ))
                    : const Center(
                        child: Text(
                        'Viaje Personal',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
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
                        Expanded(
                          child: Text(
                            '${reserve.name} ${reserve.lastName}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
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
                          Icons.event_available_outlined,
                          size: 20,
                        ),
                        Expanded(
                          child: Text(
                            ' ${reserve.startTime.day} ${months[reserve.startTime.month - 1]} ${reserve.startTime.year} | ${reserve.startTime.hour}:${reserve.startTime.minute} hs.',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
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
                          Icons.location_on_outlined,
                          size: 20,
                        ),
                        Expanded(
                          child: Text(
                            ' ${reserve.startAddress}',
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
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                reserve.tripId != null
                    ? context.push('/driver/trips/on-trip/${reserve.tripId}')
                    : context.push('/driver/reserves/detail/${reserve.id}');
              },
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 30,
              ),
            ),
            SizedBox(width: 1)
          ],
        ),
      ),
    );
  }
}

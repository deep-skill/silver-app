import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_reserve_home.dart';

class DriverCustomSlideHomeList extends StatelessWidget {
  final DriverReserveHome reserve;
  const DriverCustomSlideHomeList({super.key, required this.reserve});

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
    return SizedBox(
      height: size.height * .12,
      child: ElevatedButton(
        onPressed: () => context.push('/driver/reserves/detail/${reserve.id}'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          foregroundColor: Colors.black,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                width: size.width * .30,
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
                child: reserve.entrepriseName != 'Viaje Personal'
                    ? Center(
                        child: reserve.entrepriseName != 'Viaje Personal'
                            ? Text(
                                reserve.entrepriseName,
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
                          Icons.event_available_outlined,
                          size: 20,
                        ),
                        Text(
                          ' ${reserve.startTime.day} ${months[reserve.startTime.month - 1]} ${reserve.startTime.year} | ${reserve.startTime.hour.toString().padLeft(2, '0')}:${reserve.startTime.minute.toString().padLeft(2, '0')}',
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
                          Icons.location_on_outlined,
                          size: 20,
                        ),
                        Expanded(
                          child: Text(
                            ' ${reserve.startAddress}',
                            style: const TextStyle(
                                fontSize: 12, fontFamily: 'Montserrat-Medium'),
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

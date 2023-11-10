import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/reserve_list.dart';

class CustomSlide extends StatelessWidget {
  final ReserveList reserve;
  const CustomSlide({super.key, required this.reserve});

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
        decoration: BoxDecoration(
          color: const Color(0xffFFFFFF),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 10,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: size.width * .28,
                decoration: BoxDecoration(
                  color: reserve.driverName != ''
                      ? const Color(0xff020B19)
                      : const Color(0xFFF2F3F7),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                child: reserve.driverName != ''
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '${reserve.driverName} ${reserve.driverLastName}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                fontFamily: 'Montserrat-Bold',
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
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
                          fontSize: 12,
                          fontFamily: 'Montserrat-Regular',
                          color: Colors.black,
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
                        '${reserve.name} ${reserve.lastName}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontFamily: 'Montserrat-Bold',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
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
                            ' ${reserve.entrepriseName}',
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
                  const SizedBox(height: 4),
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
                  const SizedBox(height: 4),
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

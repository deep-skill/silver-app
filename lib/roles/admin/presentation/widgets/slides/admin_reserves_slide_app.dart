import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/reserve_list.dart';

class AdminReservesSlideApp extends StatelessWidget {
  final ReserveList reserve;
  const AdminReservesSlideApp({super.key, required this.reserve});

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
      height: size.height * .15,
      child: ElevatedButton(
        onPressed: () => context.push('/admin/reserves/detail/${reserve.id}'),
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
                decoration: BoxDecoration(
                  color: reserve.driverName != ''
                      ? const Color(0xff020B19)
                      : const Color(0xFFF2F3F7),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: reserve.driverName != ''
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              '${reserve.driverName} ${reserve.driverLastName}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'Montserrat-Bold',
                                color: Colors.white,
                              ),
                            ),
                          ),
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
                                  child: reserve.driverImageUrl != null
                                      ? Image.network(
                                          reserve.driverImageUrl!,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          fit: BoxFit.cover,
                                          'assets/images/driver_img_example.png')),
                            ),
                          ),
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
                          '${reserve.name} ${reserve.lastName}',
                          style: const TextStyle(
                            fontSize: 17,
                            fontFamily: 'Montserrat-Bold',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.account_balance_outlined,
                        size: 20,
                      ),
                      SizedBox(
                        width: size.width * .4,
                        child: Text(
                          reserve.serviceType == 'PERSONAL'
                          ? 'Viaje personal'
                          :reserve.entrepriseName,
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
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.event_available_outlined,
                        size: 20,
                      ),
                      SizedBox(
                        width: size.width * .4,
                        child: Text(
                          ' ${reserve.startTime.day} ${months[reserve.startTime.month - 1]} ${reserve.startTime.year} | ${reserve.startTime.hour.toString().padLeft(2, '0')}:${reserve.startTime.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'Montserrat-Medium',
                              fontWeight: FontWeight.w700),
                        ),
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
                      SizedBox(
                        width: size.width * .4,
                        child: Text(
                          ' ${reserve.tripType[0].toUpperCase()}${reserve.tripType.substring(1).toLowerCase()}',
                          style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'Montserrat-Medium',
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: size.width * .1,
            ),
          ],
        ),
      ),
    );
  }
}

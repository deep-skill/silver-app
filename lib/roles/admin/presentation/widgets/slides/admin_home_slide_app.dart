import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/reserve_home.dart';

class AdminHomeSlideApp extends StatelessWidget {
  final ReserveHome reserve;
  const AdminHomeSlideApp({super.key, required this.reserve});

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
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Color(0xffF2F3F7),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: const Center(
                  child: Text(
                    'Sin conductor',
                    style: TextStyle(
                        fontSize: 12, fontFamily: 'Montserrat-Regular'),
                  ),
                )),
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
                              fontSize: 17, fontFamily: 'Montserrat-Bold'),
                          overflow: TextOverflow.ellipsis,
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
                          reserve.entrepriseName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Montserrat-Medium',
                            fontWeight: FontWeight.w700,
                          ),
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
                          ' ${reserve.startTime.day} ${months[reserve.startTime.month - 1]} ${reserve.startTime.year} | ${reserve.startTime.hour}:${reserve.startTime.minute.toString().padLeft(2, '0')}',
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

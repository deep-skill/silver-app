import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/reserve_home.dart';

class AdminHomeSlideWeb extends StatelessWidget {
  final ReserveHome reserve;
  const AdminHomeSlideWeb({super.key, required this.reserve});

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

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        foregroundColor: Colors.black,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      onPressed: () => context.push('/admin/reserves/detail/${reserve.id}'),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              width: size.width * .12,
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
                          reserve.serviceType == 'PERSONAL'
                          ? 'Viaje personal'
                          :reserve.entrepriseName,
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
                      ' ${reserve.startTime.day} ${months[reserve.startTime.month - 1]} ${reserve.startTime.year} | ${reserve.startTime.hour.toString().padLeft(2, '0')}:${reserve.startTime.minute.toString().padLeft(2, '0')}',
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
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 30,
          ),
        ],
      ),
    );
  }
}

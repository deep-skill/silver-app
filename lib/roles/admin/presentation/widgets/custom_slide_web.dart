import 'package:flutter/material.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/reserve_list.dart';

class SlideWeb extends StatelessWidget {
  final ReserveList reserve;
  const SlideWeb({super.key, required this.reserve});

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            width: size.width * .12,
            decoration: BoxDecoration(
              color: reserve.driverName != ''
                  ? const Color(0xff020B19)
                  : Colors.grey.shade200,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: reserve.driverName != ''
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${reserve.driverName} ${reserve.driverLastName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Montserrat-Bold',
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Stack(children: [
                        SizedBox(
                          width: 80,
                          height: 80,
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
                      ]),
                    ],
                  )
                : const Center(
                    child: Text(
                    'Sin conductor',
                    style: TextStyle(
                      fontFamily: 'Montserrat-Regular',
                      fontSize: 12,
                      color: Colors.black,
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
                      fontSize: 17,
                      fontFamily: 'Montserrat-Bold',
                    ),
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
                            fontSize: 12,
                            fontFamily: 'Montserrat-Medium',
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
                        fontSize: 12,
                        fontFamily: 'Montserrat-Medium',
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
                        fontSize: 12,
                        fontFamily: 'Montserrat-Medium',
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
    );
  }
}

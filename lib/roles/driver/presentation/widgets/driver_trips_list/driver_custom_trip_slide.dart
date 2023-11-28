import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/roles/driver/infraestructure/entities/driver_trip_list.dart';

class CustomTripSlide extends StatelessWidget {
  final DriverTripList trip;

  const CustomTripSlide({
    Key? key,
    required this.trip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const TextStyle styleName =
        TextStyle(fontFamily: 'Montserrat-Bold', fontSize: 15);
    const TextStyle styleText =
        TextStyle(fontFamily: 'Montserrat-Medium', fontSize: 12);
    const TextStyle styleTextPay =
        TextStyle(fontFamily: 'Montserrat-Bold', fontSize: 12);

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

    String getDate() {
      final mont = months[trip.onWayDriver.month - 1];

      return "${trip.onWayDriver.day} $mont ${trip.onWayDriver.year} | ${trip.onWayDriver.hour}:${trip.onWayDriver.minute}";
    }

    double calculateDriverPrice() {
      double result =
          trip.totalPrice - (trip.totalPrice * trip.silverPercent / 100);
      for (var element in trip.tolls) {
        result += element.amount;
      }
      for (var element in trip.parkings) {
        result += element.amount;
      }
      return result;
    }

    String textState() {
      if (trip.status == "CANCELED") {
        return "Cancelada";
      } else if (trip.status == "COMPLETED") {
        return "Finalizado";
      } else {
        return "En progreso";
      }
    }

    Color colorState() {
      if (trip.status == "CANCELED") {
        return const Color(0xFFFD3B3B);
      } else if (trip.status == "COMPLETED") {
        return const Color(0xFF2FCF5C);
      } else {
        return const Color(0xFF23A5CD);
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: size.height * .15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
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
                  child: trip.enterpriseName != ''
                      ? Center(
                          child: trip.enterpriseName != ''
                              ? Text(
                                  trip.enterpriseName,
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
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.50,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const SizedBox(
                          width: 6,
                        ),
                        const Icon(
                          Icons.hail,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          "${trip.name} ${trip.lastName}",
                          style: styleName,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const SizedBox(
                          width: 6,
                        ),
                        const Icon(
                          Icons.date_range_outlined,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          getDate(),
                          style: styleText,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Row(
                            children: [
                              Text(
                                "Pago conductor",
                                style: styleTextPay,
                              ),
                            ],
                          ),
                          Text(
                              " S/. ${calculateDriverPrice().toStringAsFixed(2)}",
                              style: styleTextPay),
                        ]),
                    const SizedBox(
                      height: 3,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 8,
                        ),
                        Text(textState(),
                            style: TextStyle(
                                fontFamily: 'Montserrat-Bold',
                                fontSize: 10,
                                color: colorState())),
                      ],
                    ),
                    const SizedBox(height: 6),
                  ]),
            ),
            IconButton(
                onPressed: () => {
                      trip.status == 'INPROGRESS'
                          ? context.push('/driver/trips/on-trip/${trip.id}')
                          : context.push('/driver/trips/detail/${trip.id}')
                    },
                icon: const Icon(Icons.arrow_forward_ios_rounded, size: 30))
          ],
        ),
      ),
    );
  }
}

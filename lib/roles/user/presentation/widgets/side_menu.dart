import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/providers/auth0_provider.dart';

class SideMenu extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const SideMenu({
    super.key,
    required this.scaffoldKey,
  });

  @override
  SideMenuState createState() => SideMenuState();
}

class SideMenuState extends ConsumerState<SideMenu> {
  int navDrawerIndex = 0;

  @override
  Widget build(BuildContext context) {
    final hasNotch = MediaQuery.of(context).viewPadding.top > 20;
    Credentials? credentials = ref.watch(authProvider).credentials;
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * .85,
      child: NavigationDrawer(
        backgroundColor: const Color(0xff031329),
        indicatorColor: const Color(0xff23A5CD),
        indicatorShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(10),
        )),
        onDestinationSelected: (value) {
          setState(() {
            navDrawerIndex = value;
          });
          final menuItem = appMenuItems[value];
          menuItem.link == '/user' ? null : context.push(menuItem.link);
          widget.scaffoldKey.currentState?.closeDrawer();
        },
        selectedIndex: navDrawerIndex,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, hasNotch ? 20 : 10, 16, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    widget.scaffoldKey.currentState?.closeDrawer();
                  },
                  icon: const Icon(Icons.close),
                  color: Colors.white,
                ),
                SizedBox(
                    child: Image.asset(
                  "assets/images/app_logo.png",
                  width: size.width * .15,
                )),
                const Text('Silver Express',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                Text(credentials!.user.email.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        //    height: 5,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          ...appMenuItems.map(
            (item) => NavigationDrawerDestination(
              icon: Icon(item.icon, color: Colors.white),
              label:
                  Text(item.title, style: const TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(
            height: 280,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(28, 16, 16, 1),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextButton(
              onPressed: () {
                ref.read(authProvider.notifier).logout();
              },
              style: ButtonStyle(
                overlayColor:
                    MaterialStateProperty.all(const Color(0xff031329)),
                shadowColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.logout_rounded,
                    color: Colors.white,
                  ),
                  Text('Cerrar sesión',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuItem {
  final String title;
  final String link;
  final IconData icon;
  const MenuItem({required this.title, required this.link, required this.icon});
}

const appMenuItems = <MenuItem>[
  MenuItem(
    title: 'Inicio',
    link: '/admin-home',
    icon: Icons.home_outlined,
  ),
  MenuItem(
    title: 'Mis reservas',
    link: '/mis-reserva',
    icon: Icons.calendar_month_outlined,
  ),
  MenuItem(
    title: 'Mis viajes',
    link: '/mis-viajes',
    icon: Icons.local_taxi_outlined,
  ),
  /*MenuItem(
    title: 'Mi cuenta',
    link: '/cuenta',
    icon: Icons.person_outline,
  ),
  MenuItem(
    title: 'Historial de viajes',
    link: '/historial',
    icon: Icons.emoji_transportation_rounded,
  ),
  MenuItem(
    title: 'Notificaciones',
    link: '/notificaciones',
    icon: Icons.notifications_none_rounded,
  ),
  MenuItem(
    title: 'Ayuda y soporte',
    link: '/ayuda',
    icon: Icons.help_outline_rounded,
  ),
  MenuItem(
    title: 'Libro de reclamaciones',
    link: '/reclamaciones',
    icon: Icons.menu_book_rounded,
  ),*/
];

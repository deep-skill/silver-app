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

    return NavigationDrawer(
      onDestinationSelected: (value) {
        setState(() {
          navDrawerIndex = value;
        });
        final menuItem = appMenuItems[value];
        context.push(menuItem.link);
        widget.scaffoldKey.currentState?.closeDrawer();
      },
      selectedIndex: navDrawerIndex,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, hasNotch ? 20 : 10, 16, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  child: Image.asset(
                "assets/images/app_logo.png",
                width: 45,
              )),
              const Text('Silver Express',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(credentials!.user.email.toString(),
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 16, 19),
          child: Divider(),
        ),
        ...appMenuItems.map(
          (item) => NavigationDrawerDestination(
            icon: Icon(item.icon),
            label: Text(item.title),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 16, 19),
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ElevatedButton(
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
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
    );
  }
}

class MenuItem {
  final String title;
  final String link;
  final IconData icon;
  //constructor
  const MenuItem({required this.title, required this.link, required this.icon});
}

const appMenuItems = <MenuItem>[
  MenuItem(
    title: 'Inicio',
    link: '/admin-home',
    icon: Icons.home_outlined,
  ),
  MenuItem(
    title: 'Crear reserva',
    link: '/crear-reserva',
    icon: Icons.add_card_rounded,
  ),
  MenuItem(
    title: 'Lista de reservas',
    link: '/reservas',
    icon: Icons.calendar_month,
  ),
  MenuItem(
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
  ),
];

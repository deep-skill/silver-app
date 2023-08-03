import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/auth0/auth0.dart';
import 'package:silverapp/config/router/app_router_notifier.dart';
import 'package:silverapp/providers/auth0_provider.dart';
import 'package:silverapp/roles/admin/admin_screen.dart';
import 'package:silverapp/roles/driver/driver_screen.dart';
import 'package:silverapp/roles/no_role/no_role_screen.dart';
import 'package:silverapp/roles/user/user_screen.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);
  return GoRouter(
      initialLocation: '/login',
      refreshListenable: goRouterNotifier,
      routes: [
        ///* First screen

        GoRoute(
          path: '/login',
          builder: (context, state) => const Auth0Screen(),
        ),

        ///* Product Routes
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminScreen(),
        ),
        GoRoute(
          path: '/driver',
          builder: (context, state) => const DriverScreen(),
        ),
        GoRoute(
          path: '/user',
          builder: (context, state) => const UserScreen(),
        ),
        GoRoute(
          path: '/no-role',
          builder: (context, state) => const NoRoleScreen(),
        ),
      ],
      redirect: (context, state) {
        final authState = goRouterNotifier.authStatus;

        if (authState.authStatus == AuthStatus.notAuthenticated) {
          return '/login';
        }

        if (authState.authStatus == AuthStatus.authenticated &&
            authState.credentials!.scopes.toString() ==
                '{openid, profile, email}') {
          return '/no-role';
        }
        if (authState.authStatus == AuthStatus.authenticated &&
            authState.credentials!.scopes.toString().contains('admin')) {
          return '/admin';
        }
        if (authState.authStatus == AuthStatus.authenticated &&
            authState.credentials!.scopes.toString().contains('driver')) {
          return '/driver';
        }
        if (authState.authStatus == AuthStatus.authenticated &&
            authState.credentials!.scopes.toString().contains('user')) {
          return '/user';
        }

        return null;
      });
});

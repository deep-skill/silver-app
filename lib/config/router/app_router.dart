import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/auth0/auth0.dart';
import 'package:silverapp/config/router/app_router_notifier.dart';
import 'package:silverapp/providers/auth0_provider.dart';
import 'package:silverapp/roles/admin/presentation/screens/admin_screen.dart';
import 'package:silverapp/roles/admin/presentation/screens/create_reserve_screen.dart';
import 'package:silverapp/roles/admin/presentation/screens/reserve_detail_screen.dart';
import 'package:silverapp/roles/admin/presentation/screens/reserve_list_screen.dart';
import 'package:silverapp/roles/driver/presentation/screens/driver_on_trip_screen.dart';
import 'package:silverapp/roles/admin/presentation/screens/trips_list_screen.dart';
import 'package:silverapp/roles/driver/presentation/screens/driver_reserve_detail_screen.dart';
import 'package:silverapp/roles/driver/presentation/screens/driver_screen.dart';
import 'package:silverapp/roles/driver/presentation/screens/trip_list_screen.dart';
import 'package:silverapp/roles/no_role/no_role_screen.dart';
import 'package:silverapp/roles/user/presentation/screens/user_screen.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);
  return GoRouter(
      initialLocation: '/login',
      refreshListenable: goRouterNotifier,
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const Auth0Screen(),
        ),
        GoRoute(
          path: '/admin',
          builder: (context, state) => AdminScreen(),
          routes: [
            GoRoute(
                path: 'reserves',
                builder: (context, state) => const ReserveListScreen(),
                routes: [
                  GoRoute(
                    path: 'create',
                    builder: (context, state) {
                      return const CreateReserveScreen(
                        reserveId: 'new',
                      );
                    },
                  ),
                  GoRoute(
                    path: 'detail/:id',
                    builder: (context, state) {
                      final reserveId =
                          state.pathParameters['id'] ?? 'No params available';
                      return ReserveDetailScreen(reserveId: reserveId);
                    },
                  ),
                ]),
            GoRoute(
              path: 'trips',
              builder: (context, state) => const TripsListScreen(),
            ),
          ],
        ),
        GoRoute(
            path: '/driver',
            builder: (context, state) => DriverScreen(),
            routes: [
              GoRoute(
                  path: 'reserves',
                  builder: (context, state) => const ReserveListScreen(),
                  routes: [
                    GoRoute(
                      path: 'detail/:id',
                      builder: (context, state) {
                        final reserveId =
                            state.pathParameters['id'] ?? 'No params available';
                        return DriverReserveDetailScreen(reserveId: reserveId);
                      },
                    ),
                  ]),
              GoRoute(
                  path: 'trips',
                  builder: (context, state) => const DriverTripListScreen(),
                  routes: [
                    GoRoute(
                      path: 'on-trip/:id',
                      builder: (context, state) {
                        final tripId =
                            state.pathParameters['id'] ?? 'No params available';
                        return DriverOnTripScreen(tripId: tripId);
                      },
                    ),
                  ]),
            ]),
        GoRoute(
          path: '/user',
          builder: (context, state) => UserScreen(),
        ),
        GoRoute(
          path: '/no-role',
          builder: (context, state) => const NoRoleScreen(),
        ),
      ],
      redirect: (context, state) {
        final authState = goRouterNotifier.authStatus;
        final isGoingTo = state.matchedLocation;

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
          if (isGoingTo.contains('/admin/')) return null;
          return '/admin';
        }
        if (authState.authStatus == AuthStatus.authenticated &&
            authState.credentials!.scopes.toString().contains('driver')) {
          if (isGoingTo.contains('/driver/')) return null;
          return '/driver';
        }
        if (authState.authStatus == AuthStatus.authenticated &&
            authState.credentials!.scopes.toString().contains('user')) {
          return '/user';
        }

        return null;
      });
});

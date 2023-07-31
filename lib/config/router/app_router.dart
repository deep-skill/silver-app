import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:silverapp/auth0/auth0.dart';
import 'package:silverapp/auth0/auth0_details_screens.dart';
import 'package:silverapp/config/router/app_router_notifier.dart';
import 'package:silverapp/providers/auth0_provider.dart';

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
          path: '/details',
          builder: (context, state) => const DetailsScreen(),
        ),
      ],
      redirect: (context, state) {
        
        final authStatus = goRouterNotifier.authStatus;

        if (authStatus == AuthStatus.checking){
          return null;
          }

        if (authStatus == AuthStatus.notAuthenticated) {
          return '/login';
        }

        if (authStatus == AuthStatus.authenticated) {
            return '/details';
          
        }

        return null;
      });
});

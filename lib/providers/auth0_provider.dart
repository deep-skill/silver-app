import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/env/env.dart';

//Auth0 Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

//Auth0 Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  late Auth0 auth0;
  late Auth0Web auth0Web;

  AuthNotifier() : super(AuthState()) {
    auth0 = Auth0(Env.auth0Domain, Env.auth0ClientId);
    auth0Web =
        Auth0Web(Env.auth0Domain, Env.auth0ClientId);

    //Initializes Auth0 on Web and get stored credentials
    if (kIsWeb) {
      auth0Web.onLoad(
        audience: Env.appAudience,
        scopes: {'openid', 'profile', 'email', 'admin', 'driver', 'user'},
      ).then((final credentials) {
        if (credentials != null) {
          state = state.copyWith(
            user: credentials.user,
            authStatus: AuthStatus.authenticated,
            credentials: credentials,
          );
        }
      });
    }

    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    state = state.copyWith(
      authStatus: AuthStatus.checking,
    );
    await Future.delayed(const Duration(seconds: 3));
    try {
      if (kIsWeb) {
        final isLoggedIn = await auth0Web.hasValidCredentials();
        if (isLoggedIn) {
          final credentials = await auth0Web.credentials();
          state = state.copyWith(
            user: credentials.user,
            authStatus: AuthStatus.authenticated,
            credentials: credentials,
          );
        } else {
          state = state.copyWith(
            authStatus: AuthStatus.notAuthenticated,
          );
        }
      } else {
        final isLoggedIn = await auth0.credentialsManager.hasValidCredentials();
        if (isLoggedIn) {
          final credentials = await auth0.credentialsManager.credentials();
          state = state.copyWith(
            user: credentials.user,
            authStatus: AuthStatus.authenticated,
            credentials: credentials,
          );
        } else {
          state = state.copyWith(
            authStatus: AuthStatus.notAuthenticated,
          );
        }
      }
    } catch (e) {
      //Auth0 print recomendation
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> login() async {
    try {
      if (kIsWeb) {
        return auth0Web.loginWithRedirect(
          redirectUrl: Env.appRedirectUrl,
          audience: Env.appAudience,
          scopes: {'openid', 'profile', 'email', 'admin', 'driver', 'user'},
        );
      }

      var credentials = await auth0
          .webAuthentication(scheme: Env.auth0CustomScheme)
          .login(
        audience: Env.appAudience,
        scopes: {'openid', 'profile', 'email', 'admin', 'driver', 'user'},
      );
      state = state.copyWith(
        authStatus: AuthStatus.checking,
      );
      await Future.delayed(const Duration(seconds: 3));
      state = state.copyWith(
        user: credentials.user,
        authStatus: AuthStatus.authenticated,
        credentials: credentials,
      );
    } catch (e) {
      //Auth0 print recomendation
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> logout() async {
    state = state.copyWith(
      authStatus: AuthStatus.checking,
    );
    try {
      if (kIsWeb) {
        await auth0Web.logout(returnToUrl: Env.appRedirectUrl);
      } else {
        await auth0
            .webAuthentication(scheme: Env.auth0CustomScheme)
            .logout();
      }
      state = state.copyWith(
        user: null,
        authStatus: AuthStatus.notAuthenticated,
        credentials: null,
      );
    } catch (e) {
      //Auth0 print recomendation
      // ignore: avoid_print
      print(e);
    }
  }
}

// Auth State
enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final AuthStatus authStatus;
  final UserProfile? user;
  final Credentials? credentials;

  AuthState({
    this.authStatus = AuthStatus.checking,
    this.user,
    this.credentials,
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    UserProfile? user,
    Credentials? credentials,
  }) =>
      AuthState(
        authStatus: authStatus ?? this.authStatus,
        user: user,
        credentials: credentials,
      );
}

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Auth0 Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

//Auth0 Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  late Auth0 auth0;
  late Auth0Web auth0Web;

  AuthNotifier() : super(AuthState()) {
    auth0 = Auth0(dotenv.env['AUTH0_DOMAIN']!, dotenv.env['AUTH0_CLIENT_ID']!);
    auth0Web =
        Auth0Web(dotenv.env['AUTH0_DOMAIN']!, dotenv.env['AUTH0_CLIENT_ID']!);

    if (kIsWeb) {
      auth0Web.onLoad().then((final credentials) {
        if (credentials != null) {
          // logged in!
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
    try {
      if (kIsWeb) {
        final isLoggedIn = await auth0Web.hasValidCredentials();

        if (isLoggedIn) {
          // Retrieve the credentials and redirect to the main flow
          final credentials = await auth0Web.credentials();
          state = state.copyWith(
            user: credentials.user,
            authStatus: AuthStatus.authenticated,
            credentials: credentials,
          );
        } else {
          // No valid credentials exist, present the login page
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
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> login() async {
    try {
      if (kIsWeb) {
        return auth0Web.loginWithRedirect(redirectUrl: 'http://localhost:3000');
      }

      var credentials = await auth0
          .webAuthentication(scheme: dotenv.env['AUTH0_CUSTOM_SCHEME'])
          .login();

      state = state.copyWith(
        user: credentials.user,
        authStatus: AuthStatus.authenticated,
        credentials: credentials,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    try {
      if (kIsWeb) {
        await auth0Web.logout(returnToUrl: 'http://localhost:3000');
      } else {
        await auth0
            .webAuthentication(scheme: dotenv.env['AUTH0_CUSTOM_SCHEME'])
            .logout();
      }
      state = state.copyWith(
        user: null,
        authStatus: AuthStatus.notAuthenticated,
        credentials: null,
      );
    } catch (e) {
      print(e);
    }
  }
}

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

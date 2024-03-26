import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', obfuscate: true, useConstantCase: true)
abstract class Env {
    @EnviedField(varName: 'AUTH0_DOMAIN')
    static final String auth0Domain = _Env.auth0Domain;
    @EnviedField(varName: 'AUTH0_CLIENT_ID', obfuscate: true)
    static final String auth0ClientId = _Env.auth0ClientId;
    @EnviedField(varName: 'AUTH0_CUSTOM_SCHEME', obfuscate: true)
    static final String auth0CustomScheme = _Env.auth0CustomScheme;
    @EnviedField(varName: 'FIREBASE_OPTIONS_WEB', obfuscate: true)
    static final String firebaseOptionsWeb = _Env.firebaseOptionsWeb;
    @EnviedField(varName: 'FIREBASE_OPTIONS_ANDROID', obfuscate: true)
    static final String firebaseOptionsAndroid = _Env.firebaseOptionsAndroid;
    @EnviedField(varName: 'FIREBASE_OPTIONS_IOS', obfuscate: true)
    static final String firebaseOptionsIos = _Env.firebaseOptionsIos;
    @EnviedField(varName: 'FIREBASE_OPTIONS_MACOS', obfuscate: true)
    static final String firebaseOptionsMacos = _Env.firebaseOptionsMacos;
    @EnviedField(varName: 'PROJECT_ID', obfuscate: true)
    static final String projectId = _Env.projectId;
    @EnviedField(varName: 'APP_AUDIENCE', obfuscate: true)
    static final String appAudience = _Env.appAudience;
    @EnviedField(varName: 'APP_REDIRECT_URL', obfuscate: true)
    static final String appRedirectUrl = _Env.appRedirectUrl;
    @EnviedField(varName: 'GOOGLE_MAPS_KEY', obfuscate: true)
    static final String googleMapsKey = _Env.googleMapsKey;
    @EnviedField(varName: 'HTTP_REQUEST', obfuscate: true)
    static final String httpRequest = _Env.httpRequest;
    @EnviedField(varName: 'GOOGLE_ROUTES_API_KEY', obfuscate: true)
    static final String googleRoutesApiKey = _Env.googleRoutesApiKey;
}
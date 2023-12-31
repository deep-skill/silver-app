// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAmmTTx-KXe-F_RJ1BmY4qzQCGUh0rorn0',
    appId: '1:186537693375:web:becb5f544d1677e14d760a',
    messagingSenderId: '186537693375',
    projectId: 'silver-express-8fa19',
    authDomain: 'silver-express-8fa19.firebaseapp.com',
    storageBucket: 'silver-express-8fa19.appspot.com',
    measurementId: 'G-Y2688NFN2T',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBOpl6QvUmlB-63jNFUPusLtUeZkUwLDKY',
    appId: '1:186537693375:android:fcd60c05ee6ea3484d760a',
    messagingSenderId: '186537693375',
    projectId: 'silver-express-8fa19',
    storageBucket: 'silver-express-8fa19.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDKoxqubvUjynUCot4aoAw7Nj8Z61MBVPI',
    appId: '1:186537693375:ios:3988be5db077ff774d760a',
    messagingSenderId: '186537693375',
    projectId: 'silver-express-8fa19',
    storageBucket: 'silver-express-8fa19.appspot.com',
    iosBundleId: 'com.example.silverapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDKoxqubvUjynUCot4aoAw7Nj8Z61MBVPI',
    appId: '1:186537693375:ios:2ea7666a30afbbea4d760a',
    messagingSenderId: '186537693375',
    projectId: 'silver-express-8fa19',
    storageBucket: 'silver-express-8fa19.appspot.com',
    iosBundleId: 'com.example.silverapp.RunnerTests',
  );
}

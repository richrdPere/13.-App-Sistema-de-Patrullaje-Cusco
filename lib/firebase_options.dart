// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyChc2bKD9-pYwyVPvkKLSlf_7mYj9fRWBo',
    appId: '1:961355364019:web:67a51e08c3584a60c362c6',
    messagingSenderId: '961355364019',
    projectId: 'patrullajes-serenazgo-cusco',
    authDomain: 'patrullajes-serenazgo-cusco.firebaseapp.com',
    storageBucket: 'patrullajes-serenazgo-cusco.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCGIOZhIa5aqYXDTgXmK1vpJ6wdWOhQn6M',
    appId: '1:961355364019:android:a568071214bbc234c362c6',
    messagingSenderId: '961355364019',
    projectId: 'patrullajes-serenazgo-cusco',
    storageBucket: 'patrullajes-serenazgo-cusco.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC18K1IFl-8f1ExTVhFs5ONmUTB2zSNQEY',
    appId: '1:961355364019:ios:7fec2d54edbcae19c362c6',
    messagingSenderId: '961355364019',
    projectId: 'patrullajes-serenazgo-cusco',
    storageBucket: 'patrullajes-serenazgo-cusco.firebasestorage.app',
    iosBundleId: 'com.example.patrullajeSerenazgoCusco',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC18K1IFl-8f1ExTVhFs5ONmUTB2zSNQEY',
    appId: '1:961355364019:ios:7fec2d54edbcae19c362c6',
    messagingSenderId: '961355364019',
    projectId: 'patrullajes-serenazgo-cusco',
    storageBucket: 'patrullajes-serenazgo-cusco.firebasestorage.app',
    iosBundleId: 'com.example.patrullajeSerenazgoCusco',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyChc2bKD9-pYwyVPvkKLSlf_7mYj9fRWBo',
    appId: '1:961355364019:web:73cd30c81c6059a5c362c6',
    messagingSenderId: '961355364019',
    projectId: 'patrullajes-serenazgo-cusco',
    authDomain: 'patrullajes-serenazgo-cusco.firebaseapp.com',
    storageBucket: 'patrullajes-serenazgo-cusco.firebasestorage.app',
  );

}
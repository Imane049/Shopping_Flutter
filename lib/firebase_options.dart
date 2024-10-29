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
    apiKey: 'AIzaSyAxRPVxoj9WemyZoau4P03dGIjiCooFnLE',
    appId: '1:792586615267:web:85a6dedf88e8133281c8d6',
    messagingSenderId: '792586615267',
    projectId: 'projet2-9d413',
    authDomain: 'projet2-9d413.firebaseapp.com',
    storageBucket: 'projet2-9d413.appspot.com',
    measurementId: 'G-R6LBVXYCJX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDaY8py8ezAaXgBEBCAa0ibr2W_h2SvTfo',
    appId: '1:792586615267:android:201bb219e4f74e2081c8d6',
    messagingSenderId: '792586615267',
    projectId: 'projet2-9d413',
    storageBucket: 'projet2-9d413.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDfdOEbBy69vk70YoVrfxNwuhXugcvsEqo',
    appId: '1:792586615267:ios:7f4d19dadd384f4781c8d6',
    messagingSenderId: '792586615267',
    projectId: 'projet2-9d413',
    storageBucket: 'projet2-9d413.appspot.com',
    iosBundleId: 'com.example.flutterApplication2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDfdOEbBy69vk70YoVrfxNwuhXugcvsEqo',
    appId: '1:792586615267:ios:7f4d19dadd384f4781c8d6',
    messagingSenderId: '792586615267',
    projectId: 'projet2-9d413',
    storageBucket: 'projet2-9d413.appspot.com',
    iosBundleId: 'com.example.flutterApplication2',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAxRPVxoj9WemyZoau4P03dGIjiCooFnLE',
    appId: '1:792586615267:web:7755a3a7d98ae4cf81c8d6',
    messagingSenderId: '792586615267',
    projectId: 'projet2-9d413',
    authDomain: 'projet2-9d413.firebaseapp.com',
    storageBucket: 'projet2-9d413.appspot.com',
    measurementId: 'G-1VEYB2851G',
  );

}
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
    apiKey: 'AIzaSyCdGB2S0mcUgicc6ynhVr7Om4J5H1zF77U',
    appId: '1:687124790053:web:ddd1a3250150587166b8cc',
    messagingSenderId: '687124790053',
    projectId: 'bai2l2',
    authDomain: 'bai2l2.firebaseapp.com',
    storageBucket: 'bai2l2.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAoqYZ69ZNqwbSCqM4gEBUgas-L_af5FMk',
    appId: '1:687124790053:android:11e14907a5dfce6466b8cc',
    messagingSenderId: '687124790053',
    projectId: 'bai2l2',
    storageBucket: 'bai2l2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBpC_Reww8qcxZrtM4IzKVlQHBKqdGw6KE',
    appId: '1:687124790053:ios:a14386c34a0ad96166b8cc',
    messagingSenderId: '687124790053',
    projectId: 'bai2l2',
    storageBucket: 'bai2l2.appspot.com',
    iosBundleId: 'com.example.exercies3',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBpC_Reww8qcxZrtM4IzKVlQHBKqdGw6KE',
    appId: '1:687124790053:ios:a14386c34a0ad96166b8cc',
    messagingSenderId: '687124790053',
    projectId: 'bai2l2',
    storageBucket: 'bai2l2.appspot.com',
    iosBundleId: 'com.example.exercies3',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCdGB2S0mcUgicc6ynhVr7Om4J5H1zF77U',
    appId: '1:687124790053:web:a2d776e960a22d2d66b8cc',
    messagingSenderId: '687124790053',
    projectId: 'bai2l2',
    authDomain: 'bai2l2.firebaseapp.com',
    storageBucket: 'bai2l2.appspot.com',
  );
}

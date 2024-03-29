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
    apiKey: 'AIzaSyD4nbGWwUsvPeD9OVfcU-I8rO0zXxdolDc',
    appId: '1:965754096900:web:d027b844d468d6022c5451',
    messagingSenderId: '965754096900',
    projectId: 'chat-app-flutter-abcd1',
    authDomain: 'chat-app-flutter-abcd1.firebaseapp.com',
    storageBucket: 'chat-app-flutter-abcd1.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBo3am9QS2aN1K_WYQyn0W2fcxR_16dQEc',
    appId: '1:965754096900:android:2b092e02c2599d272c5451',
    messagingSenderId: '965754096900',
    projectId: 'chat-app-flutter-abcd1',
    storageBucket: 'chat-app-flutter-abcd1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAzEthFi8vlJ3wvEeVSRoH3EC4q1RTZfvk',
    appId: '1:965754096900:ios:3c0e875a8fd666342c5451',
    messagingSenderId: '965754096900',
    projectId: 'chat-app-flutter-abcd1',
    storageBucket: 'chat-app-flutter-abcd1.appspot.com',
    iosClientId: '965754096900-sfjrrk33qkqbvim0noj7febdk84lspkt.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatAppFlutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAzEthFi8vlJ3wvEeVSRoH3EC4q1RTZfvk',
    appId: '1:965754096900:ios:3c0e875a8fd666342c5451',
    messagingSenderId: '965754096900',
    projectId: 'chat-app-flutter-abcd1',
    storageBucket: 'chat-app-flutter-abcd1.appspot.com',
    iosClientId: '965754096900-sfjrrk33qkqbvim0noj7febdk84lspkt.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatAppFlutter',
  );
}

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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCHEwanBmWla-fVNkr7gOQttcGE0gZv39s',
    appId: '1:367424573764:web:2e59c07d2553ce8d0a8711',
    messagingSenderId: '367424573764',
    projectId: 'inspecao-de-seguranca',
    authDomain: 'inspecao-de-seguranca.firebaseapp.com',
    storageBucket: 'inspecao-de-seguranca.appspot.com',
    measurementId: 'G-T3XYHR813M',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA3XhWRU2BPSf86KJ0NHp6K7Wb10C-UcDE',
    appId: '1:367424573764:android:c636c4181d7f5fca0a8711',
    messagingSenderId: '367424573764',
    projectId: 'inspecao-de-seguranca',
    storageBucket: 'inspecao-de-seguranca.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCSmbO5DcJ8iLSfJzvmn88Z2q7F00c128g',
    appId: '1:367424573764:ios:6659620d6e1a21830a8711',
    messagingSenderId: '367424573764',
    projectId: 'inspecao-de-seguranca',
    storageBucket: 'inspecao-de-seguranca.appspot.com',
    iosBundleId: 'com.tmsistemas.inspecaoSeguranca',
  );
}

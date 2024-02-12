import 'package:inspecao_seguranca/firebase_options.dart';

class Plataforma {
  static final bool isWeb =
      DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.web;
}

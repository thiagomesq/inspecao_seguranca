import 'package:flutter/material.dart';
import 'package:inspecao_seguranca/di.dart';
import 'package:inspecao_seguranca/ui/pages/splash/splash_page.dart';
import 'package:inspecao_seguranca/ui/routes.dart';
import 'package:inspecao_seguranca/ui/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDI();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('pt', 'BR'),
      theme: theme,
      routes: routes,
      initialRoute: SplashPage.routeName,
    );
  }
}

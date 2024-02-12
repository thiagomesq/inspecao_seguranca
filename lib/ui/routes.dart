import 'package:flutter/material.dart';
import 'package:inspecao_seguranca/ui/pages/empresa/empresa_page.dart';
import 'package:inspecao_seguranca/ui/pages/home/home_page.dart';
import 'package:inspecao_seguranca/ui/pages/login/login_page.dart';
import 'package:inspecao_seguranca/ui/pages/splash/splash_page.dart';
import 'package:inspecao_seguranca/ui/pages/usuario/usuario_page.dart';

Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  SplashPage.routeName: (_) => const SplashPage(),
  LoginPage.routeName: (_) => const LoginPage(),
  EmpresaPage.routeName: (_) => const EmpresaPage(),
  UsuarioPage.routeName: (_) => const UsuarioPage(),
  HomePage.routeName: (_) => const HomePage(),
};

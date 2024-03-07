import 'package:flutter/material.dart';
import 'package:inspecao_seguranca/ui/pages/cadastros/inspecao/add_edit/add_edit_page.dart';
import 'package:inspecao_seguranca/ui/pages/cadastros/inspecao/inspecao_page.dart';
import 'package:inspecao_seguranca/ui/pages/cadastros/questao/add_edit/add_edit_page.dart';
import 'package:inspecao_seguranca/ui/pages/cadastros/questao/questao_page.dart';
import 'package:inspecao_seguranca/ui/pages/cadastros/tipo_veiculo/add_edit/add_edit_page.dart';
import 'package:inspecao_seguranca/ui/pages/cadastros/tipo_veiculo/tipo_veiculo_page.dart';
import 'package:inspecao_seguranca/ui/pages/cadastros/veiculo/add_edit/add_edit_page.dart';
import 'package:inspecao_seguranca/ui/pages/cadastros/veiculo/veiculo_page.dart';
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
  InspecaoPage.routeName: (_) => const InspecaoPage(),
  AddEditInspecaoPage.routeName: (_) => const AddEditInspecaoPage(),
  TipoVeiculoPage.routeName: (_) => const TipoVeiculoPage(),
  AddEditTipoVeiculoPage.routeName: (_) => const AddEditTipoVeiculoPage(),
  QuestaoPage.routeName: (_) => const QuestaoPage(),
  AddEditQuestaoPage.routeName: (_) => const AddEditQuestaoPage(),
  VeiculoPage.routeName: (_) => const VeiculoPage(),
  AddEditVeiculoPage.routeName: (_) => const AddEditVeiculoPage(),
};

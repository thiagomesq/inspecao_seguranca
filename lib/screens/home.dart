import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.Dart';
import 'package:inspecao_seguranca/constants.dart';
import 'package:inspecao_seguranca/models/tsl_data.dart';
import 'package:inspecao_seguranca/models/usuario_tst.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final String usuario;

  const HomeScreen({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    TSLData tslData = TSLData();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0),
          child: Center(
            child: Text(
              'Bem vindo(a), $usuario',
              style: const TextStyle(
                fontSize: 32,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Hero(
          tag: logoTag,
          child: Image.asset(
            'images/logo_ei.png',
            filterQuality: FilterQuality.high,
            width: 250.0,
            height: 250.0,
          ),
        ),
        const SizedBox(
          height: 7.0,
        ),
        const Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: Text(
            'EI Consultoria',
            style: TextStyle(
              fontSize: 30.0,
              color: eiConsultoriaRed,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        /*const SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () {
            tslData.addQuestoesVeiculos();
          },
          style: ElevatedButton.styleFrom(
            elevation: 5.0,
            primary: emflorGreen,
            padding: const EdgeInsets.symmetric(vertical: 13.0),
          ),
          child: const Text('Adicionar Questões'),
        ),*/
      ],
    );
  }
}

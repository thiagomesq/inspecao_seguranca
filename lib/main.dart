import 'package:inspecao_seguranca/constants.dart';
import 'package:inspecao_seguranca/models/empresa.dart';
import 'package:inspecao_seguranca/models/finalidade_veiculo.dart';
import 'package:inspecao_seguranca/models/funcao.dart';
import 'package:inspecao_seguranca/models/localidade.dart';
import 'package:inspecao_seguranca/models/questao_campo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:inspecao_seguranca/models/questao_veiculo.dart';
import 'package:inspecao_seguranca/models/tipo_veiculo.dart';
import 'package:inspecao_seguranca/screens/login.dart';
import 'package:inspecao_seguranca/screens/tsl_tab_bar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:inspecao_seguranca/transition_route_observer.dart';
import 'package:provider/provider.dart';
import 'package:inspecao_seguranca/models/tsl_data.dart';

import 'models/motorista_operador.dart';
import 'models/questao_comissio_veiculo.dart';
import 'models/veiculo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TSLData tslData = TSLData();
    tslData.carregaUser();
    tslData.carregaPrefs();
    return MultiProvider(
      providers: [
        StreamProvider.value(
          value: tslData.getEmpresas(),
          initialData: List<Empresa>.empty(growable: true),
        ),
        StreamProvider.value(
          value: tslData.getLocalidades(),
          initialData: List<Localidade>.empty(growable: true),
        ),
        StreamProvider.value(
          value: tslData.getQuestoesCampo(),
          initialData: List<QuestaoCampo>.empty(growable: true),
        ),
        StreamProvider.value(
          value: tslData.getQuestoesVeiculo(),
          initialData: List<QuestaoVeiculo>.empty(growable: true),
        ),
        StreamProvider.value(
          value: tslData.getQuestoesComissioVeiculo(),
          initialData: List<QuestaoComissioVeiculo>.empty(growable: true),
        ),
        StreamProvider.value(
          value: tslData.getTipoVeiculo(),
          initialData: List<TipoVeiculo>.empty(growable: true),
        ),
        StreamProvider.value(
          value: tslData.getFinalidadeVeiculo(),
          initialData: List<FinalidadeVeiculo>.empty(growable: true),
        ),
        StreamProvider.value(
          value: tslData.getVeiculos(),
          initialData: List<Veiculo>.empty(growable: true),
        ),
        StreamProvider.value(
          value: tslData.getMotoristasOperadores(),
          initialData: List<MotoristaOperador>.empty(growable: true),
        ),
        StreamProvider.value(
          value: tslData.getFuncoes(),
          initialData: List<Funcao>.empty(growable: true),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSwatch(primarySwatch: emflorMaterialGreen)
                  .copyWith(secondary: Colors.white),
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [Locale('pt', 'BR')],
        navigatorObservers: [TransitionRouteObserver()],
        initialRoute: LoginScreen.routeName,
        routes: {
          LoginScreen.routeName: (context) => const LoginScreen(),
          TSLTabBar.routeName: (context) => const TSLTabBar(usuario: ''),
        },
      ),
    );
  }
}

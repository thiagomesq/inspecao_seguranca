import 'package:inspecao_seguranca/constants.dart';
import 'package:inspecao_seguranca/models/tsl_data.dart';
import 'package:inspecao_seguranca/screens/checklists/c_comissio_veiculo.dart';
import 'package:inspecao_seguranca/screens/checklists/c_veiculo.dart';
import 'package:inspecao_seguranca/screens/creates/empresas.dart';
import 'package:inspecao_seguranca/screens/creates/funcoes.dart';
import 'package:inspecao_seguranca/screens/creates/motoristas_operadores.dart';
import 'package:inspecao_seguranca/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:inspecao_seguranca/screens/checklists/c_campo.dart';
import 'package:inspecao_seguranca/screens/creates/veiculos.dart';
import 'package:inspecao_seguranca/screens/reports/r_campo_nao_conformidade.dart';
import 'package:inspecao_seguranca/screens/reports/r_comissio_veiculo_nao_conformidade.dart';
import 'package:inspecao_seguranca/screens/reports/r_veiculo_nao_conformidade.dart';
import 'package:inspecao_seguranca/widgets/fade_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TSLTabBar extends StatefulWidget {
  static const routeName = '/tabbar';
  final String usuario;

  const TSLTabBar({Key? key, required this.usuario}) : super(key: key);

  @override
  _TSLTabBarState createState() => _TSLTabBarState();
}

class _TSLTabBarState extends State<TSLTabBar>
    with SingleTickerProviderStateMixin, RouteAware {
  Future<bool> _goToLogin(BuildContext context) async {
    TSLData tslData = TSLData();
    await tslData.logOut();
    return Navigator.of(context)
        .pushReplacementNamed('/auth')
        // we dont want to pop the screen, just replace it completely
        .then((_) => false);
  }

  final routeObserver = RouteObserver<Route<dynamic>>();
  static const headerAniInterval = Interval(.1, .3, curve: Curves.easeOut);
  AnimationController? _loadingController;
  late int _telaAtual;
  late String titulo;

  void _mudarTelaAtual(int tela) {
    setState(() {
      _telaAtual = tela;
      switch (tela) {
        case 0:
          titulo = 'EI Consultoria';
          break;
        case 1:
          titulo = 'Inspeção de Segurança';
          break;
        case 2:
          titulo = 'Cadastro de Veículos/Equipamentos';
          break;
        case 3:
          titulo = 'Inspeção de Veículo/Equipamentos';
          break;
        case 4:
          titulo = 'Relatório de Veículo/Equipamentos Não Conforme';
          break;
        case 5:
          titulo = 'Inspeção de Comissionamento de Veículos/Equipamentos';
          break;
        case 6:
          titulo =
              'Relatório de Comissionamento de Veículos/Equipamentos Não Conformes';
          break;
        case 7:
          titulo = 'Cadastro de Motoristas/Operadores';
          break;
        case 8:
          titulo = 'Relatório de Segurança Não Conforme';
          break;
        case 9:
          titulo = 'Cadastro de Funções';
          break;
        case 10:
          titulo = 'Cadastro de Empresas';
          break;
      }
    });
    Navigator.of(context).pop();
  }

  Widget _pegarTela(int tela) {
    switch (tela) {
      case 0:
        return HomeScreen(usuario: widget.usuario);
      case 1:
        return const CCampoScreen();
      case 2:
        return const VeiculosScreen();
      case 3:
        return const CVeiculoScreen();
      case 4:
        return const RVeiculosNaoConformidadeScreen();
      case 5:
        return const CComissioVeiculoScreen();
      case 6:
        return const RComissioVeiculosNaoConformidadeScreen();
      case 7:
        return const MotoristasOperadoresScreen();
      case 8:
        return const RCampoNaoConformidadeScreen();
      case 9:
        return const FuncoesScreen();
      case 10:
        return const EmpresasScreen();
    }
    return Container();
  }

  @override
  void initState() {
    super.initState();

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
    );

    _telaAtual = 0;
    titulo = 'EI Consultoria';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as Route<dynamic>);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _loadingController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _goToLogin(context),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            actions: [
              FadeIn(
                controller: _loadingController,
                offset: .3,
                curve: headerAniInterval,
                fadeDirection: FadeDirection.startToEnd,
                child: IconButton(
                  icon: const Icon(FontAwesomeIcons.signOutAlt),
                  color: Colors.white,
                  onPressed: () => _goToLogin(context),
                ),
              ),
            ],
            backgroundColor: emflorGreen,
            foregroundColor: Colors.white,
            title: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: FadeIn(
                      controller: _loadingController,
                      offset: .3,
                      curve: headerAniInterval,
                      fadeDirection: FadeDirection.topToBottom,
                      child: Text(
                        titulo,
                        maxLines: 3,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: emflorGreen,
                  ),
                  child: Center(
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  child: ListTile(
                    leading: const Icon(FontAwesomeIcons.home),
                    title: const Text('Tela Inicial'),
                    selected: _telaAtual == 0,
                    onTap: () {
                      _mudarTelaAtual(0);
                    },
                  ),
                  onPressed: () {},
                ),
                const Divider(
                  color: emflorSilver,
                ),
                const ListTile(
                  leading: Text(
                    'Listas de Verificação',
                    style: TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                ),
                TextButton(
                  child: ListTile(
                    leading: const Icon(FontAwesomeIcons.clipboardList),
                    title: const Text('Inspeção de Segurança'),
                    selected: _telaAtual == 1,
                    onTap: () {
                      _mudarTelaAtual(1);
                    },
                  ),
                  onPressed: () {},
                ),
                TextButton(
                  child: ListTile(
                    leading: const Icon(FontAwesomeIcons.clipboardList),
                    title: const Text('Inspeção de Veículo/Equipamentos'),
                    selected: _telaAtual == 3,
                    onTap: () {
                      _mudarTelaAtual(3);
                    },
                  ),
                  onPressed: () {},
                ),
                TextButton(
                  child: ListTile(
                    leading: const Icon(FontAwesomeIcons.clipboardList),
                    title: const Text(
                        'Inspeção de Comissionamento de Veículos/Equipamentos'),
                    selected: _telaAtual == 5,
                    onTap: () {
                      _mudarTelaAtual(5);
                    },
                  ),
                  onPressed: () {},
                ),
                const Divider(
                  color: emflorSilver,
                ),
                const ListTile(
                  leading: Text(
                    'Cadastros',
                    style: TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                ),
                TextButton(
                  child: ListTile(
                    leading: const Icon(FontAwesomeIcons.truck),
                    title: const Text('Veículos/Equipamentos'),
                    selected: _telaAtual == 2,
                    onTap: () {
                      _mudarTelaAtual(2);
                    },
                  ),
                  onPressed: () {},
                ),
                TextButton(
                  child: ListTile(
                    leading: const Icon(FontAwesomeIcons.userAlt),
                    title: const Text('Motoristas/Operadores'),
                    selected: _telaAtual == 7,
                    onTap: () {
                      _mudarTelaAtual(7);
                    },
                  ),
                  onPressed: () {},
                ),
                TextButton(
                  child: ListTile(
                    leading: const Icon(FontAwesomeIcons.cogs),
                    title: const Text('Funções'),
                    selected: _telaAtual == 9,
                    onTap: () {
                      _mudarTelaAtual(9);
                    },
                  ),
                  onPressed: () {},
                ),
                TextButton(
                  child: ListTile(
                    leading: const Icon(FontAwesomeIcons.solidBuilding),
                    title: const Text('Empresas'),
                    selected: _telaAtual == 10,
                    onTap: () {
                      _mudarTelaAtual(10);
                    },
                  ),
                  onPressed: () {},
                ),
                const Divider(
                  color: emflorSilver,
                ),
                const ListTile(
                  leading: Text(
                    'Relatórios',
                    style: TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                ),
                TextButton(
                  child: ListTile(
                    leading: const Icon(FontAwesomeIcons.solidFilePdf),
                    title: const Text('Relatório de Segurança Não Conforme'),
                    selected: _telaAtual == 8,
                    onTap: () {
                      _mudarTelaAtual(8);
                    },
                  ),
                  onPressed: () {},
                ),
                TextButton(
                  child: ListTile(
                    leading: const Icon(FontAwesomeIcons.solidFilePdf),
                    title: const Text(
                        'Relatório de Veículo/Equipamentos Não Conforme'),
                    selected: _telaAtual == 4,
                    onTap: () {
                      _mudarTelaAtual(4);
                    },
                  ),
                  onPressed: () {},
                ),
                TextButton(
                  child: ListTile(
                    leading: const Icon(FontAwesomeIcons.solidFilePdf),
                    title: const Text(
                        'Relatório de Comissionamento de Veículos/Equipamentos Não Conformes'),
                    selected: _telaAtual == 6,
                    onTap: () {
                      _mudarTelaAtual(6);
                    },
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          body: _pegarTela(_telaAtual),
        ),
      ),
    );
  }
}

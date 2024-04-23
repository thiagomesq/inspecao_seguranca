import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:inspecao_seguranca/core/enums/user_type.dart';
import 'package:inspecao_seguranca/ui/pages/cadastros/cadastros_page.dart';
import 'package:inspecao_seguranca/ui/pages/home/home_controller.dart';
import 'package:inspecao_seguranca/ui/pages/home/part/is_bottom_navigation_bar.dart';
import 'package:inspecao_seguranca/ui/pages/inspecoes/inspecoes_page.dart';
import 'package:inspecao_seguranca/ui/pages/relatorios/relatorios_page.dart';
import 'package:inspecao_seguranca/ui/shared/controller_provider.dart';
import 'package:inspecao_seguranca/ui/shared/is_app_bar.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final _screenOptions = <Widget>[
    const WelcomePage(),
    const CadastrosPage(),
    const InspecoesPage(),
    const RelatoriosPage(),
    const WelcomePage(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ControllerScope(
      create: (_) => HomeController(
        GetIt.I(),
      ),
      builder: (context, controller) {
        return Scaffold(
          appBar: const ISAppBar(),
          body: _screenOptions.elementAt(_selectedIndex),
          bottomNavigationBar: ISBottomNavigationBar(
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.add_circle_outline),
                activeIcon: const Icon(Icons.add_circle),
                label: controller.usuario.type == UserType.user
                    ? 'Listagens'
                    : 'Cadastros',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.list_alt_outlined),
                activeIcon: Icon(Icons.list_alt),
                label: 'Inspeções',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_outlined),
                activeIcon: Icon(Icons.bar_chart),
                label: 'Relatórios',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
                label: 'Configurações',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        );
      },
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ControllerScope.of<HomeController>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Hero(
              tag: 'logo',
              child: Image.asset(
                'assets/images/logo_ei.png',
                width: 204.18,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Text(
            'Bem vindo(a), ${controller.usuario.username}',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

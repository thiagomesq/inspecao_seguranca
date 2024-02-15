import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:inspecao_seguranca/ui/pages/empresa/empresa_page.dart';
import 'package:inspecao_seguranca/ui/pages/home/home_page.dart';
import 'package:inspecao_seguranca/ui/pages/login/login_page.dart';
import 'package:inspecao_seguranca/ui/pages/splash/splash_controller.dart';
import 'package:inspecao_seguranca/ui/shared/controller_provider.dart';

class SplashPage extends StatelessWidget {
  static const String routeName = '/';
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ControllerScope(
      create: (_) => SplashController(
        GetIt.I(),
        GetIt.I(),
        GetIt.I(),
        GetIt.I(),
        GetIt.I(),
        (isLogged, user) {
          Future.delayed(
            const Duration(seconds: 2),
            () {
              if (isLogged) {
                if (user!.id != null) {
                  Navigator.of(context).pushReplacementNamed(
                    HomePage.routeName,
                  );
                } else {
                  Navigator.of(context)
                      .pushReplacementNamed(EmpresaPage.routeName);
                }
              } else {
                Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
              }
            },
          );
        },
      ),
      builder: (context, controller) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
              ],
            ),
          ),
        );
      },
    );
  }
}

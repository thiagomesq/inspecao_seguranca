import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:inspecao_seguranca/core/enums/user_type.dart';
import 'package:inspecao_seguranca/core/models/plataforma.dart';
import 'package:inspecao_seguranca/ui/pages/relatorios/inspecao/inspecao_page.dart';
import 'package:inspecao_seguranca/ui/pages/relatorios/relatorios_controller.dart';
import 'package:inspecao_seguranca/ui/shared/controller_provider.dart';
import 'package:inspecao_seguranca/ui/shared/is_screen_button.dart';

class RelatoriosPage extends StatelessWidget {
  const RelatoriosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWeb = Plataforma.isWeb;
    final width = MediaQuery.of(context).size.width;
    return ControllerScope(
      create: (context) => RelatoriosController(
        GetIt.I(),
      ),
      builder: (context, controller) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isWeb ? width * 0.3 : 20,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.background,
          ),
          child: controller.usuario.type != UserType.user
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Relatórios',
                      style: theme.textTheme.titleLarge,
                    ),
                    Expanded(
                      child: GridView.count(
                        primary: false,
                        padding: const EdgeInsets.all(20),
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        crossAxisCount: isWeb ? 3 : 2,
                        children: const [
                          ISScreenButton(
                            texto: 'Relatório de Inspeção',
                            rota: RelatorioInspecaoPage.routeName,
                          )
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Você não tem permissão para acessar essa página.',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
        );
      },
    );
  }
}

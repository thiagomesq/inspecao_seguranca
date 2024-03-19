import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:inspecao_seguranca/core/models/plataforma.dart';
import 'package:inspecao_seguranca/ui/pages/inspecoes/inspecoes_controller.dart';
import 'package:inspecao_seguranca/ui/pages/inspecoes/resposta/resposta_page.dart';
import 'package:inspecao_seguranca/ui/shared/controller_provider.dart';
import 'package:inspecao_seguranca/ui/shared/is_fetch.dart';
import 'package:inspecao_seguranca/ui/shared/is_screen_button.dart';

class InspecoesPage extends StatelessWidget {
  const InspecoesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWeb = Plataforma.isWeb;
    final width = MediaQuery.of(context).size.width;
    return ControllerScope(
      create: (context) => InspecoesController(
        GetIt.I(),
        GetIt.I(),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Inspeções',
                style: theme.textTheme.titleLarge,
              ),
              Observer(builder: (_) {
                return ISFetch(
                  future: controller.inspecoesLoading,
                  onReload: () => controller.fetch(),
                  child: controller.inspecoes != null &&
                          controller.inspecoes!.isNotEmpty
                      ? Expanded(
                          child: GridView.count(
                            primary: false,
                            padding: const EdgeInsets.all(20),
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            crossAxisCount: isWeb ? 3 : 2,
                            children: [
                              ...controller.inspecoes!.map(
                                (inspecao) => ISScreenButton(
                                  texto: inspecao.nome!,
                                  rota: RespostaPage.routeName,
                                  onPressed: () => controller.inspecaoStore
                                      .setInspecao(inspecao),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Expanded(
                          child: ListView(
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Bem vindo(a) à tela de inspeções!',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    const TextSpan(
                                      text:
                                          '\nNão há inspeções cadastradas. Vá em "Cadastro de Inspeções" para adicionar uma nova inspeção.',
                                    ),
                                  ],
                                ),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

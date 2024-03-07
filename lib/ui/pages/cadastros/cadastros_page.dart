import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:inspecao_seguranca/core/enums/user_type.dart';
import 'package:inspecao_seguranca/core/models/plataforma.dart';
import 'package:inspecao_seguranca/ui/pages/cadastros/cadastros_controller.dart';
import 'package:inspecao_seguranca/ui/pages/cadastros/inspecao/inspecao_page.dart';
import 'package:inspecao_seguranca/ui/pages/cadastros/questao/questao_page.dart';
import 'package:inspecao_seguranca/ui/pages/cadastros/tipo_veiculo/tipo_veiculo_page.dart';
import 'package:inspecao_seguranca/ui/pages/cadastros/veiculo/veiculo_page.dart';
import 'package:inspecao_seguranca/ui/shared/controller_provider.dart';
import 'package:inspecao_seguranca/ui/shared/is_screen_button.dart';

class CadastrosPage extends StatelessWidget {
  const CadastrosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWeb = Plataforma.isWeb;
    final width = MediaQuery.of(context).size.width;
    return ControllerScope(
      create: (context) => CadastrosController(
        GetIt.I(),
      ),
      builder: (context, controller) {
        final isUser = controller.usuario.type == UserType.user;
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
                'Cadastros',
                style: theme.textTheme.titleLarge,
              ),
              Expanded(
                child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  crossAxisCount: isWeb ? 3 : 2,
                  children: [
                    !isUser
                        ? const ISScreenButton(
                            texto: 'Inspeção',
                            rota: InspecaoPage.routeName,
                          )
                        : const SizedBox.shrink(),
                    !isUser
                        ? const ISScreenButton(
                            texto: 'Tipo de Veículo',
                            rota: TipoVeiculoPage.routeName,
                          )
                        : const SizedBox.shrink(),
                    !isUser
                        ? const ISScreenButton(
                            texto: 'Questão',
                            rota: QuestaoPage.routeName,
                          )
                        : const SizedBox.shrink(),
                    const ISScreenButton(
                      texto: 'Veículo / Equipamento',
                      rota: VeiculoPage.routeName,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

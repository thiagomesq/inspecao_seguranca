import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:inspecao_seguranca/core/models/empresa.dart';
import 'package:inspecao_seguranca/core/models/plataforma.dart';
import 'package:inspecao_seguranca/ui/pages/home/home_page.dart';
import 'package:inspecao_seguranca/ui/pages/usuario/usuario_controller.dart';
import 'package:inspecao_seguranca/ui/shared/controller_provider.dart';
import 'package:inspecao_seguranca/ui/shared/is_app_bar.dart';
import 'package:inspecao_seguranca/ui/shared/is_fetch.dart';
import 'package:inspecao_seguranca/ui/shared/is_future_button.dart';
import 'package:inspecao_seguranca/ui/shared/is_text_field.dart';
import 'package:inspecao_seguranca/ui/shared/is_type_ahead_field.dart';

class UsuarioPage extends StatelessWidget {
  static const routeName = '/usuario';
  const UsuarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isWeb = Plataforma.isWeb;
    double width = MediaQuery.of(context).size.width;
    return ControllerScope(
      create: (_) => UsuarioController(
        GetIt.I(),
        GetIt.I(),
        GetIt.I(),
        GetIt.I(),
      ),
      builder: (context, controller) {
        return Scaffold(
          appBar: !isWeb ? const ISAppBar() : null,
          body: Observer(
            builder: (_) {
              return ISFetch(
                future: controller.userLoading,
                onReload: () => controller.fetch(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: !isWeb ? 16 : width * 0.3,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tela de Usuário',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        controller.isNewUser
                            ? 'Novo Usuário'
                            : 'Editar Usuaário',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 32),
                      Expanded(
                        child: Form(
                          child: ListView(
                            children: [
                              ISTextField(
                                labelText: 'Nome',
                                initialValue: controller.username,
                                onChanged: (value) =>
                                    controller.username = value,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Observer(builder: (_) {
                        return ISFutureButton(
                          futureBuilder: (_) => controller.save(),
                          isValid: controller.isFormValid,
                          onOk: (_, __) {
                            Navigator.of(context)
                                .pushReplacementNamed(HomePage.routeName);
                          },
                          child: const Text('Salvar'),
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

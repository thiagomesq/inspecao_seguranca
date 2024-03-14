import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:inspecao_seguranca/core/models/plataforma.dart';
import 'package:inspecao_seguranca/ui/pages/cadastros/funcionario/add_edit/add_edit_controller.dart';
import 'package:inspecao_seguranca/ui/shared/controller_provider.dart';
import 'package:inspecao_seguranca/ui/shared/is_app_bar.dart';
import 'package:inspecao_seguranca/ui/shared/is_dialog.dart';
import 'package:inspecao_seguranca/ui/shared/is_future_button.dart';
import 'package:inspecao_seguranca/ui/shared/is_text_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AddEditFuncioarioPage extends StatelessWidget {
  static const routeName = '/cadastros/funcionario/add_edit';
  const AddEditFuncioarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = Plataforma.isWeb;
    final width = MediaQuery.of(context).size.width;
    return ControllerScope(
      create: (context) => AddEditFuncionarioController(
        GetIt.I(),
        GetIt.I(),
        GetIt.I(),
      ),
      builder: (context, controller) {
        final phoneMask = MaskTextInputFormatter(
          mask: '(##) #####-####',
          filter: {"#": RegExp(r'[0-9]')},
          initialText: controller.telefone,
        );
        return Scaffold(
          appBar: const ISAppBar(),
          body: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isWeb ? width * 0.3 : 20,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
            ),
            child: Observer(
              builder: (_) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '${controller.funcionario == null ? 'Novo' : 'Edição de'} Funcionário(a)',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Form(
                        child: ListView(
                          padding: const EdgeInsets.all(0),
                          children: [
                            ISTextField(
                              labelText: 'Nome',
                              initialValue: controller.nome,
                              onChanged: (value) => controller.nome = value,
                            ),
                            const SizedBox(height: 16),
                            ISTextField(
                              keyboardType: TextInputType.phone,
                              labelText: 'Celular',
                              onChanged: (value) => controller.telefone = value,
                              inputFormatters: [
                                phoneMask,
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Observer(
                      builder: (_) {
                        return ISFutureButton(
                          futureBuilder: (_) => controller.save(),
                          isValid: controller.isFormValid,
                          onOk: (_, __) async {
                            await showAlert(
                              context: context,
                              title: 'Sucesso!',
                              textContent:
                                  'Fucionário(a) salvo(a) com sucesso!',
                            );
                            Navigator.of(context).pop();
                          },
                          child: const Text('Salvar'),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

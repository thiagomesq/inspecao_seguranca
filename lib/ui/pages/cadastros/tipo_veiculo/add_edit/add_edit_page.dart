import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:inspecao_seguranca/core/models/plataforma.dart';
import 'package:inspecao_seguranca/ui/pages/cadastros/tipo_veiculo/add_edit/add_edit_controller.dart';
import 'package:inspecao_seguranca/ui/shared/controller_provider.dart';
import 'package:inspecao_seguranca/ui/shared/is_app_bar.dart';
import 'package:inspecao_seguranca/ui/shared/is_dialog.dart';
import 'package:inspecao_seguranca/ui/shared/is_future_button.dart';
import 'package:inspecao_seguranca/ui/shared/is_text_field.dart';

class AddEditTipoVeiculoPage extends StatelessWidget {
  static const routeName = '/cadastros/tipo_veiculo/add_edit';
  const AddEditTipoVeiculoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = Plataforma.isWeb;
    final width = MediaQuery.of(context).size.width;
    return ControllerScope(
      create: (context) => AddEditTipoVeiculoController(
        GetIt.I(),
        GetIt.I(),
      ),
      builder: (context, controller) {
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
                      '${controller.tipoVeiculo == null ? 'Novo' : 'Edição de'} Tipo de Veículo / Equipamento',
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
                                  'Tipo de veículo / equipamento salvo com sucesso!',
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

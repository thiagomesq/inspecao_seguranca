import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:inspecao_seguranca/core/enums/user_type.dart';
import 'package:inspecao_seguranca/core/models/plataforma.dart';
import 'package:inspecao_seguranca/ui/pages/cadastros/veiculo/add_edit/add_edit_controller.dart';
import 'package:inspecao_seguranca/ui/shared/controller_provider.dart';
import 'package:inspecao_seguranca/ui/shared/is_app_bar.dart';
import 'package:inspecao_seguranca/ui/shared/is_dialog.dart';
import 'package:inspecao_seguranca/ui/shared/is_dropdown_button.dart';
import 'package:inspecao_seguranca/ui/shared/is_fetch.dart';
import 'package:inspecao_seguranca/ui/shared/is_future_button.dart';
import 'package:inspecao_seguranca/ui/shared/is_text_field.dart';

class AddEditVeiculoPage extends StatelessWidget {
  static const routeName = '/cadastros/veiculo/add_edit';
  const AddEditVeiculoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = Plataforma.isWeb;
    final width = MediaQuery.of(context).size.width;
    return ControllerScope(
      create: (context) => AddEditVeiculoController(
        GetIt.I(),
        GetIt.I(),
        GetIt.I(),
        GetIt.I(),
        GetIt.I(),
      ),
      builder: (context, controller) {
        final isMaster = controller.usuario.type == UserType.master;
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
                List<DropdownMenuItem<String>> tiposVeiculoItems = [
                  const DropdownMenuItem(
                    value: '',
                    child: Text('Selecione o tipo de veículo'),
                  ),
                ];
                if (controller.tiposVeiculo != null) {
                  if (controller.tiposVeiculo!.length > 1) {
                    controller.tiposVeiculo!
                        .sort((a, b) => a.nome!.compareTo(b.nome!));
                  }
                  tiposVeiculoItems.addAll(controller.tiposVeiculo!
                      .map(
                        (e) => DropdownMenuItem(
                          value: e.id,
                          child: Text(e.nome!),
                        ),
                      )
                      .toList());
                }
                List<DropdownMenuItem<String>> empresasItems = [];
                if (isMaster) {
                  empresasItems = [
                    const DropdownMenuItem(
                      value: '',
                      child: Text('Selecione a empresa'),
                    ),
                  ];
                  if (controller.empresas != null) {
                    if (controller.empresas!.length > 1) {
                      controller.empresas!.sort(
                          (a, b) => a.nomeFantasia!.compareTo(b.nomeFantasia!));
                    }
                    empresasItems.addAll(controller.empresas!
                        .map(
                          (e) => DropdownMenuItem(
                            value: e.id,
                            child: Text(e.nomeFantasia!),
                          ),
                        )
                        .toList());
                  }
                }
                return ISFetch(
                  future: controller.tiposVeiculoLoading,
                  onReload: () => controller.fetch(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '${controller.veiculo == null ? 'Novo' : 'Edição de'} Veículo',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Form(
                          child: ListView(
                            padding: const EdgeInsets.all(0),
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: ISTextField(
                                      labelText: 'Placa / Identificador',
                                      initialValue: controller.placa,
                                      onChanged: (value) =>
                                          controller.placa = value,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Observer(
                                    builder: (_) {
                                      return Expanded(
                                        flex: 2,
                                        child: ISFutureButton<dynamic>(
                                          futureBuilder: (_) =>
                                              controller.placaAvailable(),
                                          isValid: controller.placa != null &&
                                              controller.placa!.length == 7,
                                          onOk: (_, msg) async {
                                            String title = '';
                                            if (msg == 'Placa já cadastrada') {
                                              title = 'Atenção!';
                                            } else {
                                              title = 'Sucesso!';
                                            }
                                            await showAlert(
                                              context: context,
                                              title: title,
                                              textContent: msg,
                                            );
                                            controller.placaValid =
                                                msg != 'Placa já cadastrada';
                                          },
                                          child: const Text('Verificar Placa'),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: ISTextField(
                                      labelText: 'Ano',
                                      initialValue: controller.ano?.toString(),
                                      onChanged: (value) =>
                                          controller.ano = int.tryParse(value),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    flex: 4,
                                    child: ISDropdownButton(
                                      labelText: 'Tipo de Veículo',
                                      initialValue: controller.tipo,
                                      items: tiposVeiculoItems,
                                      onChanged: (value) =>
                                          controller.tipo = value,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              if (isMaster)
                                ISDropdownButton(
                                  labelText: 'Empresa',
                                  initialValue: controller.empresa,
                                  items: empresasItems,
                                  onChanged: (value) =>
                                      controller.empresa = value,
                                ),
                              const SizedBox(height: 16),
                              ISTextField(
                                labelText: 'Finalidade',
                                initialValue: controller.finalidade,
                                onChanged: (value) =>
                                    controller.finalidade = value,
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
                                    'Veículo / Equipamento salvo com sucesso!',
                              );
                              Navigator.of(context).pop();
                            },
                            child: const Text('Salvar'),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

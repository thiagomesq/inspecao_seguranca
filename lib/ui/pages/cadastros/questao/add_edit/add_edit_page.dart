import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:inspecao_seguranca/core/models/plataforma.dart';
import 'package:inspecao_seguranca/ui/pages/cadastros/questao/add_edit/add_edit_controller.dart';
import 'package:inspecao_seguranca/ui/shared/controller_provider.dart';
import 'package:inspecao_seguranca/ui/shared/is_app_bar.dart';
import 'package:inspecao_seguranca/ui/shared/is_button.dart';
import 'package:inspecao_seguranca/ui/shared/is_dialog.dart';
import 'package:inspecao_seguranca/ui/shared/is_dropdown_button.dart';
import 'package:inspecao_seguranca/ui/shared/is_fetch.dart';
import 'package:inspecao_seguranca/ui/shared/is_future_button.dart';
import 'package:inspecao_seguranca/ui/shared/is_text_field.dart';

class AddEditQuestaoPage extends StatelessWidget {
  static const routeName = '/cadastros/questao/add_edit';
  const AddEditQuestaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = Plataforma.isWeb;
    final width = MediaQuery.of(context).size.width;
    return ControllerScope(
      create: (context) => AddEditQuestaoController(
        GetIt.I(),
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
                List<DropdownMenuItem<String>> tiposVeiculosItems = [
                  const DropdownMenuItem(
                    value: '',
                    child: Text('Selecione um tipo de veículo'),
                  ),
                ];
                if (controller.tvs != null) {
                  if (controller.tvs!.length > 1) {
                    tiposVeiculosItems.add(
                      const DropdownMenuItem(
                        value: 'todos',
                        child: Text('Todos'),
                      ),
                    );
                    controller.tvs!.sort((a, b) => a.nome!.compareTo(b.nome!));
                  }
                  tiposVeiculosItems.addAll(controller.tvs!
                      .map(
                        (e) => DropdownMenuItem(
                          value: e.id,
                          child: Text(e.nome!),
                        ),
                      )
                      .toList());
                }
                return ISFetch(
                  future: controller.tvsLoading,
                  onReload: () => controller.fetch(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '${controller.questao == null ? 'Nova' : 'Edição de'} Questão',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Form(
                          child: ListView(
                            padding: const EdgeInsets.all(0),
                            children: [
                              ISTextField(
                                labelText: 'Título',
                                initialValue: controller.titulo,
                                onChanged: (value) => controller.titulo = value,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Observer(
                                    builder: (_) {
                                      return Expanded(
                                        flex: 2,
                                        child: ISDropdownButton(
                                          labelText: 'Tipo de Veículo',
                                          initialValue: controller.tipoVeiculo,
                                          items: tiposVeiculosItems,
                                          onChanged: (value) {
                                            controller.tipoVeiculo = value;
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  Observer(
                                    builder: (_) {
                                      return Expanded(
                                        child: ISButton(
                                          isValid: controller
                                                  .tipoVeiculo.isNotEmpty &&
                                              !controller.tiposVeiculo.contains(
                                                  controller.tipoVeiculo),
                                          onPressed: () {
                                            if (controller.tipoVeiculo ==
                                                'todos') {
                                              for (var e in controller.tvs!) {
                                                if (!controller.tiposVeiculo
                                                    .contains(e.id)) {
                                                  controller.tiposVeiculo
                                                      .add(e.id!);
                                                }
                                              }
                                            } else {
                                              controller.tiposVeiculo
                                                  .add(controller.tipoVeiculo);
                                            }
                                          },
                                          child: const Text('Adicionar'),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Tipos de Veículos selecionados:',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 20),
                              Observer(
                                builder: (_) {
                                  return controller.tiposVeiculo.isEmpty
                                      ? const Text(
                                          'Nenhum tipo de veículo selecionado')
                                      : Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: controller.tiposVeiculo
                                              .map(
                                                (e) => Chip(
                                                  label: Text(
                                                    controller.tvs!
                                                        .firstWhere((element) =>
                                                            element.id == e)
                                                        .nome!,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                  ),
                                                  onDeleted: () {
                                                    controller.tiposVeiculo
                                                        .remove(e);
                                                  },
                                                ),
                                              )
                                              .toList(),
                                        );
                                },
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
                                textContent: 'Questão salva com sucesso!',
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

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:inspecao_seguranca/core/models/inspecao_questao.dart';
import 'package:inspecao_seguranca/core/models/plataforma.dart';
import 'package:inspecao_seguranca/ui/pages/cadastros/inspecao/add_edit/add_edit_controller.dart';
import 'package:inspecao_seguranca/ui/shared/controller_provider.dart';
import 'package:inspecao_seguranca/ui/shared/is_app_bar.dart';
import 'package:inspecao_seguranca/ui/shared/is_button.dart';
import 'package:inspecao_seguranca/ui/shared/is_dialog.dart';
import 'package:inspecao_seguranca/ui/shared/is_dropdown_button.dart';
import 'package:inspecao_seguranca/ui/shared/is_fetch.dart';
import 'package:inspecao_seguranca/ui/shared/is_future_button.dart';
import 'package:inspecao_seguranca/ui/shared/is_text_field.dart';

class AddEditInspecaoPage extends StatelessWidget {
  static const routeName = '/cadastros/inspecao/add_edit';
  const AddEditInspecaoPage({super.key});

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(0, 6, animValue)!;
        return Material(
          elevation: elevation,
          color: Theme.of(context).colorScheme.surface,
          shadowColor: Theme.of(context).colorScheme.surface,
          child: child,
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = Plataforma.isWeb;
    final width = MediaQuery.of(context).size.width;
    return ControllerScope(
      create: (context) => AddEditInspecaoController(
        GetIt.I(),
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
                List<DropdownMenuItem<String>> questoesItems = [
                  const DropdownMenuItem(
                    value: '',
                    child: Text('Selecione uma questão'),
                  ),
                ];
                if (controller.questoes != null) {
                  if (controller.questoes!.length > 1) {
                    controller.questoes!
                        .sort((a, b) => a.titulo!.compareTo(b.titulo!));
                  }
                  questoesItems.addAll(controller.questoes!
                      .map(
                        (e) => DropdownMenuItem(
                          value: e.id,
                          child: Text(e.titulo!),
                        ),
                      )
                      .toList());
                }
                return ISFetch(
                  future: controller.questoesLoading,
                  onReload: () => controller.fetch(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '${controller.inspecao == null ? 'Nova' : 'Edição de'} Inspeção',
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
                                labelText: 'Descrição',
                                initialValue: controller.descricao,
                                onChanged: (value) =>
                                    controller.descricao = value,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Observer(
                                    builder: (_) {
                                      return Expanded(
                                        flex: 2,
                                        child: ISDropdownButton(
                                          labelText: 'Questão',
                                          initialValue: controller.questao,
                                          items: questoesItems,
                                          onChanged: (value) {
                                            controller.questao = value;
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
                                          isValid:
                                              controller.questao.isNotEmpty &&
                                                  !controller.inspecaoQuestoes
                                                      .any((e) =>
                                                          e.questao ==
                                                          controller.questao),
                                          onPressed: () {
                                            final inspecaoQuestao =
                                                InspecaoQuestao(
                                              questao: controller.questao,
                                              ordem: controller
                                                      .inspecaoQuestoes.length +
                                                  1,
                                            );
                                            controller.inspecaoQuestoes
                                                .add(inspecaoQuestao);
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
                                'Questões selecionadas:',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Observer(
                        builder: (_) {
                          return Expanded(
                            child: ReorderableListView(
                              proxyDecorator: proxyDecorator,
                              onReorder: (oldIndex, newIndex) {
                                if (oldIndex < newIndex) {
                                  newIndex -= 1;
                                }
                                final item = controller.inspecaoQuestoes
                                    .removeAt(oldIndex);
                                item.ordem = newIndex + 1;
                                controller.inspecaoQuestoes
                                    .insert(newIndex, item);
                              },
                              children: controller.inspecaoQuestoes
                                  .map(
                                    (e) => Card(
                                      key: ValueKey(e.id),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      child: SizedBox(
                                        height: 60,
                                        child: Center(
                                          child: ListTile(
                                            title: Text(
                                              controller.questoes!
                                                  .firstWhere(
                                                    (q) => q.id == e.questao,
                                                  )
                                                  .titulo!,
                                            ),
                                            trailing: IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                controller.inspecaoQuestoes
                                                    .remove(e);
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          );
                        },
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
                                textContent: 'Inspeção salva com sucesso!',
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

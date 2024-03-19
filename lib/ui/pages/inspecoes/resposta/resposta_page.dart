import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:inspecao_seguranca/core/models/plataforma.dart';
import 'package:inspecao_seguranca/core/models/resposta.dart';
import 'package:inspecao_seguranca/core/models/veiculo.dart';
import 'package:inspecao_seguranca/ui/pages/inspecoes/resposta/resposta_controller.dart';
import 'package:inspecao_seguranca/ui/shared/controller_provider.dart';
import 'package:inspecao_seguranca/ui/shared/is_app_bar.dart';
import 'package:inspecao_seguranca/ui/shared/is_dialog.dart';
import 'package:inspecao_seguranca/ui/shared/is_fetch.dart';
import 'package:inspecao_seguranca/ui/shared/is_future_button.dart';
import 'package:inspecao_seguranca/ui/shared/is_text_field.dart';
import 'package:inspecao_seguranca/ui/shared/is_type_ahead_field.dart';

class RespostaPage extends StatelessWidget {
  static const String routeName = '/inspecoes/resposta';
  const RespostaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWeb = Plataforma.isWeb;
    final width = MediaQuery.of(context).size.width;
    return ControllerScope(
      create: (_) => RespostaController(
        GetIt.I(),
        GetIt.I(),
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
              color: theme.colorScheme.background,
            ),
            child: Observer(
              builder: (_) {
                return ISFetch(
                  future: controller.inspecaoQuestoesLoading,
                  onReload: () => controller.fetch(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        controller.inspecao.nome!,
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.inspecao.descricao!,
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 16),
                      Observer(
                        builder: (_) {
                          return Text(
                            'Data: ${controller.data}',
                            style: theme.textTheme.bodyMedium,
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      ISTypeAheadField<Veiculo>(
                        labelText: 'Placa',
                        initialValue: controller.placa,
                        onSuggestionSelected: (veiculo) {
                          controller.placa = veiculo.placa;
                        },
                        itemBuilder: (context, veiculo) => ListTile(
                          title: Text(veiculo.placa!),
                        ),
                        suggestionsCallback: (pattern) {
                          if (controller.veiculos.isEmpty) {
                            return [];
                          }
                          return controller.veiculos
                              .where((veiculo) => veiculo.placa!
                                  .toLowerCase()
                                  .contains(pattern.toLowerCase()))
                              .toList();
                        },
                      ),
                      const SizedBox(height: 16),
                      controller.inspecaoQuestoes != null &&
                              controller.inspecaoQuestoes!.isNotEmpty &&
                              controller.questoes.isNotEmpty &&
                              controller.respostas.isNotEmpty
                          ? Expanded(
                              child: Observer(
                                builder: (_) {
                                  return ListView.builder(
                                    itemCount: controller.questoes.length,
                                    itemBuilder: (context, index) {
                                      final inspecaoQuestao =
                                          controller.inspecaoQuestoes![index];
                                      final questao = controller.questoes
                                          .firstWhere((questao) =>
                                              questao.id ==
                                              inspecaoQuestao.questao!);
                                      final resposta = controller.respostas
                                          .firstWhere((resposta) =>
                                              resposta.inspecaoQuestao ==
                                              inspecaoQuestao.id);
                                      return RespostaCard(
                                        resposta: resposta,
                                        titulo: questao.titulo!,
                                        ordem:
                                            inspecaoQuestao.ordem!.toString(),
                                        index: index,
                                      );
                                    },
                                  );
                                },
                              ),
                            )
                          : const CircularProgressIndicator(),
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
                                    'Inspeção - ${controller.inspecao.nome} salva com sucesso!',
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

class RespostaCard extends StatelessWidget {
  final Resposta resposta;
  final String titulo;
  final String ordem;
  final int index;
  const RespostaCard({
    super.key,
    required this.resposta,
    required this.titulo,
    required this.ordem,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = ControllerScope.of<RespostaController>(context);
    return Column(
      children: [
        Material(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: theme.colorScheme.secondary,
              width: 2,
            ),
          ),
          color: theme.colorScheme.surface,
          child: Observer(builder: (_) {
            return ListTile(
              title: Text(
                titulo,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: theme.colorScheme.tertiary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Text(
                ordem,
                style: theme.textTheme.bodySmall!.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Observer(
                builder: (_) {
                  return Checkbox(
                    value: controller.isOks[index],
                    onChanged: (value) {
                      resposta.isOk = value!;
                      controller.isOks[index] = value;
                      controller.respostas[index] = resposta;
                    },
                  );
                },
              ),
              subtitle: !controller.isOks[index]
                  ? ISTextField(
                      labelText: 'Descrição NC',
                      onChanged: (value) {
                        resposta.dscNC = value;
                        controller.dscNCs[index] = value;
                        controller.respostas[index] = resposta;
                      },
                    )
                  : null,
            );
          }),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

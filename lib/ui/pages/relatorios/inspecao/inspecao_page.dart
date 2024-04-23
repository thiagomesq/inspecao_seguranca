import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:inspecao_seguranca/core/models/plataforma.dart';
import 'package:inspecao_seguranca/core/models/report_data.dart';
import 'package:inspecao_seguranca/ui/pages/relatorios/inspecao/inspecao_controller.dart';
import 'package:inspecao_seguranca/ui/pages/relatorios/pdf_viewer/pdf_viewer_page.dart';
import 'package:inspecao_seguranca/ui/shared/controller_provider.dart';
import 'package:inspecao_seguranca/ui/shared/is_app_bar.dart';
import 'package:inspecao_seguranca/ui/shared/is_dropdown_button.dart';
import 'package:inspecao_seguranca/ui/shared/is_fetch.dart';
import 'package:inspecao_seguranca/ui/shared/is_future_button.dart';
import 'package:inspecao_seguranca/ui/shared/is_text_field.dart';

class RelatorioInspecaoPage extends StatelessWidget {
  static const routeName = '/relatorios/inspecao';
  const RelatorioInspecaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWeb = Plataforma.isWeb;
    final width = MediaQuery.of(context).size.width;
    return ControllerScope(
      create: (_) => InspecaoController(
        GetIt.I(),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Relatório de Inpeção',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Observer(
                  builder: (_) {
                    List<DropdownMenuItem<String>> inspecoesItems = [
                      const DropdownMenuItem(
                        value: '',
                        child: Text('Selecione a inspecão'),
                      )
                    ];
                    if (controller.inspecoes.isNotEmpty) {
                      if (controller.inspecoes.length > 1) {
                        controller.inspecoes
                            .sort((a, b) => a.nome!.compareTo(b.nome!));
                      }
                      inspecoesItems.addAll(controller.inspecoes
                          .map(
                            (inspecao) => DropdownMenuItem(
                              value: inspecao.id,
                              child: Text(inspecao.nome!),
                            ),
                          )
                          .toList());
                    }
                    List<DropdownMenuItem<String>> usuariosItems = [
                      const DropdownMenuItem(
                        value: '',
                        child: Text('Selecione o usuário'),
                      )
                    ];
                    if (controller.usuarios.isNotEmpty) {
                      if (controller.usuarios.length > 1) {
                        controller.usuarios
                            .sort((a, b) => a.username!.compareTo(b.username!));
                      }
                      usuariosItems.addAll(controller.usuarios
                          .map(
                            (usuario) => DropdownMenuItem(
                              value: usuario.id,
                              child: Text(usuario.username!),
                            ),
                          )
                          .toList());
                    }

                    return ISFetch(
                      future: controller.inspecoesLoading,
                      onReload: () => controller.fetch(),
                      child: Expanded(
                        child: Form(
                          child: ListView(
                            padding: const EdgeInsets.all(0),
                            children: [
                              ISTextField(
                                controller: TextEditingController(),
                                initialValue: controller.data,
                                labelText: 'Data',
                                isDatePicker: true,
                                onChanged: (value) async {
                                  controller.data = value;
                                  if (controller.inspecao.isNotEmpty &&
                                      controller.usuario.isNotEmpty) {
                                    await controller.getVeiculos();
                                  }
                                },
                              ),
                              const SizedBox(height: 16),
                              ISDropdownButton(
                                labelText: 'Inspeção',
                                initialValue: controller.inspecao,
                                items: inspecoesItems,
                                onChanged: (value) async {
                                  controller.inspecao = value.toString();
                                  if (controller.usuario.isNotEmpty &&
                                      controller.data.isNotEmpty) {
                                    await controller.getVeiculos();
                                  }
                                },
                              ),
                              const SizedBox(height: 16),
                              ISDropdownButton(
                                labelText: 'Usuário',
                                initialValue: controller.usuario,
                                items: usuariosItems,
                                onChanged: (value) async {
                                  controller.usuario = value.toString();
                                  if (controller.inspecao.isNotEmpty &&
                                      controller.data.isNotEmpty) {
                                    await controller.getVeiculos();
                                  }
                                },
                              ),
                              const SizedBox(height: 16),
                              Observer(
                                builder: (_) {
                                  return controller.veiculos.isEmpty
                                      ? const SizedBox.shrink()
                                      : ISDropdownButton(
                                          labelText: 'Veículo',
                                          initialValue: controller.veiculo,
                                          items: controller.veiculos
                                              .map(
                                                (veiculo) => DropdownMenuItem(
                                                  value: veiculo.placa,
                                                  child: Text(
                                                    '${veiculo.placa!} - ${veiculo.finalidade!}',
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (value) {
                                            controller.veiculo = value;
                                          },
                                        );
                                },
                              ),
                              const SizedBox(height: 16),
                              Observer(
                                builder: (_) {
                                  return ISFutureButton<dynamic>(
                                    futureBuilder: (_) =>
                                        controller.gerarRelatorio(),
                                    isValid: controller.isFormValid,
                                    onOk: (_, bytes) async {
                                      await Navigator.of(context).pushNamed(
                                        PdfViewerPage.routeName,
                                        arguments: RelatorioData(
                                          bytes: bytes,
                                          orietacao: 'paisagem',
                                        ),
                                      );
                                    },
                                    child: const Text('Gerar relatório'),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

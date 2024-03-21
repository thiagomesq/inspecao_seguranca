import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:inspecao_seguranca/core/models/plataforma.dart';
import 'package:inspecao_seguranca/core/models/tipo_veiculo.dart';
import 'package:inspecao_seguranca/ui/pages/cadastros/tipo_veiculo/add_edit/add_edit_page.dart';
import 'package:inspecao_seguranca/ui/pages/cadastros/tipo_veiculo/tipo_veiculo_controller.dart';
import 'package:inspecao_seguranca/ui/shared/controller_provider.dart';
import 'package:inspecao_seguranca/ui/shared/is_app_bar.dart';
import 'package:inspecao_seguranca/ui/shared/is_button.dart';
import 'package:inspecao_seguranca/ui/shared/is_fetch.dart';
import 'package:inspecao_seguranca/ui/shared/is_future_button.dart';

class TipoVeiculoPage extends StatelessWidget {
  static const routeName = '/cadastros/tipo_veiculo';
  const TipoVeiculoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWeb = Plataforma.isWeb;
    final width = MediaQuery.of(context).size.width;
    return ControllerScope(
      create: (context) => TipoVeiculoController(
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
                  'Tipos de Veículo / Equipamento',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Observer(
                  builder: (_) {
                    return ISFetch(
                      future: controller.tipoVeiculosLoading,
                      onReload: () => controller.fetch(),
                      child: controller.tipoVeiculos != null &&
                              controller.tipoVeiculos!.isNotEmpty
                          ? Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      itemBuilder: (context, index) {
                                        final tipoVeiculo =
                                            controller.tipoVeiculos![index];
                                        return TipoVeiculoCard(
                                            tipoVeiculo: tipoVeiculo);
                                      },
                                      itemCount:
                                          controller.tipoVeiculos!.length,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ISButton(
                                    onPressed: () async {
                                      controller.cadastroTipoVeiculoStore
                                          .clear();
                                      await Navigator.of(context).pushNamed(
                                        AddEditTipoVeiculoPage.routeName,
                                      );
                                      controller.fetch();
                                    },
                                    isIconButton: true,
                                    backgroundColor: theme.colorScheme.primary,
                                    foregroundColor:
                                        theme.colorScheme.onPrimary,
                                    child: const Icon(Icons.list_alt),
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
                                          text:
                                              'Bem vindo(a) ao cadastro de tipos de veículo / equipamento!',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                        const TextSpan(
                                          text:
                                              '\nAqui você pode cadastrar os tipos de veículo / equipamento que serão inspecionados.',
                                        ),
                                      ],
                                    ),
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 16),
                                  ISButton(
                                    onPressed: () async {
                                      await Navigator.of(context).pushNamed(
                                        AddEditTipoVeiculoPage.routeName,
                                      );
                                      controller.fetch();
                                    },
                                    isIconButton: true,
                                    backgroundColor: theme.colorScheme.primary,
                                    foregroundColor:
                                        theme.colorScheme.onPrimary,
                                    child: const Icon(Icons.list_alt),
                                  ),
                                ],
                              ),
                            ),
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class TipoVeiculoCard extends StatelessWidget {
  final TipoVeiculo tipoVeiculo;
  const TipoVeiculoCard({super.key, required this.tipoVeiculo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = ControllerScope.of<TipoVeiculoController>(context);
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
          child: ListTile(
            onTap: () async {
              controller.cadastroTipoVeiculoStore.setTipoVeiculo(tipoVeiculo);
              await Navigator.of(context).pushNamed(
                AddEditTipoVeiculoPage.routeName,
              );
              controller.fetch();
            },
            title: Text(
              tipoVeiculo.nome!,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.tertiary,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: ISFutureButton(
              futureBuilder: (_) => controller.delete(tipoVeiculo.id!),
              confirmText:
                  'Tem certeza que deseja excluir esse tipo de veículo / equipamento?',
              isIconButton: true,
              onOk: (_, __) => controller.fetch(),
              child: const Icon(Icons.delete_outline, color: Colors.red),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

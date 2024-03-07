import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:inspecao_seguranca/core/enums/user_type.dart';
import 'package:inspecao_seguranca/core/models/plataforma.dart';
import 'package:inspecao_seguranca/core/models/veiculo.dart';
import 'package:inspecao_seguranca/ui/pages/cadastros/veiculo/add_edit/add_edit_page.dart';
import 'package:inspecao_seguranca/ui/pages/cadastros/veiculo/veiculo_controller.dart';
import 'package:inspecao_seguranca/ui/shared/controller_provider.dart';
import 'package:inspecao_seguranca/ui/shared/is_app_bar.dart';
import 'package:inspecao_seguranca/ui/shared/is_button.dart';
import 'package:inspecao_seguranca/ui/shared/is_fetch.dart';
import 'package:inspecao_seguranca/ui/shared/is_future_button.dart';

class VeiculoPage extends StatelessWidget {
  static const routeName = '/cadastros/veiculo';
  const VeiculoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWeb = Plataforma.isWeb;
    final width = MediaQuery.of(context).size.width;
    return ControllerScope(
      create: (context) => VeiculoController(
        GetIt.I(),
        GetIt.I(),
        GetIt.I(),
        GetIt.I(),
      ),
      builder: (context, controller) {
        final isUser = controller.usuario.type == UserType.user;
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
                  'Veículos / Equipamentos',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Observer(
                  builder: (_) {
                    return ISFetch(
                      future: controller.veiculosLoading,
                      onReload: () => controller.fetch(),
                      child: controller.veiculos != null &&
                              controller.veiculos!.isNotEmpty
                          ? Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      itemBuilder: (context, index) {
                                        final tipoVeiculo =
                                            controller.veiculos![index];
                                        return VeiculoCard(
                                            veiculo: tipoVeiculo);
                                      },
                                      itemCount: controller.veiculos!.length,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  !isUser
                                      ? ISButton(
                                          onPressed: () async {
                                            controller.cadastroVeiculoStore
                                                .clear();
                                            await Navigator.of(context)
                                                .pushNamed(
                                              AddEditVeiculoPage.routeName,
                                            );
                                            controller.fetch();
                                          },
                                          isIconButton: true,
                                          backgroundColor:
                                              theme.colorScheme.primary,
                                          foregroundColor:
                                              theme.colorScheme.onPrimary,
                                          child:
                                              const Icon(Icons.local_shipping),
                                        )
                                      : const SizedBox.shrink(),
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
                                              'Bem vindo(a) ao cadastro de veículos / equipamentos!',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                        TextSpan(
                                          text: !isUser
                                              ? '\nAqui você pode cadastrar os veículos / equipamentos que serão inspecionados.'
                                              : '\nAqui você pode visualizar os veículos / equipamentos a serem inspecionados.',
                                        ),
                                      ],
                                    ),
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 16),
                                  !isUser
                                      ? ISButton(
                                          onPressed: () async {
                                            controller.cadastroVeiculoStore
                                                .clear();
                                            await Navigator.of(context)
                                                .pushNamed(
                                              AddEditVeiculoPage.routeName,
                                            );
                                            controller.fetch();
                                          },
                                          isIconButton: true,
                                          backgroundColor:
                                              theme.colorScheme.primary,
                                          foregroundColor:
                                              theme.colorScheme.onPrimary,
                                          child:
                                              const Icon(Icons.local_shipping),
                                        )
                                      : const SizedBox.shrink(),
                                ],
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

class VeiculoCard extends StatelessWidget {
  final Veiculo veiculo;
  const VeiculoCard({super.key, required this.veiculo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = ControllerScope.of<VeiculoController>(context);
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
              controller.cadastroVeiculoStore.setVeiculo(veiculo);
              await Navigator.of(context).pushNamed(
                AddEditVeiculoPage.routeName,
              );
              controller.fetch();
            },
            title: Text(
              veiculo.placa!,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.tertiary,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              veiculo.finalidade!,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.tertiary,
              ),
            ),
            trailing: ISFutureButton(
              futureBuilder: (_) => controller.delete(veiculo.placa!),
              confirmText:
                  'Tem certeza que deseja excluir esse veículo / equipamento?',
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

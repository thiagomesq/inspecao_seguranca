import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:inspecao_seguranca/core/enums/user_type.dart';
import 'package:inspecao_seguranca/core/models/inspecao.dart';
import 'package:inspecao_seguranca/core/models/plataforma.dart';
import 'package:inspecao_seguranca/ui/pages/cadastros/inspecao/add_edit/add_edit_page.dart';
import 'package:inspecao_seguranca/ui/pages/cadastros/inspecao/inspecao_controller.dart';
import 'package:inspecao_seguranca/ui/shared/controller_provider.dart';
import 'package:inspecao_seguranca/ui/shared/is_app_bar.dart';
import 'package:inspecao_seguranca/ui/shared/is_button.dart';
import 'package:inspecao_seguranca/ui/shared/is_fetch.dart';
import 'package:inspecao_seguranca/ui/shared/is_future_button.dart';

class InspecaoPage extends StatelessWidget {
  static const routeName = '/cadastros/inspecao';
  const InspecaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWeb = Plataforma.isWeb;
    final width = MediaQuery.of(context).size.width;
    return ControllerScope(
      create: (context) => InspecaoController(
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
                  'Inspeções',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Observer(
                  builder: (_) {
                    return ISFetch(
                      future: controller.inspecoesLoading,
                      onReload: () => controller.fetch(),
                      child: controller.inspecoes != null &&
                              controller.inspecoes!.isNotEmpty
                          ? Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      itemBuilder: (context, index) {
                                        final inspecao =
                                            controller.inspecoes![index];
                                        return InspecaoCard(inspecao: inspecao);
                                      },
                                      itemCount: controller.inspecoes!.length,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ISButton(
                                    onPressed: () async {
                                      controller.cadastroInspecaoStore.clear();
                                      await Navigator.of(context).pushNamed(
                                        AddEditInspecaoPage.routeName,
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
                                              'Bem vindo(a) ao cadastro de inspeções!',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                        const TextSpan(
                                          text:
                                              '\nAqui você pode cadastrar inspeções para serem realizadas em veículos e equipamentos da sua empresa.',
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
                                        AddEditInspecaoPage.routeName,
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

class InspecaoCard extends StatelessWidget {
  final Inspecao inspecao;
  const InspecaoCard({super.key, required this.inspecao});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = ControllerScope.of<InspecaoController>(context);
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
            isThreeLine: true,
            onTap: () async {
              if (controller.usuario.type == UserType.master ||
                  controller.usuario.empresa == inspecao.empresa) {
                controller.cadastroInspecaoStore.setInspecao(inspecao);
                await Navigator.of(context).pushNamed(
                  AddEditInspecaoPage.routeName,
                );
                controller.fetch();
              }
            },
            title: Text(
              inspecao.nome!,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.tertiary,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text.rich(
              TextSpan(children: [
                TextSpan(text: inspecao.descricao ?? ''),
                controller.usuario.type != UserType.master &&
                        controller.usuario.empresa != inspecao.empresa
                    ? TextSpan(
                        text: '(Bloqueado)',
                        style: theme.textTheme.bodySmall!
                            .copyWith(color: Colors.red),
                      )
                    : const TextSpan(),
              ]),
              style: theme.textTheme.bodySmall!.copyWith(
                color: theme.colorScheme.primary,
              ),
              softWrap: true,
              maxLines: 2,
            ),
            trailing: controller.usuario.type == UserType.master ||
                    controller.usuario.empresa == inspecao.empresa
                ? ISFutureButton(
                    futureBuilder: (_) => controller.delete(inspecao.id!),
                    confirmText: 'Tem certeza que deseja excluir a inspeção?',
                    isIconButton: true,
                    onOk: (_, __) => controller.fetch(),
                    child: const Icon(Icons.delete_outline, color: Colors.red),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

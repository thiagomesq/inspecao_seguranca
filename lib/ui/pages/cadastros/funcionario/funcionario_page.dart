import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:inspecao_seguranca/core/models/funcionario.dart';
import 'package:inspecao_seguranca/core/models/plataforma.dart';
import 'package:inspecao_seguranca/ui/pages/cadastros/funcionario/add_edit/add_edit_page.dart';
import 'package:inspecao_seguranca/ui/pages/cadastros/funcionario/funcionario_controller.dart';
import 'package:inspecao_seguranca/ui/shared/controller_provider.dart';
import 'package:inspecao_seguranca/ui/shared/is_app_bar.dart';
import 'package:inspecao_seguranca/ui/shared/is_button.dart';
import 'package:inspecao_seguranca/ui/shared/is_fetch.dart';
import 'package:inspecao_seguranca/ui/shared/is_future_button.dart';

class FuncionarioPage extends StatelessWidget {
  static const routeName = '/cadastros/funcionario';
  const FuncionarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWeb = Plataforma.isWeb;
    final width = MediaQuery.of(context).size.width;
    return ControllerScope(
      create: (context) => FuncionarioController(
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
                  'Funcionários',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Observer(
                  builder: (_) {
                    return ISFetch(
                      future: controller.funcionariosLoading,
                      onReload: () => controller.fetch(),
                      child: controller.funcionarios != null &&
                              controller.funcionarios!.isNotEmpty
                          ? Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      itemBuilder: (context, index) {
                                        final funcionario =
                                            controller.funcionarios![index];
                                        return FuncioarioCard(
                                            funcionario: funcionario);
                                      },
                                      itemCount:
                                          controller.funcionarios!.length,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ISButton(
                                    onPressed: () async {
                                      controller.cadastroFuncionarioStore
                                          .clear();
                                      await Navigator.of(context).pushNamed(
                                        AddEditFuncioarioPage.routeName,
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
                                              'Bem vindo(a) ao cadastro de funcionários!',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                        const TextSpan(
                                          text:
                                              '\nAqui você pode cadastrar, editar e excluir funcionários.',
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
                                        AddEditFuncioarioPage.routeName,
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

class FuncioarioCard extends StatelessWidget {
  final Funcionario funcionario;
  const FuncioarioCard({super.key, required this.funcionario});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = ControllerScope.of<FuncionarioController>(context);
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
              controller.cadastroFuncionarioStore.setFuncionario(funcionario);
              await Navigator.of(context).pushNamed(
                AddEditFuncioarioPage.routeName,
              );
              controller.fetch();
            },
            title: Text(
              funcionario.nome!,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.tertiary,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  funcionario.telefone!,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                funcionario.usuario != null
                    ? const Icon(Icons.check_circle_outline,
                        color: Colors.green)
                    : const SizedBox.shrink(),
              ],
            ),
            trailing: ISFutureButton(
              futureBuilder: (_) => controller.delete(funcionario),
              confirmText:
                  'Tem certeza que deseja excluir esse(a) funcionário?',
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

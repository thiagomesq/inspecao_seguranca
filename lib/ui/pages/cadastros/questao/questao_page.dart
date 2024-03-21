import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:inspecao_seguranca/core/models/plataforma.dart';
import 'package:inspecao_seguranca/core/models/questao.dart';
import 'package:inspecao_seguranca/ui/pages/cadastros/questao/add_edit/add_edit_page.dart';
import 'package:inspecao_seguranca/ui/pages/cadastros/questao/questao_controller.dart';
import 'package:inspecao_seguranca/ui/shared/controller_provider.dart';
import 'package:inspecao_seguranca/ui/shared/is_app_bar.dart';
import 'package:inspecao_seguranca/ui/shared/is_button.dart';
import 'package:inspecao_seguranca/ui/shared/is_fetch.dart';
import 'package:inspecao_seguranca/ui/shared/is_future_button.dart';

class QuestaoPage extends StatelessWidget {
  static const routeName = '/cadastros/questao';
  const QuestaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWeb = Plataforma.isWeb;
    final width = MediaQuery.of(context).size.width;
    return ControllerScope(
      create: (context) => QuestaoController(
        GetIt.I(),
        GetIt.I(),
      ),
      builder: (context, controller) {
        return Scaffold(
          appBar: ISAppBar(),
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
                  'Checklists',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Observer(
                  builder: (_) {
                    return ISFetch(
                      future: controller.questoesLoading,
                      onReload: () => controller.fetch(),
                      child: controller.questoes != null &&
                              controller.questoes!.isNotEmpty
                          ? Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      itemBuilder: (context, index) {
                                        final questao =
                                            controller.questoes![index];
                                        return QuestaoCard(questao: questao);
                                      },
                                      itemCount: controller.questoes!.length,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ISButton(
                                    onPressed: () async {
                                      controller.cadastroQuestaoStore.clear();
                                      await Navigator.of(context).pushNamed(
                                        AddEditQuestaoPage.routeName,
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
                                              'Bem vindo(a) ao cadastro de checklists!',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                        const TextSpan(
                                          text:
                                              '\nAqui você pode cadastrar checklists para serem utilizadas nas inspeções.',
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
                                        AddEditQuestaoPage.routeName,
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class QuestaoCard extends StatelessWidget {
  final Questao questao;

  const QuestaoCard({super.key, required this.questao});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = ControllerScope.of<QuestaoController>(context);
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
              controller.cadastroQuestaoStore.setQuestao(questao);
              await Navigator.of(context).pushNamed(
                AddEditQuestaoPage.routeName,
              );
              controller.fetch();
            },
            title: Text(
              questao.titulo!,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.tertiary,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: ISFutureButton(
              futureBuilder: (_) => controller.delete(questao.id!),
              confirmText: 'Tem certeza que deseja excluir esse checklist?',
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

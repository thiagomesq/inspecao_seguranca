import 'package:inspecao_seguranca/core/models/questao.dart';
import 'package:inspecao_seguranca/infra/http/services/questao_service.dart';
import 'package:inspecao_seguranca/ui/shared/controller_base/controller_base.dart';
import 'package:inspecao_seguranca/ui/stores/cadastro_questao_store.dart';
import 'package:mobx/mobx.dart';

part 'add_edit_controller.g.dart';

class AddEditQuestaoController = AddEditQuestaoControllerBase
    with _$AddEditQuestaoController;

abstract class AddEditQuestaoControllerBase extends ControllerBase with Store {
  final QuestaoService _questaoService;
  final CadastroQuestaoStore _cadastroQuestaoStore;

  AddEditQuestaoControllerBase(
    this._questaoService,
    this._cadastroQuestaoStore,
  ) {
    fetch();
  }

  @observable
  Questao? questao;

  @observable
  String? titulo;

  @computed
  bool get isFormValid => titulo != null && titulo!.isNotEmpty;

  @action
  void fetch() {
    questao = _cadastroQuestaoStore.questao;
    if (questao != null) {
      titulo = questao?.titulo;
    }
  }

  @action
  Future<void> save() async {
    if (questao == null) {
      questao = Questao(
        titulo: titulo,
      );
    } else {
      questao!.titulo = titulo;
    }
    await _questaoService.saveQuestao(questao!);
  }
}

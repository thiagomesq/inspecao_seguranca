import 'package:inspecao_seguranca/core/models/questao.dart';
import 'package:inspecao_seguranca/infra/http/services/questao_service.dart';
import 'package:inspecao_seguranca/ui/shared/controller_base/controller_base.dart';
import 'package:inspecao_seguranca/ui/stores/cadastro_questao_store.dart';
import 'package:mobx/mobx.dart';

part 'questao_controller.g.dart';

class QuestaoController = QuestaoControllerBase with _$QuestaoController;

abstract class QuestaoControllerBase extends ControllerBase with Store {
  final QuestaoService _questaoService;
  final CadastroQuestaoStore cadastroQuestaoStore;

  QuestaoControllerBase(this._questaoService, this.cadastroQuestaoStore) {
    fetch();
  }

  @observable
  ObservableFuture<ObservableList<Questao>?> questoesLoading =
      ObservableFuture.value(null);

  @observable
  ObservableList<Questao>? questoes;

  @action
  Future<void> fetch() async {
    questoesLoading = _questaoService.getQuestoes().asObservable();
    questoes = await questoesLoading;
  }

  @action
  Future<void> delete(String id) async {
    await _questaoService.deleteQuestao(id);
    questoes!.removeWhere((element) => element.id == id);
  }
}

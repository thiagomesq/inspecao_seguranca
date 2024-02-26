import 'package:inspecao_seguranca/core/models/questao.dart';
import 'package:inspecao_seguranca/core/models/tipo_veiculo.dart';
import 'package:inspecao_seguranca/infra/http/services/questao_service.dart';
import 'package:inspecao_seguranca/infra/http/services/tipo_veiculo_service.dart';
import 'package:inspecao_seguranca/ui/shared/controller_base/controller_base.dart';
import 'package:inspecao_seguranca/ui/stores/cadastro_questao_store.dart';
import 'package:mobx/mobx.dart';

part 'add_edit_controller.g.dart';

class AddEditQuestaoController = AddEditQuestaoControllerBase
    with _$AddEditQuestaoController;

abstract class AddEditQuestaoControllerBase extends ControllerBase with Store {
  final QuestaoService _questaoService;
  final TipoVeiculoService _tipoVeiculoService;
  final CadastroQuestaoStore _cadastroQuestaoStore;

  AddEditQuestaoControllerBase(
    this._questaoService,
    this._tipoVeiculoService,
    this._cadastroQuestaoStore,
  ) {
    fetch();
  }

  @observable
  ObservableFuture<ObservableList<TipoVeiculo>?> tvsLoading =
      ObservableFuture.value(null);

  @observable
  ObservableList<TipoVeiculo>? tvs;

  @observable
  Questao? questao;

  @observable
  String? titulo;

  @observable
  ObservableList<String> tiposVeiculo = <String>[].asObservable();

  @observable
  String tipoVeiculo = '';

  @computed
  bool get isFormValid =>
      titulo != null && titulo!.isNotEmpty && tiposVeiculo.isNotEmpty;

  @action
  Future<void> fetch() async {
    tvsLoading = ObservableFuture(_tipoVeiculoService.getTiposVeiculo());
    tvs = await tvsLoading;
    questao = _cadastroQuestaoStore.questao;
    if (questao != null) {
      titulo = questao?.titulo;
      tiposVeiculo = questao!.tiposVeiculo!.asObservable();
    }
  }

  @action
  Future<void> save() async {
    if (questao == null) {
      questao = Questao(
        titulo: titulo,
        tiposVeiculo: tiposVeiculo,
      );
    } else {
      questao!.titulo = titulo;
      questao!.tiposVeiculo = tiposVeiculo;
    }
    await _questaoService.saveQuestao(questao!);
  }
}

import 'package:inspecao_seguranca/core/enums/user_type.dart';
import 'package:inspecao_seguranca/core/models/inspecao.dart';
import 'package:inspecao_seguranca/core/models/inspecao_questao.dart';
import 'package:inspecao_seguranca/core/models/is_usuario.dart';
import 'package:inspecao_seguranca/core/models/questao.dart';
import 'package:inspecao_seguranca/infra/http/services/inspecao_service.dart';
import 'package:inspecao_seguranca/infra/http/services/questao_service.dart';
import 'package:inspecao_seguranca/ui/shared/controller_base/controller_base.dart';
import 'package:inspecao_seguranca/ui/stores/cadastro_inspecao_store.dart';
import 'package:inspecao_seguranca/ui/stores/usuario_store.dart';
import 'package:mobx/mobx.dart';

part 'add_edit_controller.g.dart';

class AddEditInspecaoController = AddEditInspecaoControllerBase
    with _$AddEditInspecaoController;

abstract class AddEditInspecaoControllerBase extends ControllerBase with Store {
  final InspecaoService _inspecaoService;
  final QuestaoService _questaoService;
  final CadastroInspecaoStore _cadastroInspecaoStore;
  final UsuarioStore _usuarioStore;

  AddEditInspecaoControllerBase(
    this._inspecaoService,
    this._questaoService,
    this._cadastroInspecaoStore,
    this._usuarioStore,
  ) {
    fetch();
  }

  @observable
  ObservableFuture<ObservableList<Questao>?> questoesLoading =
      ObservableFuture.value(null);

  @observable
  ObservableList<Questao>? questoes;

  @observable
  Inspecao? inspecao;

  @observable
  String? nome;

  @observable
  String? descricao;

  @observable
  ObservableList<InspecaoQuestao> inspecaoQuestoes =
      <InspecaoQuestao>[].asObservable();

  @observable
  String questao = '';

  @computed
  ISUsuario get usuario => _usuarioStore.usuario!;

  @computed
  bool get isFormValid =>
      nome != null && nome!.isNotEmpty && inspecaoQuestoes.isNotEmpty;

  @action
  Future<void> fetch() async {
    questoesLoading = _questaoService.getQuestoes().asObservable();
    questoes = await questoesLoading;
    inspecao = _cadastroInspecaoStore.inspecao;
    if (inspecao != null) {
      nome = inspecao?.nome;
      descricao = inspecao?.descricao;
      inspecaoQuestoes =
          await _inspecaoService.getInspecaoQuestoes(inspecao!.id!);
    }
  }

  @action
  Future<void> save() async {
    if (inspecao == null) {
      inspecao = Inspecao(
        nome: nome,
        descricao: descricao,
        empresa: usuario.type == UserType.master ? null : usuario.empresa,
      );
    } else {
      inspecao!.nome = nome;
      inspecao!.descricao = descricao;
    }
    await _inspecaoService.saveInspecao(inspecao!);
    for (final e in inspecaoQuestoes) {
      e.inspecao = inspecao!.id;
      await _inspecaoService.saveInspecaoQuestao(e);
    }
  }
}

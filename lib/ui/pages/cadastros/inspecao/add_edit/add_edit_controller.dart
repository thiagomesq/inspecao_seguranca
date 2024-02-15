import 'package:inspecao_seguranca/core/models/inspecao.dart';
import 'package:inspecao_seguranca/infra/http/services/inspecao_service.dart';
import 'package:inspecao_seguranca/ui/shared/controller_base/controller_base.dart';
import 'package:inspecao_seguranca/ui/stores/cadastro_inspecao_store.dart';
import 'package:mobx/mobx.dart';

part 'add_edit_controller.g.dart';

class AddEditInspecaoController = AddEditInspecaoControllerBase
    with _$AddEditInspecaoController;

abstract class AddEditInspecaoControllerBase extends ControllerBase with Store {
  final InspecaoService _inspecaoService;
  final CadastroInspecaoStore _cadastroInspecaoStore;

  AddEditInspecaoControllerBase(
    this._inspecaoService,
    this._cadastroInspecaoStore,
  ) {
    fetch();
  }

  @observable
  Inspecao? inspecao;

  @observable
  String? nome;

  @observable
  String? descricao;

  @computed
  bool get isFormValid => nome != null && nome!.isNotEmpty;

  @action
  void fetch() {
    inspecao = _cadastroInspecaoStore.inspecao;
    if (inspecao != null) {
      nome = inspecao?.nome;
      descricao = inspecao?.descricao;
    }
  }

  @action
  Future<void> save() async {
    inspecao ??= Inspecao(nome: nome, descricao: descricao);
    await _inspecaoService.saveInspecao(inspecao!);
  }
}

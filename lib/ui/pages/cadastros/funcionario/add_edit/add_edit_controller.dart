import 'package:inspecao_seguranca/core/models/empresa.dart';
import 'package:inspecao_seguranca/core/models/funcionario.dart';
import 'package:inspecao_seguranca/infra/http/services/funcionario_service.dart';
import 'package:inspecao_seguranca/ui/shared/controller_base/controller_base.dart';
import 'package:inspecao_seguranca/ui/stores/cadastro_funcionario_store.dart';
import 'package:inspecao_seguranca/ui/stores/empresa_store.dart';
import 'package:mobx/mobx.dart';

part 'add_edit_controller.g.dart';

class AddEditFuncionarioController = AddEditFuncionarioControllerBase
    with _$AddEditFuncionarioController;

abstract class AddEditFuncionarioControllerBase extends ControllerBase
    with Store {
  final FuncionarioService _funcionarioService;
  final CadastroFuncionarioStore _cadastroFuncionarioStore;
  final EmpresaStore _empresaStore;

  AddEditFuncionarioControllerBase(
    this._funcionarioService,
    this._cadastroFuncionarioStore,
    this._empresaStore,
  ) {
    fetch();
  }

  @observable
  Funcionario? funcionario;

  @observable
  String? nome;

  @observable
  String? telefone;

  @computed
  Empresa get empresa => _empresaStore.empresa!;

  @computed
  bool get isFormValid =>
      nome != null &&
      nome!.isNotEmpty &&
      telefone != null &&
      telefone!.isNotEmpty;

  @action
  void fetch() {
    funcionario = _cadastroFuncionarioStore.funcionario;
    if (funcionario != null) {
      nome = funcionario!.nome;
      telefone = funcionario!.telefone;
    }
  }

  @action
  Future<void> save() async {
    if (funcionario == null) {
      funcionario = Funcionario(
        nome: nome,
        telefone: telefone,
        empresa: empresa.id,
      );
    } else {
      funcionario!.nome = nome;
      funcionario!.telefone = telefone;
    }
    await _funcionarioService.saveFuncionario(funcionario!);
  }
}

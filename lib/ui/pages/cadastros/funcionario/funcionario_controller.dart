import 'package:inspecao_seguranca/core/models/empresa.dart';
import 'package:inspecao_seguranca/core/models/funcionario.dart';
import 'package:inspecao_seguranca/infra/http/services/auth_service.dart';
import 'package:inspecao_seguranca/infra/http/services/funcionario_service.dart';
import 'package:inspecao_seguranca/ui/shared/controller_base/controller_base.dart';
import 'package:inspecao_seguranca/ui/stores/cadastro_funcionario_store.dart';
import 'package:inspecao_seguranca/ui/stores/empresa_store.dart';
import 'package:mobx/mobx.dart';

part 'funcionario_controller.g.dart';

class FuncionarioController = FuncionarioControllerBase
    with _$FuncionarioController;

abstract class FuncionarioControllerBase extends ControllerBase with Store {
  final FuncionarioService _fucionarioService;
  final AuthService _authService;
  final CadastroFuncionarioStore cadastroFuncionarioStore;
  final EmpresaStore _empresaStore;

  FuncionarioControllerBase(
    this._fucionarioService,
    this._authService,
    this.cadastroFuncionarioStore,
    this._empresaStore,
  ) {
    fetch();
  }

  @observable
  ObservableFuture<ObservableList<Funcionario>?> funcionariosLoading =
      ObservableFuture.value(null);

  @observable
  ObservableList<Funcionario>? funcionarios;

  @computed
  Empresa? get empresa => _empresaStore.empresa;

  @action
  Future<void> fetch() async {
    funcionariosLoading =
        _fucionarioService.getFuncionarios(empresa!.id!).asObservable();
    funcionarios = await funcionariosLoading;
  }

  @action
  Future<void> delete(Funcionario funcionario) async {
    await _fucionarioService.deleteFuncionario(funcionario.id!);
    if (funcionario.usuario != null) {
      await _authService.deleteUser(funcionario.usuario!);
    }
    funcionarios!.removeWhere((element) => element.id == funcionario.id);
  }
}

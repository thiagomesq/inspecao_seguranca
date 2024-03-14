import 'package:inspecao_seguranca/core/models/funcionario.dart';
import 'package:mobx/mobx.dart';

class CadastroFuncionarioStore with Store {
  @readonly
  Funcionario? _funcionario;

  Funcionario? get funcionario => _funcionario;

  @action
  void setFuncionario(Funcionario funcionario) {
    _funcionario = funcionario;
  }

  @action
  void clear() {
    _funcionario = null;
  }
}

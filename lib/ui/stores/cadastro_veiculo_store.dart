import 'package:inspecao_seguranca/core/models/veiculo.dart';
import 'package:mobx/mobx.dart';

class CadastroVeiculoStore with Store {
  @readonly
  Veiculo? _veiculo;

  Veiculo? get veiculo => _veiculo;

  @action
  void setVeiculo(Veiculo veiculo) {
    _veiculo = veiculo;
  }

  @action
  void clear() {
    _veiculo = null;
  }
}

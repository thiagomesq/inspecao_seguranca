import 'package:inspecao_seguranca/core/models/tipo_veiculo.dart';
import 'package:mobx/mobx.dart';

class CadastroTipoVeiculoStore with Store {
  @readonly
  TipoVeiculo? _tipoVeiculo;

  TipoVeiculo? get tipoVeiculo => _tipoVeiculo;

  @action
  void setTipoVeiculo(TipoVeiculo tipoVeiculo) {
    _tipoVeiculo = tipoVeiculo;
  }

  @action
  void clear() {
    _tipoVeiculo = null;
  }
}

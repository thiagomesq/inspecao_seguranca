import 'package:inspecao_seguranca/core/models/tipo_veiculo.dart';
import 'package:inspecao_seguranca/infra/http/services/tipo_veiculo_service.dart';
import 'package:inspecao_seguranca/ui/shared/controller_base/controller_base.dart';
import 'package:inspecao_seguranca/ui/stores/cadastro_tipo_veiculo_store.dart';
import 'package:mobx/mobx.dart';

part 'add_edit_controller.g.dart';

class AddEditTipoVeiculoController = AddEditTipoVeiculoControllerBase
    with _$AddEditTipoVeiculoController;

abstract class AddEditTipoVeiculoControllerBase extends ControllerBase
    with Store {
  final TipoVeiculoService _tipoVeiculoService;
  final CadastroTipoVeiculoStore _cadastroTipoVeiculoStore;

  AddEditTipoVeiculoControllerBase(
    this._tipoVeiculoService,
    this._cadastroTipoVeiculoStore,
  ) {
    fetch();
  }

  @observable
  TipoVeiculo? tipoVeiculo;

  @observable
  String? nome;

  @computed
  bool get isFormValid => nome != null && nome!.isNotEmpty;

  @action
  void fetch() {
    tipoVeiculo = _cadastroTipoVeiculoStore.tipoVeiculo;
    if (tipoVeiculo != null) {
      nome = tipoVeiculo?.nome;
    }
  }

  @action
  Future<void> save() async {
    if (tipoVeiculo == null) {
      tipoVeiculo = TipoVeiculo(nome: nome);
    } else {
      tipoVeiculo!.nome = nome;
    }
    await _tipoVeiculoService.saveTipoVeiculo(tipoVeiculo!);
  }
}

import 'package:inspecao_seguranca/core/models/tipo_veiculo.dart';
import 'package:inspecao_seguranca/infra/http/services/tipo_veiculo_service.dart';
import 'package:inspecao_seguranca/ui/shared/controller_base/controller_base.dart';
import 'package:inspecao_seguranca/ui/stores/cadastro_tipo_veiculo_store.dart';
import 'package:mobx/mobx.dart';

part 'tipo_veiculo_controller.g.dart';

class TipoVeiculoController = TipoVeiculoControllerBase
    with _$TipoVeiculoController;

abstract class TipoVeiculoControllerBase extends ControllerBase with Store {
  final TipoVeiculoService _tipoVeiculoService;
  final CadastroTipoVeiculoStore cadastroTipoVeiculoStore;

  TipoVeiculoControllerBase(
      this._tipoVeiculoService, this.cadastroTipoVeiculoStore) {
    fetch();
  }

  @observable
  ObservableFuture<ObservableList<TipoVeiculo>?> tipoVeiculosLoading =
      ObservableFuture.value(null);

  @observable
  ObservableList<TipoVeiculo>? tipoVeiculos;

  @action
  Future<void> fetch() async {
    tipoVeiculosLoading = _tipoVeiculoService.getTipoVeiculos().asObservable();
    tipoVeiculos = await tipoVeiculosLoading;
  }

  @action
  Future<void> delete(String id) async {
    await _tipoVeiculoService.deleteTipoVeiculo(id);
    tipoVeiculos!.removeWhere((element) => element.id == id);
  }
}

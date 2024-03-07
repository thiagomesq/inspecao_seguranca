import 'package:inspecao_seguranca/core/models/is_usuario.dart';
import 'package:inspecao_seguranca/core/models/veiculo.dart';
import 'package:inspecao_seguranca/infra/http/services/tipo_veiculo_service.dart';
import 'package:inspecao_seguranca/infra/http/services/veiculo_service.dart';
import 'package:inspecao_seguranca/ui/shared/controller_base/controller_base.dart';
import 'package:inspecao_seguranca/ui/stores/cadastro_veiculo_store.dart';
import 'package:inspecao_seguranca/ui/stores/usuario_store.dart';
import 'package:mobx/mobx.dart';

part 'veiculo_controller.g.dart';

class VeiculoController = VeiculoControllerBase with _$VeiculoController;

abstract class VeiculoControllerBase extends ControllerBase with Store {
  final VeiculoService _veiculoService;
  final TipoVeiculoService _tipoVeiculoService;
  final CadastroVeiculoStore cadastroVeiculoStore;
  final UsuarioStore _usuarioStore;

  VeiculoControllerBase(
    this._veiculoService,
    this._tipoVeiculoService,
    this.cadastroVeiculoStore,
    this._usuarioStore,
  ) {
    fetch();
  }

  @observable
  ObservableFuture<ObservableList<Veiculo>?> veiculosLoading =
      ObservableFuture.value(null);

  @observable
  ObservableList<Veiculo>? veiculos;

  @computed
  ISUsuario get usuario => _usuarioStore.usuario ?? ISUsuario();

  @action
  Future<void> fetch() async {
    veiculosLoading = _veiculoService.getVeiculos().asObservable();
    veiculos = await veiculosLoading;
    if (veiculos != null) {
      for (var veiculo in veiculos!) {
        final tipo = await _tipoVeiculoService.getTipoVeiculo(veiculo.tipo!);
        veiculo.tipo = tipo.nome;
      }
    }
  }

  @action
  Future<void> delete(String placa) async {
    await _veiculoService.deleteVeiculo(placa);
    veiculos!.removeWhere((element) => element.placa == placa);
  }
}

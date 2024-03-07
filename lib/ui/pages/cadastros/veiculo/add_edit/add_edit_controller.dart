import 'package:inspecao_seguranca/core/enums/user_type.dart';
import 'package:inspecao_seguranca/core/models/empresa.dart';
import 'package:inspecao_seguranca/core/models/is_usuario.dart';
import 'package:inspecao_seguranca/core/models/tipo_veiculo.dart';
import 'package:inspecao_seguranca/core/models/veiculo.dart';
import 'package:inspecao_seguranca/infra/http/services/empresa_service.dart';
import 'package:inspecao_seguranca/infra/http/services/tipo_veiculo_service.dart';
import 'package:inspecao_seguranca/infra/http/services/veiculo_service.dart';
import 'package:inspecao_seguranca/ui/shared/controller_base/controller_base.dart';
import 'package:inspecao_seguranca/ui/stores/cadastro_veiculo_store.dart';
import 'package:inspecao_seguranca/ui/stores/usuario_store.dart';
import 'package:mobx/mobx.dart';

part 'add_edit_controller.g.dart';

class AddEditVeiculoController = _AddEditVeiculoControllerBase
    with _$AddEditVeiculoController;

abstract class _AddEditVeiculoControllerBase extends ControllerBase with Store {
  final VeiculoService _veiculoService;
  final TipoVeiculoService _tipoVeiculoService;
  final EmpresaService _empresaService;
  final CadastroVeiculoStore _cadastroVeiculoStore;
  final UsuarioStore _usuarioStore;

  _AddEditVeiculoControllerBase(
    this._veiculoService,
    this._tipoVeiculoService,
    this._empresaService,
    this._cadastroVeiculoStore,
    this._usuarioStore,
  ) {
    fetch();
  }

  @observable
  ObservableFuture<ObservableList<TipoVeiculo>?> tiposVeiculoLoading =
      ObservableFuture.value(null);

  @observable
  ObservableList<TipoVeiculo>? tiposVeiculo;

  @observable
  ObservableList<Empresa>? empresas;

  @observable
  Veiculo? veiculo;

  @observable
  String? placa;

  @observable
  int? ano;

  @observable
  String tipo = '';

  @observable
  String empresa = '';

  @observable
  String? finalidade;

  @observable
  bool placaValid = false;

  @computed
  ISUsuario get usuario => _usuarioStore.usuario ?? ISUsuario();

  @computed
  bool get isFormValid =>
      placa != null &&
      placa!.isNotEmpty &&
      placaValid &&
      ano != null &&
      tipo.isNotEmpty &&
      empresa.isNotEmpty &&
      finalidade != null &&
      finalidade!.isNotEmpty;

  @action
  Future<void> fetch() async {
    tiposVeiculoLoading = _tipoVeiculoService.getTiposVeiculo().asObservable();
    tiposVeiculo = await tiposVeiculoLoading;
    if (usuario.type == UserType.master) {
      empresas = await _empresaService.getEmpresas().asObservable();
      empresas!.removeWhere((element) => element.id == usuario.empresa);
    } else {
      empresa = usuario.empresa!;
    }
    veiculo = _cadastroVeiculoStore.veiculo;
    if (veiculo != null) {
      placa = veiculo?.placa;
      ano = veiculo?.ano;
      tipo = veiculo!.tipo!;
      empresa = veiculo!.empresa!;
      finalidade = veiculo?.finalidade;
    }
  }

  @action
  Future<String> placaAvailable() async {
    final veiculos = await _veiculoService.getVeiculos();
    final veiculo = veiculos.firstWhere(
      (element) => element.placa == placa,
      orElse: () => Veiculo(),
    );
    if (veiculo.placa != null) {
      return 'Placa já cadastrada';
    }
    return 'Placa disponível';
  }

  @action
  Future<void> save() async {
    if (veiculo == null) {
      veiculo = Veiculo(
        placa: placa,
        ano: ano,
        tipo: tipo,
        empresa: empresa,
        finalidade: finalidade,
      );
    } else {
      veiculo!.placa = placa;
      veiculo!.ano = ano;
      veiculo!.tipo = tipo;
      veiculo!.empresa = empresa;
      veiculo!.finalidade = finalidade;
    }
    await _veiculoService.saveVeiculo(veiculo!);
  }
}

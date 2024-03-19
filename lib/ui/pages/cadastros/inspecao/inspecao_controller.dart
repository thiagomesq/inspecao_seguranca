import 'package:inspecao_seguranca/core/enums/user_type.dart';
import 'package:inspecao_seguranca/core/models/inspecao.dart';
import 'package:inspecao_seguranca/core/models/is_usuario.dart';
import 'package:inspecao_seguranca/infra/http/services/inspecao_service.dart';
import 'package:inspecao_seguranca/ui/shared/controller_base/controller_base.dart';
import 'package:inspecao_seguranca/ui/stores/cadastro_inspecao_store.dart';
import 'package:inspecao_seguranca/ui/stores/usuario_store.dart';
import 'package:mobx/mobx.dart';

part 'inspecao_controller.g.dart';

class InspecaoController = InspecaoControllerBase with _$InspecaoController;

abstract class InspecaoControllerBase extends ControllerBase with Store {
  final InspecaoService _inspecaoService;
  final CadastroInspecaoStore cadastroInspecaoStore;
  final UsuarioStore _usuarioStore;

  InspecaoControllerBase(
    this._inspecaoService,
    this.cadastroInspecaoStore,
    this._usuarioStore,
  ) {
    fetch();
  }

  @observable
  ObservableFuture<ObservableList<Inspecao>?> inspecoesLoading =
      ObservableFuture.value(null);

  @observable
  ObservableList<Inspecao>? inspecoes;

  @computed
  ISUsuario get usuario => _usuarioStore.usuario!;

  @computed
  bool get isUsuarioMaster => usuario.type == UserType.master;

  @action
  Future<void> fetch() async {
    if (isUsuarioMaster) {
      inspecoesLoading = _inspecaoService.getInspecaos().asObservable();
    } else {
      inspecoesLoading = _inspecaoService
          .getInspecaos(empresa: usuario.empresa)
          .asObservable();
    }

    inspecoes = await inspecoesLoading;
  }

  @action
  Future<void> delete(String id) async {
    await _inspecaoService.deleteInspecao(id);
    inspecoes!.removeWhere((element) => element.id == id);
  }
}

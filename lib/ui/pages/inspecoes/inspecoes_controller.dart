import 'package:inspecao_seguranca/core/enums/user_type.dart';
import 'package:inspecao_seguranca/core/models/inspecao.dart';
import 'package:inspecao_seguranca/core/models/is_usuario.dart';
import 'package:inspecao_seguranca/infra/http/services/inspecao_service.dart';
import 'package:inspecao_seguranca/ui/shared/controller_base/controller_base.dart';
import 'package:inspecao_seguranca/ui/stores/inspecao_store.dart';
import 'package:inspecao_seguranca/ui/stores/usuario_store.dart';
import 'package:mobx/mobx.dart';

part 'inspecoes_controller.g.dart';

class InspecoesController = _InspecoesControllerBase with _$InspecoesController;

abstract class _InspecoesControllerBase extends ControllerBase with Store {
  final InspecaoService _inspecaoService;
  final InspecaoStore inspecaoStore;
  final UsuarioStore _usuarioStore;

  _InspecoesControllerBase(
    this._inspecaoService,
    this.inspecaoStore,
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
}

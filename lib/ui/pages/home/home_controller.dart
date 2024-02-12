import 'package:inspecao_seguranca/core/models/is_usuario.dart';
import 'package:inspecao_seguranca/ui/shared/controller_base/controller_base.dart';
import 'package:inspecao_seguranca/ui/stores/usuario_store.dart';
import 'package:mobx/mobx.dart';

part 'home_controller.g.dart';

class HomeController = HomeControllerBase with _$HomeController;

abstract class HomeControllerBase extends ControllerBase with Store {
  final UsuarioStore _usuarioStore;

  HomeControllerBase(this._usuarioStore);

  @computed
  ISUsuario get usuario => _usuarioStore.usuario!;
}

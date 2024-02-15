import 'package:inspecao_seguranca/core/models/is_usuario.dart';
import 'package:inspecao_seguranca/ui/shared/controller_base/controller_base.dart';
import 'package:inspecao_seguranca/ui/stores/usuario_store.dart';
import 'package:mobx/mobx.dart';

part 'cadastros_controller.g.dart';

class CadastrosController = CadastrosControllerBase with _$CadastrosController;

abstract class CadastrosControllerBase extends ControllerBase with Store {
  final UsuarioStore _usuarioStore;

  CadastrosControllerBase(this._usuarioStore);

  @computed
  ISUsuario get usuario => _usuarioStore.usuario!;
}

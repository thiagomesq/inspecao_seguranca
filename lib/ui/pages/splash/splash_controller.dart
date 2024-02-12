import 'package:inspecao_seguranca/core/models/is_usuario.dart';
import 'package:inspecao_seguranca/infra/http/services/auth_service.dart';
import 'package:inspecao_seguranca/infra/http/services/empresa_service.dart';
import 'package:inspecao_seguranca/infra/http/services/user_service.dart';
import 'package:inspecao_seguranca/ui/shared/controller_base/controller_base.dart';
import 'package:inspecao_seguranca/ui/stores/empresa_store.dart';
import 'package:inspecao_seguranca/ui/stores/usuario_store.dart';
import 'package:mobx/mobx.dart';

part 'splash_controller.g.dart';

class SplashController = SplashControllerBase with _$SplashController;

abstract class SplashControllerBase extends ControllerBase with Store {
  final AuthService _authService;
  final UserService _userService;
  final UsuarioStore _usuarioStore;
  final EmpresaService _empresaService;
  final EmpresaStore _empresaStore;
  final void Function(bool isLogged, ISUsuario? usuario) onAuthenticated;

  SplashControllerBase(
    this._authService,
    this._userService,
    this._usuarioStore,
    this._empresaService,
    this._empresaStore,
    this.onAuthenticated,
  ) {
    init();
  }

  void init() async {
    final u = await _authService.getUser();
    ISUsuario? usuario;
    bool isNotNullUser = u != null;
    if (isNotNullUser) {
      usuario = await _userService.getUser(u.uid);
      if (usuario.id == null) {
        _usuarioStore.setIsNewUser(true);
      } else {
        _usuarioStore.setUser(usuario);
        final empresa = await _empresaService.getEmpresa(usuario.empresa!);
        _empresaStore.setEmpresa(empresa);
      }
    }
    onAuthenticated(isNotNullUser, usuario);
  }
}

import 'package:inspecao_seguranca/core/enums/user_type.dart';
import 'package:inspecao_seguranca/core/models/empresa.dart';
import 'package:inspecao_seguranca/core/models/is_usuario.dart';
import 'package:inspecao_seguranca/core/models/plataforma.dart';
import 'package:inspecao_seguranca/infra/http/services/auth_service.dart';
import 'package:inspecao_seguranca/infra/http/services/empresa_service.dart';
import 'package:inspecao_seguranca/infra/http/services/user_service.dart';
import 'package:inspecao_seguranca/ui/shared/controller_base/controller_base.dart';
import 'package:inspecao_seguranca/ui/stores/empresa_store.dart';
import 'package:inspecao_seguranca/ui/stores/usuario_store.dart';
import 'package:mobx/mobx.dart';

part 'usuario_controller.g.dart';

class UsuarioController = UsuarioControllerBase with _$UsuarioController;

abstract class UsuarioControllerBase extends ControllerBase with Store {
  final AuthService _authService;
  final UsuarioStore _userStore;
  final UserService _userService;
  final EmpresaStore _empresaStore;

  UsuarioControllerBase(
    this._authService,
    this._userStore,
    this._userService,
    this._empresaStore,
  ) {
    fetch();
  }

  @observable
  ObservableFuture<ISUsuario?> userLoading = ObservableFuture.value(null);

  @observable
  ISUsuario? usuario;

  @observable
  String? username;

  @computed
  Empresa get empresa => _empresaStore.empresa!;

  @computed
  bool get isNewUser => _userStore.isNewUser;

  @computed
  bool get isFormValid => username != null;

  @action
  Future<void> fetch() async {
    if (!isNewUser) {
      final u = _userStore.usuario;
      userLoading = _userService.getUser(u!.id!).asObservable();
      usuario = await userLoading;
      username = usuario!.username;
    } else {
      usuario = ISUsuario();
    }
  }

  @action
  Future<void> save() async {
    if (usuario!.id == null) {
      final u = await _authService.getUser();
      usuario!.id = u!.uid;
    }
    usuario!.empresa = empresa.id!;
    usuario!.type = Plataforma.isWeb ? UserType.admin : UserType.user;
    usuario!.username = username;
    await _authService.updateProfile(username!);
    final result = await _userService.saveUser(usuario!);
    switch (result) {
      case 'Success':
        _userStore.setUser(usuario!);
        break;
      default:
        throw Exception(result);
    }
  }
}

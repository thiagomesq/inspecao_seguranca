import 'package:inspecao_seguranca/core/models/is_usuario.dart';
import 'package:mobx/mobx.dart';

class UsuarioStore with Store {
  @readonly
  ISUsuario? _usuario;

  @readonly
  bool isNewUser = false;

  ISUsuario? get usuario => _usuario;

  @action
  void setUser(ISUsuario user) {
    _usuario = user;
  }

  @action
  void clearUser() {
    _usuario = null;
  }

  @action
  void setIsNewUser(bool value) {
    isNewUser = value;
  }
}

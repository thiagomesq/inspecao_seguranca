import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inspecao_seguranca/core/enums/user_type.dart';
import 'package:inspecao_seguranca/core/models/is_usuario.dart';
import 'package:inspecao_seguranca/core/models/plataforma.dart';
import 'package:inspecao_seguranca/infra/http/services/auth_service.dart';
import 'package:inspecao_seguranca/infra/http/services/empresa_service.dart';
import 'package:inspecao_seguranca/infra/http/services/funcionario_service.dart';
import 'package:inspecao_seguranca/infra/http/services/user_service.dart';
import 'package:inspecao_seguranca/ui/shared/controller_base/controller_base.dart';
import 'package:inspecao_seguranca/ui/stores/empresa_store.dart';
import 'package:inspecao_seguranca/ui/stores/usuario_store.dart';
import 'package:mobx/mobx.dart';

part 'login_controller.g.dart';

class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase extends ControllerBase with Store {
  final AuthService _authService;
  final UserService _userService;
  final UsuarioStore _userStore;
  final EmpresaService _empresaService;
  final EmpresaStore _empresaStore;
  final FuncionarioService _funcionarioService;
  final void Function(BuildContext context, ISUsuario? usuario, bool isNewUser)
      _onValidatedCode;

  _LoginControllerBase(
    this._authService,
    this._userService,
    this._userStore,
    this._empresaService,
    this._empresaStore,
    this._funcionarioService,
    this._onValidatedCode,
  );

  @observable
  String? phone;

  @observable
  String? smsCode;

  @observable
  String? receivedCode;

  @observable
  bool isCodeSent = false;

  @computed
  bool get isFormValid => phone != null && phone!.length == 11;

  @computed
  bool get isSmsCodeValid => smsCode != null && smsCode!.length == 6;

  @action
  void codeSent(String verificationId, int? resendToken) {
    receivedCode = verificationId;
  }

  @action
  Future<void> validateCode(BuildContext context) async {
    await _authService.auth.signInWithCredential(
      PhoneAuthProvider.credential(
        verificationId: receivedCode!,
        smsCode: smsCode!,
      ),
    );
    final usuario = await _authService.getUser();
    ISUsuario isUsuario = await _userService.getUser(usuario!.uid);
    if (isUsuario.id != null) {
      _userStore.setUser(isUsuario);
      final empresa = await _empresaService.getEmpresa(isUsuario.empresa!);
      _empresaStore.setEmpresa(empresa);
    } else {
      final funcionario =
          await _funcionarioService.getFuncionarioByPhone(phone!);
      if (Plataforma.isWeb && funcionario.id == null) {
        _userStore.setIsNewUser(true);
      } else {
        if (funcionario.id != null) {
          isUsuario.id = usuario.uid;
          isUsuario.username = funcionario.nome;
          isUsuario.empresa = funcionario.empresa;
          isUsuario.type = UserType.user;
          await _userService.saveUser(isUsuario);
          _userStore.setUser(isUsuario);
          final empresa = await _empresaService.getEmpresa(isUsuario.empresa!);
          _empresaStore.setEmpresa(empresa);
          funcionario.usuario = usuario.uid;
          await _funcionarioService.saveFuncionario(funcionario);
        } else {
          _userStore.setIsNewUser(true);
        }
      }
    }
    _onValidatedCode(context, isUsuario, _userStore.isNewUser);
  }

  @action
  Future<void> sendCode() async {
    await _authService.sendCode(
      '+55$phone',
      codeSent,
      (e) {
        print(e);
      },
    );
    isCodeSent = true;
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UsuarioController on UsuarioControllerBase, Store {
  Computed<Empresa>? _$empresaComputed;

  @override
  Empresa get empresa =>
      (_$empresaComputed ??= Computed<Empresa>(() => super.empresa,
              name: 'UsuarioControllerBase.empresa'))
          .value;
  Computed<bool>? _$isNewUserComputed;

  @override
  bool get isNewUser =>
      (_$isNewUserComputed ??= Computed<bool>(() => super.isNewUser,
              name: 'UsuarioControllerBase.isNewUser'))
          .value;
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid =>
      (_$isFormValidComputed ??= Computed<bool>(() => super.isFormValid,
              name: 'UsuarioControllerBase.isFormValid'))
          .value;

  late final _$userLoadingAtom =
      Atom(name: 'UsuarioControllerBase.userLoading', context: context);

  @override
  ObservableFuture<ISUsuario?> get userLoading {
    _$userLoadingAtom.reportRead();
    return super.userLoading;
  }

  @override
  set userLoading(ObservableFuture<ISUsuario?> value) {
    _$userLoadingAtom.reportWrite(value, super.userLoading, () {
      super.userLoading = value;
    });
  }

  late final _$usuarioAtom =
      Atom(name: 'UsuarioControllerBase.usuario', context: context);

  @override
  ISUsuario? get usuario {
    _$usuarioAtom.reportRead();
    return super.usuario;
  }

  @override
  set usuario(ISUsuario? value) {
    _$usuarioAtom.reportWrite(value, super.usuario, () {
      super.usuario = value;
    });
  }

  late final _$usernameAtom =
      Atom(name: 'UsuarioControllerBase.username', context: context);

  @override
  String? get username {
    _$usernameAtom.reportRead();
    return super.username;
  }

  @override
  set username(String? value) {
    _$usernameAtom.reportWrite(value, super.username, () {
      super.username = value;
    });
  }

  late final _$fetchAsyncAction =
      AsyncAction('UsuarioControllerBase.fetch', context: context);

  @override
  Future<void> fetch() {
    return _$fetchAsyncAction.run(() => super.fetch());
  }

  late final _$saveAsyncAction =
      AsyncAction('UsuarioControllerBase.save', context: context);

  @override
  Future<void> save() {
    return _$saveAsyncAction.run(() => super.save());
  }

  @override
  String toString() {
    return '''
userLoading: ${userLoading},
usuario: ${usuario},
username: ${username},
empresa: ${empresa},
isNewUser: ${isNewUser},
isFormValid: ${isFormValid}
    ''';
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoginController on _LoginControllerBase, Store {
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid =>
      (_$isFormValidComputed ??= Computed<bool>(() => super.isFormValid,
              name: '_LoginControllerBase.isFormValid'))
          .value;
  Computed<bool>? _$isSmsCodeValidComputed;

  @override
  bool get isSmsCodeValid =>
      (_$isSmsCodeValidComputed ??= Computed<bool>(() => super.isSmsCodeValid,
              name: '_LoginControllerBase.isSmsCodeValid'))
          .value;

  late final _$phoneAtom =
      Atom(name: '_LoginControllerBase.phone', context: context);

  @override
  String? get phone {
    _$phoneAtom.reportRead();
    return super.phone;
  }

  @override
  set phone(String? value) {
    _$phoneAtom.reportWrite(value, super.phone, () {
      super.phone = value;
    });
  }

  late final _$smsCodeAtom =
      Atom(name: '_LoginControllerBase.smsCode', context: context);

  @override
  String? get smsCode {
    _$smsCodeAtom.reportRead();
    return super.smsCode;
  }

  @override
  set smsCode(String? value) {
    _$smsCodeAtom.reportWrite(value, super.smsCode, () {
      super.smsCode = value;
    });
  }

  late final _$receivedCodeAtom =
      Atom(name: '_LoginControllerBase.receivedCode', context: context);

  @override
  String? get receivedCode {
    _$receivedCodeAtom.reportRead();
    return super.receivedCode;
  }

  @override
  set receivedCode(String? value) {
    _$receivedCodeAtom.reportWrite(value, super.receivedCode, () {
      super.receivedCode = value;
    });
  }

  late final _$isCodeSentAtom =
      Atom(name: '_LoginControllerBase.isCodeSent', context: context);

  @override
  bool get isCodeSent {
    _$isCodeSentAtom.reportRead();
    return super.isCodeSent;
  }

  @override
  set isCodeSent(bool value) {
    _$isCodeSentAtom.reportWrite(value, super.isCodeSent, () {
      super.isCodeSent = value;
    });
  }

  late final _$validateCodeAsyncAction =
      AsyncAction('_LoginControllerBase.validateCode', context: context);

  @override
  Future<void> validateCode(BuildContext context) {
    return _$validateCodeAsyncAction.run(() => super.validateCode(context));
  }

  late final _$sendCodeAsyncAction =
      AsyncAction('_LoginControllerBase.sendCode', context: context);

  @override
  Future<void> sendCode() {
    return _$sendCodeAsyncAction.run(() => super.sendCode());
  }

  late final _$_LoginControllerBaseActionController =
      ActionController(name: '_LoginControllerBase', context: context);

  @override
  void codeSent(String verificationId, int? resendToken) {
    final _$actionInfo = _$_LoginControllerBaseActionController.startAction(
        name: '_LoginControllerBase.codeSent');
    try {
      return super.codeSent(verificationId, resendToken);
    } finally {
      _$_LoginControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
phone: ${phone},
smsCode: ${smsCode},
receivedCode: ${receivedCode},
isCodeSent: ${isCodeSent},
isFormValid: ${isFormValid},
isSmsCodeValid: ${isSmsCodeValid}
    ''';
  }
}

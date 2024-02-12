// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'empresa_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EmpresaController on EmpresaControllerBase, Store {
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid =>
      (_$isFormValidComputed ??= Computed<bool>(() => super.isFormValid,
              name: 'EmpresaControllerBase.isFormValid'))
          .value;

  late final _$cnpjAtom =
      Atom(name: 'EmpresaControllerBase.cnpj', context: context);

  @override
  String? get cnpj {
    _$cnpjAtom.reportRead();
    return super.cnpj;
  }

  @override
  set cnpj(String? value) {
    _$cnpjAtom.reportWrite(value, super.cnpj, () {
      super.cnpj = value;
    });
  }

  late final _$nomeFantasiaAtom =
      Atom(name: 'EmpresaControllerBase.nomeFantasia', context: context);

  @override
  String? get nomeFantasia {
    _$nomeFantasiaAtom.reportRead();
    return super.nomeFantasia;
  }

  @override
  set nomeFantasia(String? value) {
    _$nomeFantasiaAtom.reportWrite(value, super.nomeFantasia, () {
      super.nomeFantasia = value;
    });
  }

  late final _$emailAtom =
      Atom(name: 'EmpresaControllerBase.email', context: context);

  @override
  String? get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String? value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  late final _$saveAsyncAction =
      AsyncAction('EmpresaControllerBase.save', context: context);

  @override
  Future<void> save() {
    return _$saveAsyncAction.run(() => super.save());
  }

  @override
  String toString() {
    return '''
cnpj: ${cnpj},
nomeFantasia: ${nomeFantasia},
email: ${email},
isFormValid: ${isFormValid}
    ''';
  }
}

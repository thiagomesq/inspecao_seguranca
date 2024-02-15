// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_edit_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AddEditInspecaoController on AddEditInspecaoControllerBase, Store {
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid =>
      (_$isFormValidComputed ??= Computed<bool>(() => super.isFormValid,
              name: 'AddEditInspecaoControllerBase.isFormValid'))
          .value;

  late final _$inspecaoAtom =
      Atom(name: 'AddEditInspecaoControllerBase.inspecao', context: context);

  @override
  Inspecao? get inspecao {
    _$inspecaoAtom.reportRead();
    return super.inspecao;
  }

  @override
  set inspecao(Inspecao? value) {
    _$inspecaoAtom.reportWrite(value, super.inspecao, () {
      super.inspecao = value;
    });
  }

  late final _$nomeAtom =
      Atom(name: 'AddEditInspecaoControllerBase.nome', context: context);

  @override
  String? get nome {
    _$nomeAtom.reportRead();
    return super.nome;
  }

  @override
  set nome(String? value) {
    _$nomeAtom.reportWrite(value, super.nome, () {
      super.nome = value;
    });
  }

  late final _$descricaoAtom =
      Atom(name: 'AddEditInspecaoControllerBase.descricao', context: context);

  @override
  String? get descricao {
    _$descricaoAtom.reportRead();
    return super.descricao;
  }

  @override
  set descricao(String? value) {
    _$descricaoAtom.reportWrite(value, super.descricao, () {
      super.descricao = value;
    });
  }

  late final _$saveAsyncAction =
      AsyncAction('AddEditInspecaoControllerBase.save', context: context);

  @override
  Future<void> save() {
    return _$saveAsyncAction.run(() => super.save());
  }

  late final _$AddEditInspecaoControllerBaseActionController =
      ActionController(name: 'AddEditInspecaoControllerBase', context: context);

  @override
  void fetch() {
    final _$actionInfo = _$AddEditInspecaoControllerBaseActionController
        .startAction(name: 'AddEditInspecaoControllerBase.fetch');
    try {
      return super.fetch();
    } finally {
      _$AddEditInspecaoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
inspecao: ${inspecao},
nome: ${nome},
descricao: ${descricao},
isFormValid: ${isFormValid}
    ''';
  }
}

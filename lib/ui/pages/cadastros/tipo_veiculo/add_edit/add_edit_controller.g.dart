// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_edit_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AddEditTipoVeiculoController
    on AddEditTipoVeiculoControllerBase, Store {
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid =>
      (_$isFormValidComputed ??= Computed<bool>(() => super.isFormValid,
              name: 'AddEditTipoVeiculoControllerBase.isFormValid'))
          .value;

  late final _$tipoVeiculoAtom = Atom(
      name: 'AddEditTipoVeiculoControllerBase.tipoVeiculo', context: context);

  @override
  TipoVeiculo? get tipoVeiculo {
    _$tipoVeiculoAtom.reportRead();
    return super.tipoVeiculo;
  }

  @override
  set tipoVeiculo(TipoVeiculo? value) {
    _$tipoVeiculoAtom.reportWrite(value, super.tipoVeiculo, () {
      super.tipoVeiculo = value;
    });
  }

  late final _$nomeAtom =
      Atom(name: 'AddEditTipoVeiculoControllerBase.nome', context: context);

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

  late final _$saveAsyncAction =
      AsyncAction('AddEditTipoVeiculoControllerBase.save', context: context);

  @override
  Future<void> save() {
    return _$saveAsyncAction.run(() => super.save());
  }

  late final _$AddEditTipoVeiculoControllerBaseActionController =
      ActionController(
          name: 'AddEditTipoVeiculoControllerBase', context: context);

  @override
  void fetch() {
    final _$actionInfo = _$AddEditTipoVeiculoControllerBaseActionController
        .startAction(name: 'AddEditTipoVeiculoControllerBase.fetch');
    try {
      return super.fetch();
    } finally {
      _$AddEditTipoVeiculoControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
tipoVeiculo: ${tipoVeiculo},
nome: ${nome},
isFormValid: ${isFormValid}
    ''';
  }
}

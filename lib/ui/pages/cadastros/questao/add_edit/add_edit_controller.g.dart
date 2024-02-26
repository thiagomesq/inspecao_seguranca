// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_edit_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AddEditQuestaoController on AddEditQuestaoControllerBase, Store {
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid =>
      (_$isFormValidComputed ??= Computed<bool>(() => super.isFormValid,
              name: 'AddEditQuestaoControllerBase.isFormValid'))
          .value;

  late final _$tvsLoadingAtom =
      Atom(name: 'AddEditQuestaoControllerBase.tvsLoading', context: context);

  @override
  ObservableFuture<ObservableList<TipoVeiculo>?> get tvsLoading {
    _$tvsLoadingAtom.reportRead();
    return super.tvsLoading;
  }

  @override
  set tvsLoading(ObservableFuture<ObservableList<TipoVeiculo>?> value) {
    _$tvsLoadingAtom.reportWrite(value, super.tvsLoading, () {
      super.tvsLoading = value;
    });
  }

  late final _$tvsAtom =
      Atom(name: 'AddEditQuestaoControllerBase.tvs', context: context);

  @override
  ObservableList<TipoVeiculo>? get tvs {
    _$tvsAtom.reportRead();
    return super.tvs;
  }

  @override
  set tvs(ObservableList<TipoVeiculo>? value) {
    _$tvsAtom.reportWrite(value, super.tvs, () {
      super.tvs = value;
    });
  }

  late final _$questaoAtom =
      Atom(name: 'AddEditQuestaoControllerBase.questao', context: context);

  @override
  Questao? get questao {
    _$questaoAtom.reportRead();
    return super.questao;
  }

  @override
  set questao(Questao? value) {
    _$questaoAtom.reportWrite(value, super.questao, () {
      super.questao = value;
    });
  }

  late final _$tituloAtom =
      Atom(name: 'AddEditQuestaoControllerBase.titulo', context: context);

  @override
  String? get titulo {
    _$tituloAtom.reportRead();
    return super.titulo;
  }

  @override
  set titulo(String? value) {
    _$tituloAtom.reportWrite(value, super.titulo, () {
      super.titulo = value;
    });
  }

  late final _$tiposVeiculoAtom =
      Atom(name: 'AddEditQuestaoControllerBase.tiposVeiculo', context: context);

  @override
  ObservableList<String> get tiposVeiculo {
    _$tiposVeiculoAtom.reportRead();
    return super.tiposVeiculo;
  }

  @override
  set tiposVeiculo(ObservableList<String> value) {
    _$tiposVeiculoAtom.reportWrite(value, super.tiposVeiculo, () {
      super.tiposVeiculo = value;
    });
  }

  late final _$tipoVeiculoAtom =
      Atom(name: 'AddEditQuestaoControllerBase.tipoVeiculo', context: context);

  @override
  String get tipoVeiculo {
    _$tipoVeiculoAtom.reportRead();
    return super.tipoVeiculo;
  }

  @override
  set tipoVeiculo(String value) {
    _$tipoVeiculoAtom.reportWrite(value, super.tipoVeiculo, () {
      super.tipoVeiculo = value;
    });
  }

  late final _$fetchAsyncAction =
      AsyncAction('AddEditQuestaoControllerBase.fetch', context: context);

  @override
  Future<void> fetch() {
    return _$fetchAsyncAction.run(() => super.fetch());
  }

  late final _$saveAsyncAction =
      AsyncAction('AddEditQuestaoControllerBase.save', context: context);

  @override
  Future<void> save() {
    return _$saveAsyncAction.run(() => super.save());
  }

  @override
  String toString() {
    return '''
tvsLoading: ${tvsLoading},
tvs: ${tvs},
questao: ${questao},
titulo: ${titulo},
tiposVeiculo: ${tiposVeiculo},
tipoVeiculo: ${tipoVeiculo},
isFormValid: ${isFormValid}
    ''';
  }
}

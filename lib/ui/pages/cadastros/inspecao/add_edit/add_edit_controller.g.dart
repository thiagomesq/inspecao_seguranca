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

  late final _$questoesLoadingAtom = Atom(
      name: 'AddEditInspecaoControllerBase.questoesLoading', context: context);

  @override
  ObservableFuture<ObservableList<Questao>?> get questoesLoading {
    _$questoesLoadingAtom.reportRead();
    return super.questoesLoading;
  }

  @override
  set questoesLoading(ObservableFuture<ObservableList<Questao>?> value) {
    _$questoesLoadingAtom.reportWrite(value, super.questoesLoading, () {
      super.questoesLoading = value;
    });
  }

  late final _$questoesAtom =
      Atom(name: 'AddEditInspecaoControllerBase.questoes', context: context);

  @override
  ObservableList<Questao>? get questoes {
    _$questoesAtom.reportRead();
    return super.questoes;
  }

  @override
  set questoes(ObservableList<Questao>? value) {
    _$questoesAtom.reportWrite(value, super.questoes, () {
      super.questoes = value;
    });
  }

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

  late final _$inspecaoQuestoesAtom = Atom(
      name: 'AddEditInspecaoControllerBase.inspecaoQuestoes', context: context);

  @override
  ObservableList<InspecaoQuestao> get inspecaoQuestoes {
    _$inspecaoQuestoesAtom.reportRead();
    return super.inspecaoQuestoes;
  }

  @override
  set inspecaoQuestoes(ObservableList<InspecaoQuestao> value) {
    _$inspecaoQuestoesAtom.reportWrite(value, super.inspecaoQuestoes, () {
      super.inspecaoQuestoes = value;
    });
  }

  late final _$questaoAtom =
      Atom(name: 'AddEditInspecaoControllerBase.questao', context: context);

  @override
  String get questao {
    _$questaoAtom.reportRead();
    return super.questao;
  }

  @override
  set questao(String value) {
    _$questaoAtom.reportWrite(value, super.questao, () {
      super.questao = value;
    });
  }

  late final _$fetchAsyncAction =
      AsyncAction('AddEditInspecaoControllerBase.fetch', context: context);

  @override
  Future<void> fetch() {
    return _$fetchAsyncAction.run(() => super.fetch());
  }

  late final _$saveAsyncAction =
      AsyncAction('AddEditInspecaoControllerBase.save', context: context);

  @override
  Future<void> save() {
    return _$saveAsyncAction.run(() => super.save());
  }

  @override
  String toString() {
    return '''
questoesLoading: ${questoesLoading},
questoes: ${questoes},
inspecao: ${inspecao},
nome: ${nome},
descricao: ${descricao},
inspecaoQuestoes: ${inspecaoQuestoes},
questao: ${questao},
isFormValid: ${isFormValid}
    ''';
  }
}

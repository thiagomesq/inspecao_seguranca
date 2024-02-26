// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questao_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$QuestaoController on QuestaoControllerBase, Store {
  late final _$questoesLoadingAtom =
      Atom(name: 'QuestaoControllerBase.questoesLoading', context: context);

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
      Atom(name: 'QuestaoControllerBase.questoes', context: context);

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

  late final _$fetchAsyncAction =
      AsyncAction('QuestaoControllerBase.fetch', context: context);

  @override
  Future<void> fetch() {
    return _$fetchAsyncAction.run(() => super.fetch());
  }

  late final _$deleteAsyncAction =
      AsyncAction('QuestaoControllerBase.delete', context: context);

  @override
  Future<void> delete(String id) {
    return _$deleteAsyncAction.run(() => super.delete(id));
  }

  @override
  String toString() {
    return '''
questoesLoading: ${questoesLoading},
questoes: ${questoes}
    ''';
  }
}

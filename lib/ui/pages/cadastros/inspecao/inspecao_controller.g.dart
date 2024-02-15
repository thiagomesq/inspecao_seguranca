// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspecao_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$InspecaoController on InspecaoControllerBase, Store {
  late final _$inspecoesLoadingAtom =
      Atom(name: 'InspecaoControllerBase.inspecoesLoading', context: context);

  @override
  ObservableFuture<ObservableList<Inspecao>?> get inspecoesLoading {
    _$inspecoesLoadingAtom.reportRead();
    return super.inspecoesLoading;
  }

  @override
  set inspecoesLoading(ObservableFuture<ObservableList<Inspecao>?> value) {
    _$inspecoesLoadingAtom.reportWrite(value, super.inspecoesLoading, () {
      super.inspecoesLoading = value;
    });
  }

  late final _$inspecoesAtom =
      Atom(name: 'InspecaoControllerBase.inspecoes', context: context);

  @override
  ObservableList<Inspecao>? get inspecoes {
    _$inspecoesAtom.reportRead();
    return super.inspecoes;
  }

  @override
  set inspecoes(ObservableList<Inspecao>? value) {
    _$inspecoesAtom.reportWrite(value, super.inspecoes, () {
      super.inspecoes = value;
    });
  }

  late final _$fetchAsyncAction =
      AsyncAction('InspecaoControllerBase.fetch', context: context);

  @override
  Future<void> fetch() {
    return _$fetchAsyncAction.run(() => super.fetch());
  }

  late final _$deleteAsyncAction =
      AsyncAction('InspecaoControllerBase.delete', context: context);

  @override
  Future<void> delete(String id) {
    return _$deleteAsyncAction.run(() => super.delete(id));
  }

  @override
  String toString() {
    return '''
inspecoesLoading: ${inspecoesLoading},
inspecoes: ${inspecoes}
    ''';
  }
}

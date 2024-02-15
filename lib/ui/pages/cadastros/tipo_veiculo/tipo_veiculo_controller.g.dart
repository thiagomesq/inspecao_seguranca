// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tipo_veiculo_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TipoVeiculoController on TipoVeiculoControllerBase, Store {
  late final _$tipoVeiculosLoadingAtom = Atom(
      name: 'TipoVeiculoControllerBase.tipoVeiculosLoading', context: context);

  @override
  ObservableFuture<ObservableList<TipoVeiculo>?> get tipoVeiculosLoading {
    _$tipoVeiculosLoadingAtom.reportRead();
    return super.tipoVeiculosLoading;
  }

  @override
  set tipoVeiculosLoading(
      ObservableFuture<ObservableList<TipoVeiculo>?> value) {
    _$tipoVeiculosLoadingAtom.reportWrite(value, super.tipoVeiculosLoading, () {
      super.tipoVeiculosLoading = value;
    });
  }

  late final _$tipoVeiculosAtom =
      Atom(name: 'TipoVeiculoControllerBase.tipoVeiculos', context: context);

  @override
  ObservableList<TipoVeiculo>? get tipoVeiculos {
    _$tipoVeiculosAtom.reportRead();
    return super.tipoVeiculos;
  }

  @override
  set tipoVeiculos(ObservableList<TipoVeiculo>? value) {
    _$tipoVeiculosAtom.reportWrite(value, super.tipoVeiculos, () {
      super.tipoVeiculos = value;
    });
  }

  late final _$fetchAsyncAction =
      AsyncAction('TipoVeiculoControllerBase.fetch', context: context);

  @override
  Future<void> fetch() {
    return _$fetchAsyncAction.run(() => super.fetch());
  }

  late final _$deleteAsyncAction =
      AsyncAction('TipoVeiculoControllerBase.delete', context: context);

  @override
  Future<void> delete(String id) {
    return _$deleteAsyncAction.run(() => super.delete(id));
  }

  @override
  String toString() {
    return '''
tipoVeiculosLoading: ${tipoVeiculosLoading},
tipoVeiculos: ${tipoVeiculos}
    ''';
  }
}

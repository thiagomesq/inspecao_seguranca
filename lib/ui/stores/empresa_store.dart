import 'package:inspecao_seguranca/core/models/empresa.dart';
import 'package:mobx/mobx.dart';

class EmpresaStore with Store {
  @readonly
  Empresa? _empresa;

  Empresa? get empresa => _empresa;

  @action
  void setEmpresa(Empresa empresa) {
    _empresa = empresa;
  }

  @action
  void clearEmpresa() {
    _empresa = null;
  }
}

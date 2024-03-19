import 'package:inspecao_seguranca/core/models/inspecao.dart';
import 'package:mobx/mobx.dart';

class InspecaoStore with Store {
  @readonly
  Inspecao? _inspecao;

  Inspecao? get inspecao => _inspecao;

  @action
  void setInspecao(Inspecao inspecao) {
    _inspecao = inspecao;
  }

  @action
  void clearInspecao() {
    _inspecao = null;
  }
}

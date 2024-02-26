import 'package:inspecao_seguranca/core/models/questao.dart';
import 'package:mobx/mobx.dart';

class CadastroQuestaoStore with Store {
  @readonly
  Questao? _questao;

  Questao? get questao => _questao;

  @action
  void setQuestao(Questao questao) {
    _questao = questao;
  }

  @action
  void clear() {
    _questao = null;
  }
}

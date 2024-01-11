import 'package:inspecao_seguranca/models/veiculo.dart';

class RespostaComissioVeiculo {
  final int idQuestao;
  final String questao;
  String? opcao;
  final String data;
  final String veiculo;
  String? dscNC;

  RespostaComissioVeiculo({
    required this.idQuestao,
    required this.questao,
    this.opcao,
    required this.veiculo,
    required this.data,
    this.dscNC,
  });

  factory RespostaComissioVeiculo.fromMap(Map data) {

    return RespostaComissioVeiculo(
      idQuestao: data['idQuestao'],
      data: data['data'] ?? '',
      opcao: data['opcao'] ?? '1',
      questao: data['questao'] ?? '',
      veiculo: data['veiculo'] ?? '',
      dscNC: data['dscNC'] ?? '',
    );
  }

  void changeOpcao(String opcao) {
    this.opcao = opcao;
  }
}